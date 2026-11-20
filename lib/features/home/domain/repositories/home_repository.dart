import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../entities/home_identity_entity.dart';

abstract class HomeRepository {
  Future<Result<HomeIdentityEntity, Failure>> getIdentity();
}
