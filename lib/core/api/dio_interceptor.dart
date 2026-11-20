import 'package:dio/dio.dart';

import '../../features/auth/presentation/cubit/user_cubit.dart';
import 'api_constants.dart';

final class DioInterceptors extends Interceptor {
  UserCubit? _userCubit;
  void setUserCubit(UserCubit userCubit) {
    _userCubit = userCubit;
  }

  DioInterceptors();
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers[ApiConstants.contentType] = ApiConstants.applicationJson;
    options.headers[ApiConstants.acceptLanguage] =
        _userCubit?.getCurrentLanguage() ?? 'ar';
    // if (_userCubit!.userData != null) {
    //   options.headers[ApiConstants.authorization] =
    //       '${ApiConstants.bearer} ${_userCubit!.userData?.accessToken}';
    // }
    super.onRequest(options, handler);
  }
}
