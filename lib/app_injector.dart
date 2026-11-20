import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_consumer.dart';
import 'core/api/dio_consumer.dart';
import 'core/api/dio_interceptor.dart';
import 'core/local_storage/local_storage_service.dart';
import 'core/local_storage/secure_storage_service.dart';
import 'core/local_storage/shared_pref_service.dart';
import 'core/network/network_info.dart';
import 'core/utils/constants.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/presentation/cubit/password_reset_cubit.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/services/account_photo_picker.dart';
import 'features/customers/data/datasources/customers_remote_data_source.dart';
import 'features/customers/data/repositories/customers_repository_impl.dart';
import 'features/customers/domain/repositories/customers_repository.dart';
import 'features/customers/domain/usecases/get_customers_usecase.dart';
import 'features/customers/domain/usecases/add_customer_usecase.dart';
import 'features/customers/presentation/cubit/customers_cubit.dart';
import 'features/customers/presentation/cubit/add_customer_cubit.dart';
import 'features/customers/domain/usecases/get_customer_account_usecase.dart';
import 'features/customers/domain/usecases/save_customer_movement_usecase.dart';
import 'features/customers/presentation/cubit/customer_account_cubit.dart';
import 'features/customers/presentation/cubit/save_customer_movement_cubit.dart';
import 'features/products/data/datasources/products_remote_data_source.dart';
import 'features/products/data/repositories/products_repository_impl.dart';
import 'features/products/domain/repositories/products_repository.dart';
import 'features/products/domain/usecases/get_products_usecase.dart';
import 'features/products/domain/usecases/add_product_usecase.dart';
import 'features/products/presentation/cubit/products_cubit.dart';
import 'features/products/presentation/cubit/add_product_cubit.dart';
import 'features/settings/data/datasources/settings_remote_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/load_settings_usecase.dart';
import 'features/settings/domain/usecases/save_settings_usecase.dart';
import 'features/settings/domain/usecases/sign_out_usecase.dart';
import 'features/settings/domain/usecases/export_accounts_usecase.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_home_overview_usecase.dart';
import 'features/home/presentation/cubit/home_cubit.dart';

final getIt = GetIt.instance;

class AppInjector {
  const AppInjector._();

  static Future<void> setUpGetIt() async {
    await _registerBaseDependencies();

    _setupDioInterceptors();
    _registerAuthDependencies();
    _registerCustomersDependencies();
    _registerProductsDependencies();
    _registerSettingsDependencies();
    _registerHomeDependencies();
  }

  static void _registerHomeDependencies() {
    getIt.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(getIt(), getIt()),
    );
    getIt.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton(() => GetHomeOverviewUseCase(getIt(), getIt()));
    getIt.registerFactory(() => HomeCubit(getIt()));
  }

  static void _registerProductsDependencies() {
    getIt.registerLazySingleton<ProductsRemoteDataSource>(
      () => ProductsRemoteDataSourceImpl(getIt(), getIt()),
    );
    getIt.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton(() => GetProductsUseCase(getIt()));
    getIt.registerLazySingleton(() => AddProductUseCase(getIt()));
    getIt.registerFactory(() => ProductsCubit(getIt()));
    getIt.registerFactory(() => AddProductCubit(getIt()));
  }

  static void _registerSettingsDependencies() {
    getIt.registerLazySingleton<SettingsRemoteDataSource>(
      () => SettingsRemoteDataSourceImpl(getIt(), getIt()),
    );
    getIt.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton(() => LoadSettingsUseCase(getIt()));
    getIt.registerLazySingleton(() => SaveSettingsUseCase(getIt()));
    getIt.registerLazySingleton(() => SignOutUseCase(getIt()));
    getIt.registerLazySingleton(() => ExportAccountsUseCase(getIt()));
    getIt.registerFactory(
      () => SettingsCubit(getIt(), getIt(), getIt(), getIt(), getIt()),
    );
  }

  static void _registerCustomersDependencies() {
    getIt.registerLazySingleton<CustomersRemoteDataSource>(
      () => CustomersRemoteDataSourceImpl(getIt(), getIt()),
    );
    getIt.registerLazySingleton<CustomersRepository>(
      () => CustomersRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton(() => GetCustomersUseCase(getIt()));
    getIt.registerLazySingleton(() => AddCustomerUseCase(getIt()));
    getIt.registerFactory(() => CustomersCubit(getIt()));
    getIt.registerFactory(() => AddCustomerCubit(getIt()));
    getIt.registerLazySingleton(() => GetCustomerAccountUseCase(getIt()));
    getIt.registerLazySingleton(() => SaveCustomerMovementUseCase(getIt()));
    getIt.registerFactory(() => CustomerAccountCubit(getIt()));
    getIt.registerFactory(() => SaveCustomerMovementCubit(getIt()));
  }

  static void _registerAuthDependencies() {
    getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
    getIt.registerLazySingleton<FirebaseStorage>(
      () => FirebaseStorage.instance,
    );
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));
    getIt.registerFactory(() => PasswordResetCubit(getIt()));
    getIt.registerLazySingleton(() => SignInUseCase(getIt()));
    getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
    getIt.registerFactory(() => AuthCubit(getIt(), getIt()));
    getIt.registerLazySingleton(() => AccountPhotoPicker());
  }

  static Future<void> _registerBaseDependencies() async {
    //! dio and apis injection
    getIt.registerLazySingleton<Dio>(() => Dio());

    getIt.registerLazySingleton<ApiConsumer>(
      () => DioConsumer(client: getIt<Dio>()),
    );

    getIt.registerLazySingleton<DioInterceptors>(() => DioInterceptors());

    // local storage
    const getAndroidOptions = AndroidOptions();
    FlutterSecureStorage storage = FlutterSecureStorage(
      aOptions: getAndroidOptions,
    );
    getIt.registerLazySingleton<FlutterSecureStorage>(() => storage);
    getIt.registerLazySingleton<LocalStorageService>(
      () => SecureStorageService(secureStorage: getIt<FlutterSecureStorage>()),
      instanceName: secureStorageInstanceName,
    );

    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    getIt.registerLazySingleton<LocalStorageService>(
      () => SharedPrefService(sharedPref: getIt<SharedPreferences>()),
    );

    getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnectionChecker: getIt()),
    );
    getIt.registerLazySingleton(() => InternetConnection());
  }

  static void _setupDioInterceptors() {
    final dio = getIt<Dio>();
    final dioInterceptors = getIt<DioInterceptors>();
    // final userCubit = getIt<UserCubit>();

    // dioInterceptors.setUserCubit(userCubit);

    dio.interceptors.add(dioInterceptors);
  }
}
