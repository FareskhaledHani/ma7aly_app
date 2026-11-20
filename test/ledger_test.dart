import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:ma7aly_app/core/errors/failures.dart';
import 'package:ma7aly_app/core/helpers/customer_input.dart';
import 'package:ma7aly_app/core/utils/app_strings.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_entity.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_account_entity.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_movement_entity.dart';
import 'package:ma7aly_app/features/customers/domain/entities/movement_amounts.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/save_customer_movement_usecase.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/save_customer_movement_cubit.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/save_customer_movement_state.dart';
import 'package:ma7aly_app/features/products/domain/entities/product_entity.dart';
import 'package:ma7aly_app/features/products/domain/usecases/add_product_usecase.dart';
import 'package:ma7aly_app/features/products/presentation/cubit/add_product_cubit.dart';
import 'package:ma7aly_app/features/settings/domain/entities/shop_settings_entity.dart';
import 'package:ma7aly_app/features/settings/domain/usecases/save_settings_usecase.dart';

import 'support/fake_customers_repository.dart';
import 'support/fake_products_repository.dart';
import 'support/fake_settings_repository.dart';

import 'package:ma7aly_app/features/products/data/models/product_model.dart';
import 'package:ma7aly_app/features/customers/data/models/customer_movement_model.dart';

void main() {
  test(
    'Generated product parsing accepts numeric strings without floating money',
    () {
      final product = ProductModel.fromJson({
        'id': 'p' * 22,
        'name': 'QA',
        'unit': 'kg',
        'priceMinor': '3500',
        'costMinor': null,
        'trackInventory': true,
        'stockMilli': 48000.0,
        'lowStockMilli': '5000',
      }).toEntity();
      expect(product.priceMinor, 3500);
      expect(product.stockMilli, 48000);
      expect(product.costMinor, isNull);
      expect(
        () => ProductModel.fromJson({
          'id': 'p' * 22,
          'name': 'QA',
          'unit': 'kg',
          'priceMinor': 3.5,
          'stockMilli': 0,
          'lowStockMilli': 0,
        }),
        throwsFormatException,
      );
    },
  );
  test('Movement parsing rejects missing dates before it reaches the UI', () {
    final model = CustomerMovementModel.fromJson({
      'id': 'm' * 22,
      'kind': 'withdrawal',
      'amountMinor': '7000',
      'revision': 1.0,
      'date': null,
    });
    expect(model.toEntity, throwsFormatException);
  });
  test(
    'Fractional quantities and piastres remain exact with explicit rounding',
    () {
      expect(CustomerInput.quantityMilli('١٫٢٥'), 1250);
      expect(CustomerInput.quantityMilli('1.0001'), isNull);
      expect(MovementAmounts.total(1250, 3500), 4375);
      expect(MovementAmounts.total(333, 1), 0);
      expect(MovementAmounts.total(500, 1), 1);
      expect(MovementAmounts.total(999999999, 999999999999), isNull);
    },
  );
  test(
    'Overpayment becomes credit, deleted movements do not change balances',
    () {
      final today = DateTime(2026, 11, 4);
      final customer = CustomerEntity(
        id: 'c' * 22,
        name: 'QA',
        openingBalanceMinor: 12000,
        dueDate: today,
        frequency: RepaymentFrequency.once,
      );
      final account = CustomerAccountEntity(
        customer: customer,
        movements: [
          CustomerMovementEntity(
            id: 'w' * 22,
            kind: CustomerMovementKind.withdrawal,
            amountMinor: 7000,
            date: today,
          ),
          CustomerMovementEntity(
            id: 'p' * 22,
            kind: CustomerMovementKind.payment,
            amountMinor: 20000,
            date: today,
          ),
          CustomerMovementEntity(
            id: 'd' * 22,
            kind: CustomerMovementKind.withdrawal,
            amountMinor: 10000,
            date: today,
            deleted: true,
          ),
        ],
      );
      expect(account.balanceMinor, -1000);
      expect(
        account.monthlyTotal(CustomerMovementKind.withdrawal, today),
        7000,
      );
      expect(account.summaryAt(today).statusAt(today), CustomerStatus.regular);
    },
  );
  test(
    'Warnings require confirmation and reuse the same movement ID',
    () async {
      final repository = FakeCustomersRepository();
      final calls = <SaveCustomerMovementParams>[];
      repository.movementResponse = (params) async {
        calls.add(params);
        return params.confirmCredit
            ? const Success(null)
            : const Error(ServerFailure(message: AppStrings.confirmCredit));
      };
      final cubit = SaveCustomerMovementCubit(
        SaveCustomerMovementUseCase(repository),
      );
      final params = SaveCustomerMovementParams(
        customerId: 'c' * 22,
        movement: CustomerMovementEntity(
          id: 'p' * 22,
          kind: CustomerMovementKind.payment,
          amountMinor: 20000,
          date: DateTime(2026, 11, 4),
          paymentMethod: 'cash',
        ),
      );
      await cubit.save(params);
      expect(cubit.state, isA<MovementFailure>());
      await cubit.confirm(cubit.state as MovementFailure);
      expect(cubit.state, isA<MovementSuccess>());
      expect(calls.map((p) => p.movement.id).toSet(), {params.movement.id});
      expect(calls.last.confirmCredit, isTrue);
      await cubit.close();
    },
  );
  test('A product cannot be submitted twice while a save is pending', () async {
    final repository = FakeProductsRepository();
    final response = Completer<Result<void, Failure>>();
    repository.addResponse = response.future;
    final cubit = AddProductCubit(AddProductUseCase(repository));
    final product = ProductEntity(
      id: 'p' * 22,
      name: 'QA',
      unit: 'kg',
      priceMinor: 3500,
    );
    final first = cubit.save(product);
    await cubit.save(product);
    expect(repository.addCalls, 1);
    await cubit.close();
    response.complete(const Success(null));
    await first;
  });
  test(
    'Follow-up settings reject invalid percentages before a write',
    () async {
      final repository = FakeSettingsRepository();
      final result = await SaveSettingsUseCase(repository)(
        const ShopSettingsEntity(
          shopName: 'QA',
          phone: '',
          email: 'qa@example.com',
          minimumPaymentPercent: 0,
        ),
      );
      expect(result.isError(), isTrue);
      expect(repository.saveCalls, 0);
      expect(
        CustomerFollowUpPolicy.evaluate(
          today: DateTime(2026, 11, 4),
          dueDate: DateTime(2026, 11, 3),
          outstandingMinor: 70,
          carriedDebtMinor: 0,
          monthlyWithdrawalsMinor: 100,
          monthlyPaymentsMinor: 30,
          minimumPaymentPercent: 25,
        ),
        CustomerStatus.regular,
      );
    },
  );
}
