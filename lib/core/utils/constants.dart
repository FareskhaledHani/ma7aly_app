import 'sizes.dart';

const String appName = 'Meeting Point';
// Enable only after provisioning the project's Firebase Storage bucket.
const bool profilePhotoUploadsEnabled = bool.fromEnvironment('PROFILE_PHOTOS_ENABLED');
const int makPageCount = 10;

const String appFontFamily = 'SFProDisplay';

const String appFontFamilyFallback = 'Cairo';

const String sansitaOneFontFamily = 'SansitaOne';

const double defaultPadding = Sizes.s30;

const String whiteSpace = '  ';

const String asterisk = '*';

const String colon = ':';

const String newLine = '\n';

const String ar = 'ar';

const String en = 'en';

//! cache keys constants
const String userCacheKey = 'user_cache_key';
const String isFirstAppLaunchKey = 'is_first_app_launch_key';
String secureStorageInstanceName = 'secure_storage_instance_name';
