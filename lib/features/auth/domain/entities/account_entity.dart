import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  const AccountEntity({required this.uid, required this.email});
  final String uid;
  final String email;
  @override
  List<Object?> get props => [uid, email];
}
