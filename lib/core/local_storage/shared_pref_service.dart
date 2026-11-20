import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../errors/exceptions.dart';
import '../utils/app_strings.dart';
import 'local_storage_service.dart';

final class SharedPrefService implements LocalStorageService {
  final SharedPreferences sharedPref;

  SharedPrefService({required this.sharedPref});

  @override
  Future<void> delete(String key) async {
    try {
      sharedPref.remove(key);
    } catch (e) {
      throw CacheException(message: AppStrings.somethingWentWrong.tr());
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      sharedPref.clear();
    } catch (e) {
      throw CacheException(message: AppStrings.somethingWentWrong.tr());
    }
  }

  @override
  Future<String?> readString(String key) async {
    try {
      return sharedPref.getString(key);
    } catch (e) {
      throw CacheException(message: AppStrings.somethingWentWrong.tr());
    }
  }

  @override
  Future<List<String>?> readStringList(String key) async {
    try {
      return sharedPref.getStringList(key);
    } catch (e) {
      throw CacheException(message: AppStrings.somethingWentWrong.tr());
    }
  }

  @override
  Future<void> writeString(String key, String value) async {
    try {
      sharedPref.setString(key, value);
    } catch (e) {
      throw CacheException(message: AppStrings.somethingWentWrong.tr());
    }
  }

  @override
  Future<void> writeStringList(String key, List<String> value) async {
    try {
      sharedPref.setStringList(key, value);
    } catch (e) {
      throw CacheException(message: AppStrings.somethingWentWrong.tr());
    }
  }

  @override
  Future<bool?> readBool(String key) async {
    try {
      return sharedPref.getBool(key);
    } catch (e) {
      throw CacheException(message: AppStrings.somethingWentWrong.tr());
    }
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    try {
      sharedPref.setBool(key, value);
    } catch (e) {
      throw CacheException(message: AppStrings.somethingWentWrong.tr());
    }
  }
}
