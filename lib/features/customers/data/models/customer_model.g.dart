// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) =>
    CustomerModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      openingBalanceMinor: CustomerModel._minor(json['openingBalanceMinor']),
      dueDate: CustomerModel._date(json['dueDate']),
      frequency: json['frequency'] as String? ?? 'monthly',
      repaymentDay: (json['repaymentDay'] as num?)?.toInt(),
    );
