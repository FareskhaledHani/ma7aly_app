import '../../domain/entities/account_entity.dart';

class AccountModel {
  const AccountModel({required this.uid, required this.email});
  final String uid;
  final String email;
  AccountEntity toEntity() => AccountEntity(uid: uid, email: email);
}
