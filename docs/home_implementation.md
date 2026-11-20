# تفعيل وربط Home

التصميم: [Figma Home، node 3:2536](https://www.figma.com/design/8vKxEFIPjwSMujMDZIzBhK/?node-id=3-2536).

## اللي اتنفذ

- الرئيسية أول صفحة بعد الدخول والتسجيل، وكل تبويب بيحمّل بياناته عند فتحه.
- اسم صاحب الحساب من profile.name والاسم الاحتياطي من Firebase Auth، واسم المحل من settings/shop.shopName؛ النص الاحتياطي مترجم لو البيانات ناقصة.
- إجمالي المستحقات بيجمع الأرصدة الموجبة فقط؛ رصيد الزبون الدائن مش بيقلل دين الزباين التانيين. عدد الحسابات المفتوحة في الكارت هو عدد الأرصدة الموجبة.
- تحصيلات ومسحوبات الشهر من summaries الموجودة، وتشمل كل الزباين وكل صفحات القائمة، مع نفس استبعاد الحركات المحذوفة وقواعد السداد الحالية.
- المتأخرين قبل اللي ميعادهم قرب، وبعدها بميعاد السداد. النسبة هي سداد الشهر المخصص للمسحوبات الجديدة / مسحوبات الشهر، بنفس القواعد الموجودة. الدين المرحّل المتأخر له نص واضح بدل عرض ميعاد جديد كأنه غير متأخر.
- الضغط على كارت بيفتح حسابه. الرجوع منه، إضافة زبون، فتح تبويب الرئيسية، والسحب للتحديث بيجددوا الملخص.
- الجرس بينقلك لقسم المتابعة؛ مش خدمة Push notifications جديدة.
- flutter_animate الموجودة فقط: fade/slide للعناوين والكارت الرئيسي والزرار، دخول متدرج لكروت الشهر والزباين، ونبض skeleton أثناء التحميل. مفيش dependency جديدة أو حركة لانهائية خارج التحميل.
- loading وempty وerror وإعادة المحاولة، بالعربي والإنجليزي. ألوان إضافية خاصة بـHome لضبط التصميم، من غير تغيير ألوان الشاشات السابقة.
- أيقونة الجرس الأصلية اتنزّلت محليًا من Figma، والـNavigation بتستخدم الأيقونات الموجودة. مفيش URLs مؤقتة في كود التشغيل.

## التحقق والحدود

- flutter analyze: بدون ملاحظات.
- كل 36 Flutter test نجحوا. Home بتغطي كل الصفحات، الفصل بين الدين والرصيد الدائن، ترتيب المتابعة ونسبها، فشل صفحة تالية بدون عرض مجموع ناقص، إغلاق Cubit أثناء التحميل، فتح الحساب وتحديث الملخص، والخطأ وإعادة المحاولة في اللغتين.
- معاينتان بالخط الحقيقي على 390×844 اتولدوا واتراجعوا بصريًا؛ حالة الخطأ اتاختبرت على 360×640. الـNavigation السابقة ما اتغيرش تصميمها.
- الـHome بتستخدم القراءة الحالية لحسابات الزباين: بتقرأ جميع صفحات الملخصات، والـdatasource الحالية بتقرأ تاريخ الحساب. ده يضمن حساب إجمالي كامل لكنه مكلف مع الأعداد الكبيرة، ومحتاج aggregates مستقبلًا.
- مفيش تعديل لقواعد أو schema في Firestore، ومفيش نشر قواعد جديد مطلوب للمهمة دي. مجلد المشروع مش Git repository، فـgit status/diff مش متاحين.
- نسخة APK المطلوبة Release بإعداد التوقيع الموجود: development certificate، والتوقيع الرسمي للمتجر لسه غير متجهز.
- مفيش أسئلة business معلقة؛ الرابط حدد محتوى الشاشة بدل المقترح الأول.

## الملفات الجديدة

- [lib/features/home/data/datasources/home_remote_data_source.dart](E:/work/private/ma7aly_app/lib/features/home/data/datasources/home_remote_data_source.dart)
- [lib/features/home/data/models/home_identity_model.dart](E:/work/private/ma7aly_app/lib/features/home/data/models/home_identity_model.dart)
- [lib/features/home/data/models/home_identity_model.g.dart](E:/work/private/ma7aly_app/lib/features/home/data/models/home_identity_model.g.dart)
- [lib/features/home/data/repositories/home_repository_impl.dart](E:/work/private/ma7aly_app/lib/features/home/data/repositories/home_repository_impl.dart)
- [lib/features/home/domain/entities/home_follow_up_entity.dart](E:/work/private/ma7aly_app/lib/features/home/domain/entities/home_follow_up_entity.dart)
- [lib/features/home/domain/entities/home_identity_entity.dart](E:/work/private/ma7aly_app/lib/features/home/domain/entities/home_identity_entity.dart)
- [lib/features/home/domain/entities/home_overview_entity.dart](E:/work/private/ma7aly_app/lib/features/home/domain/entities/home_overview_entity.dart)
- [lib/features/home/domain/repositories/home_repository.dart](E:/work/private/ma7aly_app/lib/features/home/domain/repositories/home_repository.dart)
- [lib/features/home/domain/usecases/get_home_overview_usecase.dart](E:/work/private/ma7aly_app/lib/features/home/domain/usecases/get_home_overview_usecase.dart)
- [lib/features/home/presentation/cubit/home_cubit.dart](E:/work/private/ma7aly_app/lib/features/home/presentation/cubit/home_cubit.dart)
- [lib/features/home/presentation/cubit/home_state.dart](E:/work/private/ma7aly_app/lib/features/home/presentation/cubit/home_state.dart)
- [lib/features/home/presentation/cubit/home_state.freezed.dart](E:/work/private/ma7aly_app/lib/features/home/presentation/cubit/home_state.freezed.dart)
- [lib/features/home/presentation/widgets/home_balance_summary.dart](E:/work/private/ma7aly_app/lib/features/home/presentation/widgets/home_balance_summary.dart)
- [lib/features/home/presentation/widgets/home_body.dart](E:/work/private/ma7aly_app/lib/features/home/presentation/widgets/home_body.dart)
- [lib/features/home/presentation/widgets/home_follow_up_card.dart](E:/work/private/ma7aly_app/lib/features/home/presentation/widgets/home_follow_up_card.dart)
- [lib/features/home/presentation/widgets/home_header.dart](E:/work/private/ma7aly_app/lib/features/home/presentation/widgets/home_header.dart)
- [lib/features/home/presentation/widgets/home_month_card.dart](E:/work/private/ma7aly_app/lib/features/home/presentation/widgets/home_month_card.dart)
- [assets/icons/home_bell.svg](E:/work/private/ma7aly_app/assets/icons/home_bell.svg)
- [test/home_test.dart](E:/work/private/ma7aly_app/test/home_test.dart)
- [test/support/fake_home_repository.dart](E:/work/private/ma7aly_app/test/support/fake_home_repository.dart)
- [docs/home_implementation.md](E:/work/private/ma7aly_app/docs/home_implementation.md)

## الملفات المعدلة

- [lib/features/home/presentation/screen/home_screen.dart](E:/work/private/ma7aly_app/lib/features/home/presentation/screen/home_screen.dart)
- [lib/app_shell.dart](E:/work/private/ma7aly_app/lib/app_shell.dart)
- [lib/app_injector.dart](E:/work/private/ma7aly_app/lib/app_injector.dart)
- [lib/core/utils/app_colors.dart](E:/work/private/ma7aly_app/lib/core/utils/app_colors.dart)
- [lib/core/utils/app_icons.dart](E:/work/private/ma7aly_app/lib/core/utils/app_icons.dart)
- [lib/core/utils/app_strings.dart](E:/work/private/ma7aly_app/lib/core/utils/app_strings.dart)
- [assets/languages/ar.json](E:/work/private/ma7aly_app/assets/languages/ar.json)
- [assets/languages/en.json](E:/work/private/ma7aly_app/assets/languages/en.json)
- [test/customers_screen_test.dart](E:/work/private/ma7aly_app/test/customers_screen_test.dart)
- [test/shop_screens_test.dart](E:/work/private/ma7aly_app/test/shop_screens_test.dart)
- [test/widget_test.dart](E:/work/private/ma7aly_app/test/widget_test.dart)
- [README.md](E:/work/private/ma7aly_app/README.md)

## مخرجات التحقق المحلية

- .dart_tool/home_visual_test.dart: أداة معاينة محلية غير ضمن كود التطبيق.
- .dart_tool/home_ar.png وhome_en.png: المعاينات.
- .dart_tool/home_test_results.log وhome_analyze.log وhome_release_build.log: نتائج التحقق والبناء.
- build/app/outputs/flutter-apk/app-release.apk: نسخة Release المحدثة.
