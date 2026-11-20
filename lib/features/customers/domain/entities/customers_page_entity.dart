import 'customer_entity.dart';

class CustomerCursor {
  const CustomerCursor({required this.value, required this.id});
  final String value;
  final String id;
}

class CustomersPageEntity {
  const CustomersPageEntity({
    required this.items,
    this.nextCursor,
    required this.hasMore,
    this.totalCount,
  });
  final List<CustomerEntity> items;
  final CustomerCursor? nextCursor;
  final bool hasMore;
  final int? totalCount;
}
