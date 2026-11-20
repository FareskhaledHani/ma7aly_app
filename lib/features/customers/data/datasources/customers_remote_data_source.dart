import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/helpers/customer_input.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/entities/customers_page_entity.dart';
import '../../domain/usecases/add_customer_usecase.dart';
import '../../domain/usecases/get_customers_usecase.dart';
import '../models/customer_model.dart';
import '../models/customer_movement_model.dart';
import '../../domain/entities/customer_account_entity.dart';
import '../../domain/entities/customer_movement_entity.dart';
import '../../domain/usecases/get_customer_account_usecase.dart';
import '../../domain/usecases/save_customer_movement_usecase.dart';

abstract class CustomersRemoteDataSource {
  Future<CustomerAccountEntity> getAccount(CustomerAccountParams params);
  Future<void> saveMovement(SaveCustomerMovementParams params);
  Future<CustomersPageEntity> getCustomers(GetCustomersParams params);
  Future<String> addCustomer(AddCustomerParams params);
}

class CustomersRemoteDataSourceImpl implements CustomersRemoteDataSource {
  CustomersRemoteDataSourceImpl(this._db, this._auth);
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw FirebaseAuthException(code: 'requires-recent-login');
    return _db.collection('users').doc(uid).collection('customers');
  }

  @override
  Future<CustomersPageEntity> getCustomers(GetCustomersParams params) async {
    final collection = _collection();
    final policy = await _policy();
    final text = CustomerInput.digits(params.query).trim();
    final isPhone = text.isNotEmpty && RegExp(r'^[+0-9 ()-]+$').hasMatch(text);
    final field = isPhone ? 'phoneKey' : 'nameKey';
    final search = isPhone
        ? CustomerInput.phoneKey(text)
        : CustomerInput.nameKey(text);
    Query<Map<String, dynamic>> base = collection
        .orderBy(field)
        .orderBy(FieldPath.documentId);
    if (search.isNotEmpty) {
      base = base
          .where(field, isGreaterThanOrEqualTo: search)
          .where(field, isLessThan: '$search\uf8ff');
    }
    final total = params.cursor == null
        ? (await collection.count().get()).count
        : null;
    final items = <CustomerEntity>[];
    CustomerCursor? cursor = params.cursor;
    bool hasMore = true;
    final size = params.pageSize.clamp(1, 50);
    // Scan bounded batches until this *filtered* page is filled or exhausted.
    // The cursor follows consumed documents, including non-matching statuses.
    while (items.length < size && hasMore) {
      var query = base.limit(size);
      if (cursor != null) query = query.startAfter([cursor.value, cursor.id]);
      final snapshot = await query.get(const GetOptions(source: Source.server));
      if (snapshot.docs.isEmpty) {
        hasMore = false;
        break;
      }
      for (var index = 0; index < snapshot.docs.length; index++) {
        final doc = snapshot.docs[index];
        final data = doc.data();
        final value = data[field];
        if (value is! String) {
          throw const FormatException('Invalid search value');
        }
        cursor = CustomerCursor(value: value, id: doc.id);
        final baseCustomer = CustomerModel.fromJson({...data, 'id': doc.id})
            .toEntity();
        final customer = (await _account(_applyPolicy(baseCustomer, policy)))
            .summaryAt(params.today);
        final status = customer.statusAt(params.today);
        final matches =
            params.filter == CustomerFilter.all ||
            params.filter == CustomerFilter.overdue &&
                status == CustomerStatus.overdue ||
            params.filter == CustomerFilter.regular &&
                status == CustomerStatus.regular;
        if (matches) items.add(customer);
        if (items.length == size) {
          hasMore =
              index < snapshot.docs.length - 1 || snapshot.docs.length == size;
          break;
        }
      }
      if (items.length < size) hasMore = snapshot.docs.length == size;
    }
    return CustomersPageEntity(
      items: items,
      nextCursor: cursor,
      hasMore: hasMore,
      totalCount: total,
    );
  }

  Future<CustomerAccountEntity> _account(CustomerEntity customer) async {
    final snapshot = await _collection()
        .doc(customer.id)
        .collection('movements')
        .orderBy('date', descending: true)
        .orderBy(FieldPath.documentId, descending: true)
        .get(const GetOptions(source: Source.server));
    final movements = snapshot.docs
        .map(
          (doc) =>
              CustomerMovementModel.fromJson({...doc.data(), 'id': doc.id})
                  .toEntity(),
        )
        .where((m) => !m.deleted)
        .toList();
    movements.sort((a, b) {
      final dateOrder = b.date.compareTo(a.date);
      if (dateOrder != 0) return dateOrder;
      final createdOrder = (b.createdAt ?? b.date).compareTo(
        a.createdAt ?? a.date,
      );
      return createdOrder != 0 ? createdOrder : b.id.compareTo(a.id);
    });
    return CustomerAccountEntity(customer: customer, movements: movements);
  }

  Future<Map<String, dynamic>> _policy() async =>
      (await _collection().parent!
              .collection('settings')
              .doc('shop')
              .get(const GetOptions(source: Source.server)))
          .data() ??
      {};

  CustomerEntity _applyPolicy(
    CustomerEntity customer,
    Map<String, dynamic> policy,
  ) {
    final percent = policy['minimumPaymentPercent'];
    final days = policy['warningDays'];
    return customer.withFollowUp(
      minimumPaymentPercent: percent is int && percent >= 1 && percent <= 100
          ? percent
          : 50,
      warningDays: days is int && days >= 0 && days <= 30 ? days : 3,
    );
  }

  @override
  Future<CustomerAccountEntity> getAccount(CustomerAccountParams params) async {
    final doc = await _collection()
        .doc(params.customerId)
        .get(const GetOptions(source: Source.server));
    final data = doc.data();
    if (data == null) {
      throw FirebaseException(plugin: 'cloud_firestore', code: 'not-found');
    }
    return _account(
      _applyPolicy(
        CustomerModel.fromJson({...data, 'id': doc.id}).toEntity(),
        await _policy(),
      ),
    );
  }

  Map<String, dynamic> _movementData(CustomerMovementEntity m, bool deleted) =>
      {
        'kind': m.kind.name,
        'amountMinor': m.amountMinor,
        'date': Timestamp.fromDate(
          DateTime.utc(m.date.year, m.date.month, m.date.day),
        ),
        if (m.quantityMilli != null) 'quantityMilli': m.quantityMilli,
        if (m.unit?.trim().isNotEmpty == true) 'unit': m.unit!.trim(),
        if (m.unitPriceMinor != null) 'unitPriceMinor': m.unitPriceMinor,
        if (m.note?.trim().isNotEmpty == true) 'note': m.note!.trim(),
        if (m.paymentMethod?.trim().isNotEmpty == true)
          'paymentMethod': m.paymentMethod!.trim(),
        if (m.productId != null) 'productId': m.productId,
        if (m.productName != null) 'productName': m.productName,
        'trackedInventory': m.trackedInventory,
        'deleted': deleted,
      };

  @override
  Future<void> saveMovement(SaveCustomerMovementParams params) async {
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        await _saveMovementAttempt(params);
        return;
      } on FirebaseException catch (error) {
        if (error.code != 'retry-concurrent-write') rethrow;
        if (attempt == 2) {
          throw FirebaseException(plugin: 'cloud_firestore', code: 'aborted');
        }
      }
    }
  }

  Future<void> _saveMovementAttempt(SaveCustomerMovementParams params) async {
    final customerRef = _collection().doc(params.customerId);
    final movementRef = customerRef
        .collection('movements')
        .doc(params.movement.id);
    final products = customerRef.parent.parent!.collection('products');
    final m = params.movement;
    final data = _movementData(m, params.delete);
    String? validationFailure;
    int? observedBalance;
    Object? observedMarker;
    final observedProducts = <String, Map<String, dynamic>>{};
    Never fail(String code) {
      validationFailure = code;
      throw FirebaseException(plugin: 'cloud_firestore', code: code);
    }

    try {
      await _db.runTransaction((tx) async {
        validationFailure = null;
        observedProducts.clear();
        final customer = await tx.get(customerRef);
        final customerData = customer.data();
        if (customerData == null) fail('not-found');
        final previous = await tx.get(movementRef);
        final oldData = previous.data();
        final old = oldData == null
            ? null
            : CustomerMovementModel.fromJson({...oldData, 'id': previous.id})
                  .toEntity();
        if (old != null &&
            old.deleted == params.delete &&
            data.entries.every((e) => oldData?[e.key] == e.value) &&
            oldData!.keys
                    .where(
                      (k) =>
                          !['revision', 'createdAt', 'updatedAt'].contains(k),
                    )
                    .length ==
                data.length &&
            (params.expectedRevision == null ||
                old.revision == params.expectedRevision! + 1)) {
          return;
        }
        if (params.expectedRevision == null && old != null) {
          fail('already-exists');
        }
        if (params.expectedRevision != null &&
            (old == null ||
                old.deleted ||
                old.revision != params.expectedRevision)) {
          fail('aborted');
        }
        if (old != null && old.kind != m.kind || params.delete && old == null) {
          fail('aborted');
        }
        final productIds = <String>{
          if (old?.productId != null) old!.productId!,
          if (m.productId != null) m.productId!,
        };
        final productSnapshots =
            <String, DocumentSnapshot<Map<String, dynamic>>>{};
        for (final id in productIds) {
          productSnapshots[id] = await tx.get(products.doc(id));
          final observed = productSnapshots[id]?.data();
          if (observed != null) observedProducts[id] = Map.of(observed);
        }
        if (!params.delete && m.productId != null) {
          final product = productSnapshots[m.productId]?.data();
          if (product == null ||
              product['trackInventory'] != m.trackedInventory ||
              product['name'] != m.productName ||
              product['unit'] != m.unit ||
              m.quantityMilli == null) {
            fail('aborted');
          }
        }
        final rawBalance =
            customerData['balanceMinor'] ?? customerData['openingBalanceMinor'];
        if (rawBalance is! int) fail('invalid-argument');
        observedBalance = rawBalance;
        observedMarker = customerData['lastMovementId'];
        final oldDelta = old == null || old.deleted ? 0 : old.balanceDelta;
        final newDelta = params.delete ? 0 : m.balanceDelta;
        final nextBalance = rawBalance - oldDelta + newDelta;
        if (nextBalance.abs() > 999999999999) fail('invalid-argument');
        if (!params.delete &&
            m.kind == CustomerMovementKind.payment &&
            nextBalance < 0 &&
            !params.confirmCredit) {
          fail('confirm-credit');
        }
        final stockUpdates = <String, int>{};
        for (final id in productIds) {
          final product = productSnapshots[id]?.data();
          if (product == null) fail('aborted');
          final raw = product['stockMilli'];
          if (raw is! int) fail('invalid-argument');
          final restored =
              old != null &&
                  !old.deleted &&
                  old.productId == id &&
                  old.trackedInventory
              ? old.quantityMilli ?? 0
              : 0;
          final deducted =
              !params.delete && m.productId == id && m.trackedInventory
              ? m.quantityMilli ?? 0
              : 0;
          final next = raw + restored - deducted;
          if (next.abs() > 999999999) fail('invalid-argument');
          if (next < 0 && deducted > restored && !params.confirmNegativeStock) {
            fail('confirm-negative-stock');
          }
          if (restored != deducted) stockUpdates[id] = next;
        }
        tx.set(movementRef, {
          ...data,
          'revision': (old?.revision ?? 0) + 1,
          'createdAt': oldData?['createdAt'] ?? FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        tx.update(customerRef, {
          'balanceMinor': nextBalance,
          'lastMovementId': m.id,
        });
        for (final entry in stockUpdates.entries) {
          tx.update(products.doc(entry.key), {
            'stockMilli': entry.value,
            'lastMovementId': m.id,
            'lastMovementCustomerId': params.customerId,
          });
        }
      });
    } catch (error) {
      // The web SDK can replace an exception thrown by a Dart transaction
      // callback. Keep our known validation code outside that JS boundary.
      final code = validationFailure;
      if (code != null) {
        throw FirebaseException(plugin: 'cloud_firestore', code: code);
      }
      // A concurrent commit may be rejected by rule evaluation before the web
      // SDK retries its read preconditions. Retry only if an authenticated
      // server read proves the customer or shared stock changed since our read.
      if (error is FirebaseException &&
          error.code == 'permission-denied' &&
          observedBalance != null) {
        final fresh = (await customerRef.get(
          const GetOptions(source: Source.server),
        )).data();
        if (fresh != null &&
            ((fresh['balanceMinor'] ?? fresh['openingBalanceMinor']) !=
                    observedBalance ||
                fresh['lastMovementId'] != observedMarker)) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'retry-concurrent-write',
          );
        }
        for (final entry in observedProducts.entries) {
          final latest =
              (await products
                      .doc(entry.key)
                      .get(const GetOptions(source: Source.server)))
                  .data();
          if (latest != null &&
              [
                'stockMilli',
                'lastMovementId',
                'lastMovementCustomerId',
              ].any((key) => latest[key] != entry.value[key])) {
            throw FirebaseException(
              plugin: 'cloud_firestore',
              code: 'retry-concurrent-write',
            );
          }
        }
      }
      rethrow;
    }
  }

  @override
  Future<String> addCustomer(AddCustomerParams params) async {
    final document = _collection().doc(params.requestId);
    final due = params.dueDate;
    final data = <String, dynamic>{
      'name': params.name.trim(),
      'nameKey': CustomerInput.nameKey(params.name),
      'phoneKey': CustomerInput.phoneKey(params.phone ?? ''),
      if (params.phone?.trim().isNotEmpty == true)
        'phone': params.phone!.trim(),
      if (params.description?.trim().isNotEmpty == true)
        'description': params.description!.trim(),
      'openingBalanceMinor': params.openingBalanceMinor,
      'dueDate': Timestamp.fromDate(DateTime.utc(due.year, due.month, due.day)),
      'frequency': params.frequency.name,
      'repaymentDay': ?params.repaymentDay,
    };
    await _db.runTransaction((transaction) async {
      final existing = await transaction.get(document);
      if (existing.exists) {
        final saved = existing.data();
        if (!data.entries.every((entry) => saved?[entry.key] == entry.value)) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'already-exists',
          );
        }
        return;
      }
      transaction.set(document, {
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
    return document.id;
  }
}
