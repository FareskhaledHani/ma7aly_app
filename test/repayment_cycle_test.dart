import 'package:flutter_test/flutter_test.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_entity.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_account_entity.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_movement_entity.dart';

void main() {
  CustomerEntity monthly() => CustomerEntity(
    id: 'c' * 22,
    name: 'QA',
    openingBalanceMinor: 10000,
    dueDate: DateTime(2026, 10, 10),
    frequency: RepaymentFrequency.monthly,
    repaymentDay: 10,
  );
  CustomerMovementEntity movement(
    String id,
    CustomerMovementKind kind,
    int amount,
    int day,
  ) => CustomerMovementEntity(
    id: id * 22,
    kind: kind,
    amountMinor: amount,
    date: DateTime(2026, 11, day),
  );

  test('Unpaid old debt stays overdue before the new monthly due date', () {
    final today = DateTime(2026, 11, 4);
    final customer = CustomerAccountEntity(
      customer: monthly(),
      movements: const [],
    ).summaryAt(today);
    expect(customer.dueDateAt(today), DateTime.utc(2026, 11, 10));
    expect(customer.overdueCarriedDebtMinor, 10000);
    expect(customer.statusAt(today), CustomerStatus.overdue);
  });
  test(
    'Payments settle old debt before counting toward the new monthly ratio',
    () {
      final today = DateTime(2026, 11, 11);
      final entries = [
        movement('w', CustomerMovementKind.withdrawal, 7000, 2),
        movement('p', CustomerMovementKind.payment, 10000, 3),
      ];
      final first = CustomerAccountEntity(
        customer: monthly(),
        movements: entries,
      ).summaryAt(today);
      expect(first.balanceMinor, 7000);
      expect(first.carriedDebtMinor, 0);
      expect(first.monthlyPaymentsMinor, 10000);
      expect(first.monthlyAppliedPaymentsMinor, 0);
      expect(first.statusAt(today), CustomerStatus.overdue);
      final halfPaid = CustomerAccountEntity(
        customer: monthly(),
        movements: [
          ...entries,
          movement('q', CustomerMovementKind.payment, 3500, 5),
        ],
      ).summaryAt(today);
      expect(halfPaid.monthlyAppliedPaymentsMinor, 3500);
      expect(halfPaid.statusAt(today), CustomerStatus.regular);
    },
  );
  test(
    'Weekly schedules use the current week and retain overdue carried debt',
    () {
      final base = CustomerEntity(
        id: 'c' * 22,
        name: 'QA',
        openingBalanceMinor: 10000,
        dueDate: DateTime(2026, 10, 30),
        frequency: RepaymentFrequency.weekly,
        repaymentDay: 5,
      );
      final today = DateTime(2026, 11, 4);
      final old = CustomerAccountEntity(
        customer: base,
        movements: const [],
      ).summaryAt(today);
      expect(old.dueDateAt(today), DateTime.utc(2026, 11, 6));
      expect(old.statusAt(today), CustomerStatus.overdue);
      final cleared = CustomerAccountEntity(
        customer: base,
        movements: [
          movement('p', CustomerMovementKind.payment, 10000, 3),
          movement('w', CustomerMovementKind.withdrawal, 7000, 4),
        ],
      ).summaryAt(today);
      expect(cleared.overdueCarriedDebtMinor, 0);
      expect(cleared.statusAt(today), CustomerStatus.upcoming);
    },
  );
  test('Cycle dates clamp month end and never precede the first due date', () {
    final endOfMonth = CustomerEntity(
      id: 'c' * 22,
      name: 'QA',
      openingBalanceMinor: 0,
      dueDate: DateTime(2027, 1, 31),
      frequency: RepaymentFrequency.monthly,
      repaymentDay: 31,
    );
    expect(
      endOfMonth.dueDateAt(DateTime(2027, 2, 1)),
      DateTime.utc(2027, 2, 28),
    );
    expect(
      endOfMonth.dueDateAt(DateTime(2028, 2, 1)),
      DateTime.utc(2028, 2, 29),
    );
    final notStarted = CustomerEntity(
      id: 'c' * 22,
      name: 'QA',
      openingBalanceMinor: 0,
      dueDate: DateTime(2026, 11, 13),
      frequency: RepaymentFrequency.weekly,
      repaymentDay: 5,
    );
    expect(
      notStarted.dueDateAt(DateTime(2026, 11, 4)),
      DateTime.utc(2026, 11, 13),
    );
    final once = CustomerEntity(
      id: 'c' * 22,
      name: 'QA',
      openingBalanceMinor: 0,
      dueDate: DateTime(2026, 11, 10),
      frequency: RepaymentFrequency.once,
    );
    expect(once.dueDateAt(DateTime(2026, 12, 4)), DateTime.utc(2026, 11, 10));
  });
}
