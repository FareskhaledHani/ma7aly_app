import 'package:multiple_result/multiple_result.dart';
import 'package:ma7aly_app/core/errors/failures.dart';
import 'package:ma7aly_app/features/home/domain/entities/home_identity_entity.dart';
import 'package:ma7aly_app/features/home/domain/repositories/home_repository.dart';

class FakeHomeRepository implements HomeRepository {
  Result<HomeIdentityEntity, Failure> response = const Success(
    HomeIdentityEntity(ownerName: 'QA Owner', shopName: 'QA Shop'),
  );
  @override
  Future<Result<HomeIdentityEntity, Failure>> getIdentity() async => response;
}
