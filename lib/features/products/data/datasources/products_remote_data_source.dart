import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/helpers/customer_input.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductEntity>> getProducts(GetProductsParams params);
  Future<void> addProduct(ProductEntity product);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  ProductsRemoteDataSourceImpl(this._db, this._auth);
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  CollectionReference<Map<String, dynamic>> _collection() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw FirebaseAuthException(code: 'requires-recent-login');
    return _db.collection('users').doc(uid).collection('products');
  }

  @override
  Future<List<ProductEntity>> getProducts(GetProductsParams params) async {
    Query<Map<String, dynamic>> query = _collection()
        .orderBy('nameKey')
        .orderBy(FieldPath.documentId);
    final search = CustomerInput.nameKey(params.query);
    if (search.isNotEmpty) {
      query = query
          .where('nameKey', isGreaterThanOrEqualTo: search)
          .where('nameKey', isLessThan: '$search\uf8ff');
    }
    var name = params.afterName;
    var id = params.afterId;
    final size = params.pageSize.clamp(1, 50);
    final items = <ProductEntity>[];
    // Keep scanning until a complete filtered page is obtained.
    while (items.length < size) {
      var page = query.limit(size);
      if (name != null && id != null) page = page.startAfter([name, id]);
      final result = await page.get(const GetOptions(source: Source.server));
      if (result.docs.isEmpty) break;
      for (final doc in result.docs) {
        final product = ProductModel.fromJson({...doc.data(), 'id': doc.id})
            .toEntity();
        name = CustomerInput.nameKey(product.name);
        id = product.id;
        final matches = switch (params.filter) {
          ProductFilter.all => true,
            ProductFilter.lowStock => product.isLowStock,
          ProductFilter.pricesOnly => !product.trackInventory,
        };
        if (matches) items.add(product);
        if (items.length == size) break;
      }
      if (result.docs.length < size) break;
    }
    return items;
  }

  @override
  Future<void> addProduct(ProductEntity p) async {
    final ref = _collection().doc(p.id);
    final data = <String, dynamic>{
      'name': p.name.trim(),
      'nameKey': CustomerInput.nameKey(p.name),
      'unit': p.unit.trim(),
      'priceMinor': p.priceMinor,
      if (p.costMinor != null) 'costMinor': p.costMinor,
      'trackInventory': p.trackInventory,
      'stockMilli': p.trackInventory ? p.stockMilli : 0,
      'lowStockMilli': p.trackInventory ? p.lowStockMilli : 0,
      if (p.extraUnit?.trim().isNotEmpty == true)
        'extraUnit': p.extraUnit!.trim(),
    };
    await _db.runTransaction((tx) async {
      final old = await tx.get(ref);
      if (old.exists) {
        if (!data.entries.every((e) => old.data()?[e.key] == e.value)) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'already-exists',
          );
        }
        return;
      }
      tx.set(ref, {...data, 'createdAt': FieldValue.serverTimestamp()});
    });
  }
}
