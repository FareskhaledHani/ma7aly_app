import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/customer_entity.dart';

part 'customer_model.g.dart';

@JsonSerializable(createToJson: false)
class CustomerModel {
  const CustomerModel({
    required this.id,
    required this.name,
    this.phone,
    this.description,
    required this.openingBalanceMinor,
    this.dueDate,
    required this.frequency,
    this.repaymentDay,
  });
  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);
  final String id;
  @JsonKey(defaultValue: '')
  final String name;
  final String? phone;
  final String? description;
  @JsonKey(fromJson: _minor)
  final int openingBalanceMinor;
  @JsonKey(fromJson: _date)
  final DateTime? dueDate;
  @JsonKey(defaultValue: 'monthly')
  final String frequency;
  final int? repaymentDay;

  CustomerEntity toEntity() {
    final due = dueDate;
    if (due == null || name.trim().isEmpty) {
      throw const FormatException('Invalid customer');
    }
    return CustomerEntity(
      id: id,
      name: name,
      phone: phone,
      description: description,
      openingBalanceMinor: openingBalanceMinor,
      dueDate: due,
      frequency: RepaymentFrequency.values.firstWhere(
        (v) => v.name == frequency,
      ),
      repaymentDay: repaymentDay,
    );
  }

  static int _minor(Object? value) {
    if (value is int) return value;
    if (value is num && value.isFinite && value == value.round()) {
      return value.toInt();
    }
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw const FormatException('Invalid amount');
  }

  static DateTime? _date(Object? value) => value is Timestamp
      ? value.toDate().toUtc()
      : value is String
      ? DateTime.tryParse(value)
      : null;
}
