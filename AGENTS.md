# AGENTS.md — قواعد المشروع (Flutter / Clean Architecture)

> ده مشروع Flutter جديد. إنت ملكش أي معرفة سابقة عنه.
> اقرأ الملف ده كله قبل ما تكتب أي كود، والتزم بيه في **كل** مهمة.
> رد عليا بالمصري مع المصطلحات التقنية بالإنجليزي.

---

## 0) طريقة الشغل (أهم قسم)

1. **اقرأ قبل ما تكتب.** قبل أي تعديل: افتح الملفات المرتبطة واقرأها، وشوف أقرب feature موجودة بتعمل نفس الحاجة وامشي على طريقتها.
2. **متخترعش pattern جديد.** لو الطريقة موجودة في المشروع، استخدمها. لو مش موجودة، اتبع القوالب اللي في الملف ده.
3. **التزم بنطاق المهمة بس.** متعدّلش في أي كود ملوش علاقة بالمطلوب، ومتعملش refactor أو rename أو نقل ملفات من نفسك.
   لو لقيت مشكلة برا النطاق: بلّغني بس، ومتعدّلهاش.
4. **متخمنش.** لو endpoint أو شكل response أو قاعدة business مش واضحة، **وقف واسألني**. متخترعش حقول أو أسماء.
5. **متضيفش dependencies جديدة** من غير ما تسألني.
6. **متكتبش tokens أو أسرار** في الكود أو في الرسايل. الـ token بييجي من الـ interceptor بس.
7. **متمسحش حاجة** (ملف، class، registration) إلا لو اتأكدت بالبحث في المشروع كله إنها مش مستخدمة.
8. **في آخر كل مهمة:** شغّل `flutter analyze` (مفيش errors جديدة)، وقولي بالظبط: الملفات اللي اتعملت، واللي اتعدلت، وأي قرار أخدته، وأي سؤال معلّق.
9. **لو اتقطعت في النص:** شغّل `git status` و `git diff` وشوف اللي اتعمل، وكمّل الناقص بس من غير ما تكرر ملف أو registration.
10. لما أقولك **`SEARCH_PATTERN`**: يعني خد feature `search` كمرجع، واقرأها كلها (data / domain / presentation / DI)، وابني الجديد بنفس الهيكل والتسميات والـ state management والـ pagination والـ loading/empty/error بالظبط.

---

## 1) الـ Stack

| الجزء | الأداة |
|---|---|
| State management | `flutter_bloc` (Cubit) + `freezed` للـ states |
| DI | `get_it` |
| Networking | `dio` + `pretty_dio_logger` (+ interceptors) |
| Error handling | `multiple_result` (`Result<Success, Failure>`) |
| Models | `json_serializable` + `json_annotation` |
| Value equality | `equatable` (للـ entities) |
| Localization | `easy_localization` (ar / en) |
| Responsive UI | `flutter_screenutil` + `gap` |
| Pagination | `infinite_scroll_pagination` |
| Local storage | `shared_preferences` (عادي) + `flutter_secure_storage` (tokens وأسرار) |
| Animations + Skeleton loading | `flutter_animate` (الأساسي لكل الأنيميشن، شوف قسم 5-ب) |
| Shimmer | `shimmer` (بس في الأماكن اللي مستخدماه فعلًا) |
| Images | `cached_network_image` + `flutter_svg` |
| Code gen | `build_runner` |

أي أداة تانية موجودة في `pubspec.yaml` استخدمها لو محتاجها، ومتضيفش بديل ليها.

---

## 2) هيكل الفولدرات

```
lib/
├── main.dart
├── app_injector.dart              # GetIt: كل الـ registrations
├── config/
│   ├── routes/                    # app_routes.dart, app_navigator.dart, route generator
│   └── theme/
├── core/
│   ├── errors/                    # failures.dart, server_exception_mixin.dart
│   ├── network/                   # dio client, interceptors, endpoints
│   ├── params/                    # no_params.dart
│   ├── use_cases/                 # main_use_case.dart (UseCase<T, P>)
│   ├── utils/                     # app_colors, app_text_styles, app_icons, app_strings, sizes, utils.dart (barrel)
│   ├── extensions/
│   ├── enums/                     # async_status.dart
│   ├── services/                  # device_id_service, storage service
│   └── widgets/                   # widgets مشتركة (main_button, svg_image, shimmer, app bars...)
└── features/
    └── <feature_name>/
        ├── data/
        │   ├── datasources/       # *_remote_data_source.dart, *_local_data_source.dart
        │   ├── models/            # *_model.dart (+ .g.dart)
        │   └── repositories/      # *_repository_impl.dart
        ├── domain/
        │   ├── entities/          # *_entity.dart
        │   ├── repositories/      # *_repository.dart (abstract)
        │   └── usecases/          # *_usecase.dart (+ params)
        └── presentation/
            ├── cubit/             # *_cubit.dart, *_state.dart (+ .freezed.dart)
            ├── screens/           # *_screen.dart
            └── widgets/           # widgets الخاصة بالـ feature
```

**تسمية:** ملفات `snake_case`، وأسماء folders بالإنجليزي الصح (`presentation` مش `presentaion`، و `usecases`).
كل widget في ملف لوحده، والشاشة تكون قصيرة وبتجمّع widgets بس.

---

## 3) قواعد الـ Layers (اتجاه الاعتماد)

```
presentation  →  domain  ←  data
```

- **domain:** Dart صافي. مفيش `flutter` ولا `dio` ولا json. فيه: Entities، Repository (abstract)، UseCases.
- **data:** بيعتمد على domain. فيه: Models، DataSources، Repository implementations.
- **presentation:** بيعتمد على domain بس. **ممنوع** يستورد model أو datasource أو repository impl.
- الـ UI **بتتعامل مع Entities** بس، مش Models.
- الـ Cubit **بينده UseCase** بس، مش repository ولا datasource مباشرة.
- Feature مبتستوردش من `data` أو `presentation` بتاعت feature تانية. لو محتاجة حاجة مشتركة: انقلها `core` أو استخدم `domain` (entity/usecase) بتاعت التانية عن طريق GetIt.

---

## 4) القوالب (Templates)

### 4.1 Core: Failure + UseCase + NoParams

```dart
// core/errors/failures.dart
abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
```

```dart
// core/params/no_params.dart
class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}

// core/use_cases/main_use_case.dart
abstract class UseCase<T, P> {
  Future<Result<T, Failure>> call(P params);
}
```

### 4.2 Core: تحويل الأخطاء في الـ Repository

```dart
// core/errors/server_exception_mixin.dart
mixin RepositoryServerExceptionMixin {
  Future<Result<T, Failure>> serverExceptionHandler<T>(
    Future<T> Function() call,
  ) async {
    try {
      return Success(await call());
    } on DioException catch (e) {
      return Error(ServerFailure(_messageFrom(e)));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
```
- رسالة الخطأ بتتاخد من body الـ backend (`message` و `errors`) لو موجودة، وإلا رسالة عامة مترجمة.
- **ممنوع** رسالة exception تقنية (زي `type 'Null' is not a subtype...`) تتعرض للمستخدم أو تتمرر لـ `.tr()`.

### 4.3 Domain: Entity

```dart
class InstructorEntity extends Equatable {
  const InstructorEntity({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, name, imageUrl];
}
```

### 4.4 Domain: Repository + UseCase + Params

```dart
// domain/repositories/instructor_repository.dart
abstract class InstructorRepository {
  Future<Result<InstructorsResponseEntity, Failure>> getInstructors(
    InstructorsParams params,
  );
}

// domain/usecases/get_instructors_usecase.dart
class GetInstructorsUseCase
    extends UseCase<InstructorsResponseEntity, InstructorsParams> {
  GetInstructorsUseCase(this.repository);
  final InstructorRepository repository;

  @override
  Future<Result<InstructorsResponseEntity, Failure>> call(
    InstructorsParams params,
  ) => repository.getInstructors(params);
}

// Params: Equatable، والحقول اللي مش مطلوبة تبقى nullable
class InstructorsParams extends Equatable {
  const InstructorsParams({
    this.filter,
    this.skipCount = 0,
    this.maxResultCount = 10,
  });
  final String? filter;
  final int skipCount;
  final int maxResultCount;

  @override
  List<Object?> get props => [filter, skipCount, maxResultCount];
}
```

### 4.5 Data: Model (parsing آمن)

```dart
@JsonSerializable(createToJson: false)
class InstructorModel {
  const InstructorModel({required this.id, required this.name, this.imageUrl});

  factory InstructorModel.fromJson(Map<String, dynamic> json) =>
      _$InstructorModelFromJson(json);

  final String id;
  final String name;
  final String? imageUrl;

  InstructorEntity toEntity() =>
      InstructorEntity(id: id, name: name, imageUrl: imageUrl);
}
```
قواعد الـ parsing (**مهمة جدًا**، الـ backend بيرجّع null وأنواع متغيرة):
- أي حقل ممكن يرجع `null` يبقى nullable، وأي object متداخل nullable.
- الـ lists: `@JsonKey(defaultValue: [])` ومتحمّلة `null`.
- الأرقام ممكن تيجي `int` أو `double` أو String: استخدم `JsonConverter` آمن (`num.tryParse`) في `core`.
- التواريخ: `DateTime.tryParse` ومش `parse` على حقل ممكن يبقى null.
- الـ Request Models: `@JsonSerializable(includeIfNull: false)` عشان أي حقل فاضي **ميتبعتش** (مش `null` ومش نص فاضي).
- أي تعديل في model: شغّل `dart run build_runner build --delete-conflicting-outputs`، ومتعدّلش `.g.dart` أو `.freezed.dart` بإيدك.

### 4.6 Data: DataSource

```dart
abstract class InstructorRemoteDataSource {
  Future<InstructorsResponseModel> getInstructors(InstructorsParams params);
}

class InstructorRemoteDataSourceImpl implements InstructorRemoteDataSource {
  InstructorRemoteDataSourceImpl(this._api);
  final ApiConsumer _api; // wrapper حوالين Dio

  @override
  Future<InstructorsResponseModel> getInstructors(InstructorsParams p) async {
    final response = await _api.get(
      EndPoints.instructors,
      queryParameters: {
        if (p.filter?.isNotEmpty == true) 'Filter': p.filter,
        'SkipCount': p.skipCount,
        'MaxResultCount': p.maxResultCount,
      },
    );
    return InstructorsResponseModel.fromJson(response);
  }
}
```
- الـ query params الاختيارية **متتبعتش لو null أو فاضية**.
- الـ endpoints كلها في `EndPoints` واحدة، مفيش URLs جوه الـ datasource.
- **Local DataSource:** نفس الشكل (abstract + impl) فوق `SharedPreferences` أو `FlutterSecureStorage`. الـ tokens والأسرار في `SecureStorage` بس.
  بيرمي `CacheException` أو بيرجّع null، والـ repository يحوّله لـ `CacheFailure`.

### 4.7 Data: Repository Impl

```dart
class InstructorRepositoryImpl
    with RepositoryServerExceptionMixin
    implements InstructorRepository {
  InstructorRepositoryImpl(this._remote);
  final InstructorRemoteDataSource _remote;

  @override
  Future<Result<InstructorsResponseEntity, Failure>> getInstructors(
    InstructorsParams params,
  ) => serverExceptionHandler(() async {
    final model = await _remote.getInstructors(params);
    return model.toEntity();
  });
}
```

### 4.8 Presentation: Cubit + State (Freezed)

نوعين من الـ states، اختار حسب الحالة:

**أ) Union states: للعمليات البسيطة (login، submit، checkout):**
```dart
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loginLoading() = LoginLoading;
  const factory AuthState.loginSuccess(UserEntity user) = LoginSuccess;
  const factory AuthState.loginFailure(String message) = LoginFailure;
}
```

**ب) State واحدة بـ `AsyncStatus`: للشاشات اللي بتحمّل أكتر من حاجة (فلاتر + قائمة):**
```dart
enum AsyncStatus { initial, loading, success, failure }

@freezed
abstract class CollegeDetailsState with _$CollegeDetailsState {
  const factory CollegeDetailsState({
    @Default(AsyncStatus.initial) AsyncStatus subjectsStatus,
    @Default([]) List<SubjectEntity> subjects,
    String? errorMessage,
  }) = _CollegeDetailsState;
}
```

**الـ Cubit:**
```dart
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._loginUseCase) : super(const AuthState.initial());
  final LoginUseCase _loginUseCase;

  Future<void> login(LoginParams params) async {
    emit(const AuthState.loginLoading());
    final result = await _loginUseCase(params);
    if (isClosed) return;
    result.when(
      (user) => emit(AuthState.loginSuccess(user)),
      (failure) => emit(AuthState.loginFailure(failure.message)),
    );
  }
}
```
- **اتشيك `isClosed`** بعد أي `await` قبل `emit`.
- Pagination: `PagingController` من `infinite_scroll_pagination`، والـ cubit بيكون فيه method `search`/`fetchPage` بتبني الـ params (`SkipCount`/`MaxResultCount`/`Filter`) وبترجّع الصفحة.
  أي تغيير في فلتر أو بحث = reset للـ pagination وإعادة الطلب. البحث بـ debounce.
- `setState` مسموح بس للحالات المحلية الصغيرة جدًا. لقوائم/قيم محلية بتتشارك بين widgets استخدم `ValueNotifier` + `ValueListenableBuilder` (ومتنساش `dispose`).

### 4.9 Presentation: Screen

```dart
class InstructorsScreen extends StatelessWidget {
  const InstructorsScreen({super.key, required this.args});
  final InstructorsArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InstructorsCubit>(),
      child: _InstructorsBody(args: args),
    );
  }
}

class _InstructorsBody extends StatefulWidget { /* ... */ }

class _InstructorsBodyState extends State<_InstructorsBody> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<InstructorsCubit>();
    Future.microtask(() => cubit.load(widget.args.id));
  }
  // build: BlocBuilder/BlocListener + widgets صغيرة
}
```
- الـ Cubit بيتعمل بـ `BlocProvider` + `getIt`، ومبيتعملش له create جديد مع كل rebuild.
- `BlocBuilder` بـ `buildWhen` لما يكون في rebuild زيادة. `BlocListener` للـ side effects (navigation، snackbar، dialog).
- **كل شاشة لازم تغطي 3 حالات:** loading (shimmer)، empty (رسالة مترجمة)، error (رسالة + زر إعادة المحاولة).
- الـ Controllers و FocusNodes و ValueNotifiers: `dispose` إلزامي.
- لو الـ Screen بتاخد بيانات من شاشة تانية: مرّر **Args class** (required) مش قيم ثابتة.

### 4.10 DI (`app_injector.dart`)

```dart
final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // core
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(getIt()));
  // data sources
  getIt.registerLazySingleton<InstructorRemoteDataSource>(
    () => InstructorRemoteDataSourceImpl(getIt()),
  );
  // repositories
  getIt.registerLazySingleton<InstructorRepository>(
    () => InstructorRepositoryImpl(getIt()),
  );
  // use cases
  getIt.registerLazySingleton(() => GetInstructorsUseCase(getIt()));
  // cubits: Factory دايمًا
  getIt.registerFactory(() => InstructorsCubit(getIt()));
}
```
- DataSources / Repositories / UseCases / Services: `registerLazySingleton`.
- Cubits: `registerFactory`.
- كل feature ليها دالة تسجيل خاصة بيها بتتنادى من `initDependencies()` لو المشروع كبر.
- لما تضيف dependency جديدة في constructor، عدّل الـ registration بتاعه في نفس اللحظة.

---

## 5) الـ UI والـ Design System

- **الألوان:** `AppColors` بس. مفيش `Color(0xFF...)` أو `Colors.xxx` hardcoded في الـ widgets (إلا `Colors.transparent`).
- **النصوص (styles):** `AppTextStyles.style{الحجم}W{الوزن}` (مثل `style14W700`, `style10W400`)، ولتغيير اللون: `.copyColorWith(AppColors.x)` (extension).
- **المسافات والأحجام:** `Sizes.sN` + `flutter_screenutil` (`.w` `.h` `.sp` `.r`) + `Gap(...)`. مفيش أرقام ثابتة بدون `.w/.h`.
- **الأيقونات:** `AppIcons` + `SvgImage.icon(AppIcons.x)`. أيقونة الـ avatar الافتراضية: `AppIcons.profile` لما `imageUrl` يبقى null/فاضي أو فشل التحميل:
  ```dart
  CircleAvatar(
    backgroundImage: hasImage ? NetworkImage(url) : null,
    child: hasImage ? null : SvgImage.icon(AppIcons.profile),
  )
  ```
- **الـ imports:** `core/utils/utils.dart` هو الـ barrel للـ utils (colors, strings, icons, styles, sizes).
- **Widgets:** صغيرة، `const` قدر الإمكان، كل واحدة في ملف، والشاشة بتجمّعها. استخدم widgets المشتركة (`MainButton`, `SvgImage`, `ShimmerLoadingContainer`, app bars) قبل ما تعمل جديدة.
- **التصميم موجود:** لما أطلب ربط API أو منطق، **متغيّرش في الألوان أو الـ spacing أو الـ layout** غير لو طلبت صراحة.
- **الـ Loading على الأزرار:** loader مكان النص بنفس حجم الزرار، والزرار يتعطّل أثناء الإرسال (ومفيش double-submit).

---

## 5-ب) الأنيميشن (`flutter_animate`)

**`flutter_animate` هي الأداة الوحيدة للأنيميشن في التطبيق كله.** (`import 'package:flutter_animate/flutter_animate.dart';`)
- متستخدمش `AnimationController` يدوي أو `AnimatedContainer`/`TweenAnimationBuilder` لأنيميشن بسيط (fade / slide / scale / pulse)، ومتضيفش package أنيميشن تانية.
- **أي list أو grid أو skeleton أو لوجو أو empty/error state بتبنيه أو بتعدّل فيه: لازم يتعمله animate** بالطرق اللي تحت.
- لما المهمة "ربط API أو منطق" على تصميم موجود ومفيش widgets بتتبني من جديد، متضيفش أنيميشن من نفسك. بس أي widget جديد أو skeleton أو list بتكتبه ياخد الأنيميشن بشكل افتراضي.

### إعداد عام (في `main()`)
```dart
Animate.defaultDuration = 300.ms;
Animate.defaultCurve = Curves.easeOut;
```

### Extension مركزية (`core/extensions/animate_extensions.dart`)
كل الأنيميشنز المتكررة تتعمل مرة واحدة هنا، والـ widgets تستخدمها بدل ما تكرر الكود:

```dart
extension AppAnimateX on Widget {
  /// نبض (fade لورا وقدام): للـ skeleton وقت التحميل
  Widget pulse() => animate(onPlay: (c) => c.repeat(reverse: true))
      .fade(begin: 0.4, end: 1, duration: 700.ms);

  /// دخول عنصر في list/grid: delay بسيط حسب الترتيب (بحد أقصى)
  Widget listItemAnimation(int index) => animate(
        delay: (index.clamp(0, 8) * 50).ms,
      ).fadeIn(duration: 300.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOut);

  /// دخول عام (عناوين، كروت، empty/error states، محتوى dialog)
  Widget fadeSlideIn({Duration delay = Duration.zero}) =>
      animate(delay: delay)
          .fadeIn(duration: 350.ms)
          .slideY(begin: 0.06, end: 0, curve: Curves.easeOut);

  /// دخول اللوجو
  Widget logoIntro({Duration delay = Duration.zero}) =>
      animate(delay: delay)
          .fadeIn(duration: 600.ms)
          .scale(
            begin: const Offset(0.85, 0.85),
            end: const Offset(1, 1),
            curve: Curves.easeOutBack,
          );
}
```

### 1) Skeleton وقت التحميل (النمط الأساسي)
كل loading لقائمة أو كارد = placeholders (`Container` بـ `AppColors.grey3`) و `.pulse()`:

```dart
class MyCourseSkeletonCard extends StatelessWidget {
  const MyCourseSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(children: [/* placeholders بأحجام .w/.h/.r */]),
    ).pulse(); // = animate(onPlay: repeat(reverse: true)).fade(begin: 0.4, end: 1, duration: 700.ms)
  }
}
```
- الـ skeleton بيتعمل في widget لوحده (`MyCourseSkeletonCard`) وبيتعرض 4 مرات تقريبًا في `ListView.separated`، بنفس شكل الكارد الحقيقي.
- كل state فيها `loading` تعرض الـ skeleton، مش `CircularProgressIndicator` (غير في الأزرار).

### 2) القوائم والـ Grids (دخول العناصر)
```dart
ListView.separated(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return CourseCard(key: ValueKey(item.id), item: item)
        .listItemAnimation(index);
  },
  separatorBuilder: (_, __) => Gap(8.h),
);
```
- `key: ValueKey(item.id)` إلزامي (عشان العنصر ميعيدش الأنيميشن مع كل rebuild).
- الـ delay بيتحدد بالـ index بحد أقصى (8 عناصر)، فمفيش انتظار طويل في القوائم الطويلة.
- مع الـ pagination (`loadMore`): العناصر الجديدة بس هي اللي تتحرك، والقديمة متعيدش.

### 3) اللوجو والصور البارزة
- اللوجو في الـ splash (Flutter) وشاشات الـ login والـ register والـ onboarding: `.logoIntro()`.
- **تحذير الـ splash:** لو فيه `flutter_native_splash` قبلها، لوجو الـ Flutter splash لازم يبقى بنفس المكان والمقاس، أو متعملش له scale من مقاس مختلف عشان مفيش قفزة "كبير وبعدين صغير". الأفضل إن الـ native splash تفضل لحد ما التطبيق يجهز (`FlutterNativeSplash.preserve` / `remove`).
- صورة الـ avatar الافتراضية (`AppIcons.profile`) والصور الكبيرة: `.fadeSlideIn()`.

### 4) باقي الأماكن
- عناوين الشاشات والكروت الأساسية بعد التحميل: `.fadeSlideIn()`.
- Empty state و Error state: `.fadeSlideIn()` (أيقونة + نص + زر إعادة المحاولة).
- محتوى الـ dialogs والـ bottom sheets (زي نجاح الإرسال): `.fadeSlideIn()`.
- الـ banners الثانوية (زي بنر الخصم) لما تظهر: `.fadeSlideIn()`.

### قواعد
- المدد بين 200 و 700 ميللي ثانية، والـ delay بحد أقصى معقول. مفيش أنيميشن طويل أو ثقيل.
- الأنيميشن اللانهائي (`repeat`) للـ skeleton بس، ومفيش غيره.
- متحطش `.animate()` على widget بيتعمل له rebuild كل frame، أو على widget `key` بتاعه بيتغير باستمرار (هيعيد الأنيميشن).
- أي أنيميشن جديد متكرر في أكتر من مكان يتحط في `AppAnimateX`، مش يتكرر في كل widget.
- الأنيميشن مش بيغيّر الـ layout أو الأحجام أو الألوان، هو بيضيف حركة بس.
- اختبر إن الشاشة مفيهاش overflow أو وميض بسبب `slide`/`scale`، وإن الـ scroll مش بيتأثر.

---

## 6) الترجمة (easy_localization)

- كل نص ظاهر للمستخدم: `AppStrings.key.tr()`. **ممنوع نص hardcoded** (عربي أو إنجليزي) في الـ UI.
- النصوص اللي فيها متغيرات: `namedArgs`/`args`، مفيش تركيب نصوص بـ `+` أو `$` على نص مترجم.
- أي key جديدة تتضاف في **كل** ملفات اللغات (`assets/languages/ar.json` و `en.json`) بترجمة طبيعية، ومتغيّرش في keys مستخدمة في أماكن تانية.
- رسائل الـ backend بتيجي باللغة اللي بتتبعت في `Accept-Language` (من الـ interceptor)، فمتترجمهاش من الـ app.
- اختبار اللغة: كل شاشة لازم تتعرض بالكامل بالعربي وبالإنجليزي من غير ظهور اسم key.

---

## 7) الـ Navigation

- `AppRoutes` فيها أسماء الـ routes (constants)، و `AppNavigator.navigateNamedTo(route, arguments: ...)` للتنقل.
- أي شاشة محتاجة بيانات تاخدها في **Args class** (required fields) من الـ `arguments`.
- متعملش `pushReplacement` أو `popUntil` إلا لو الـ flow محتاجه فعلًا (login ← home مثلًا).
- أي route جديد يتسجّل في الـ route generator.

---

## 8) الـ Networking والأمان

- `Dio` بـ `connectTimeout` و `receiveTimeout` (10 ثواني) و `pretty_dio_logger` في الـ debug بس.
- **Interceptors:**
  - `Authorization: Bearer <token>` من `SecureStorage`.
  - `Accept-Language` من لغة التطبيق الحالية.
  - معالجة `401` (refresh أو logout) في مكان واحد.
- Base URLs والـ endpoints في ملف واحد، والـ environments (staging / production) بتتبدل من إعداد واحد.
- **`deviceId`:** بيتولّد كـ UUID مرة واحدة، ويتخزن في `FlutterSecureStorage`، ويتبعت في الـ endpoints اللي بتطلبه (login و verify). خدمة واحدة `DeviceIdService` متسجلة في GetIt، ومتتكررش.
- الـ tokens في `FlutterSecureStorage` بس (مش `SharedPreferences`).
- مفيش `print`، استخدم الـ logger أو `debugPrint` وبس في الـ debug.

---

## 9) معالجة الأخطاء والـ Null-safety

- كل UseCase بيرجّع `Result<T, Failure>`، ومفيش exceptions بتعدّي الـ repository.
- الـ cubit بيحوّل الـ `Failure` لرسالة، والـ UI بتعرضها (SnackBar / رسالة / dialog حسب المشروع).
- مفيش `!` من غير داعي، ومفيش cast مباشر (`as String`) على حقل ممكن يبقى null.
- الحالات الثانوية (زي banner الخصم): لو الـ API فشل، **اخفيه بهدوء** من غير dialog، ومتعطّلش الـ flow الأساسي.

---

## 10) Checklist: إضافة feature جديدة

1. اقرأ أقرب feature مشابهة (أو `search` لو قلت `SEARCH_PATTERN`).
2. **Domain:** Entity ← Repository (abstract) ← Params ← UseCase.
3. **Data:** Model (+ `toEntity`) ← DataSource (remote، و local لو محتاج) ← Repository impl.
4. `build_runner` لتوليد `.g.dart` و `.freezed.dart`.
5. **DI:** سجّل DataSource ← Repository ← UseCase ← Cubit (Factory).
6. **Presentation:** State ← Cubit ← Screen + widgets صغيرة (loading / empty / error)، مع الأنيميشن بـ `flutter_animate` (skeleton `.pulse()`، وعناصر القوائم `.listItemAnimation(index)`، واللوجو `.logoIntro()`) حسب قسم 5-ب.
7. **Route** + **Args** لو الشاشة بتاخد بيانات.
8. **الترجمة:** keys جديدة في كل اللغات.
9. `flutter analyze` ← تقرير نهائي (الملفات، القرارات، الأسئلة المعلقة).

---

## 11) ممنوعات عامة

- ممنوع تعديل `.g.dart` / `.freezed.dart` يدويًا.
- ممنوع business logic جوه الـ widgets (مكانه UseCase أو Cubit).
- ممنوع UI يستدعي repository أو datasource مباشرة.
- ممنوع نصوص أو ألوان أو أحجام hardcoded.
- ممنوع `BuildContext` يتستخدم بعد `await` من غير `context.mounted`.
- ممنوع تكرار كود: لو widget أو validator أو converter متكرر، اعمله في `core` (بس **متعدّلش حاجة مشتركة** بتأثر على شاشات تانية من غير ما تقولي).
- ممنوع commit لأي token أو مفتاح أو ملف إعدادات سري.

---

## 12) قالب برومبت لمهمة جديدة (استخدمه معايا)

```
SEARCH_PATTERN
الشغل في feature `xxx` على `yyy` بس. مفيش تغيير في أي كود تاني ملوش علاقة.

المطلوب: ...
الـ API: METHOD /path  (params / body / response sample)
الـ UseCase/Widget الموجود: ...

الخطوات: اقرأ الأول ... ثم ...
ممنوع: ...
التحقق في الآخر: flutter analyze + السيناريوهات + قولي الملفات اللي اتعدلت.
```
