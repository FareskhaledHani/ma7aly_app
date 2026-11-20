import 'customer_entity.dart';

class RepaymentSchedule {
  const RepaymentSchedule({
    required this.frequency,
    required this.firstDueDate,
    this.day,
  });
  final RepaymentFrequency frequency;
  final DateTime firstDueDate;
  final int? day;
}
