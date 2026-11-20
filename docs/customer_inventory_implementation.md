# تقرير استكمال حسابات الزباين والمنتجات والإعدادات

اتكمل الشغل من الملفات اللي اتحفظت قبل انقطاع الكهرباء. مفيش Git في الفولدر؛
محاولتا git status وgit diff رجّعوا إنه مش repository. التصنيف تحت خاص بدورة
الشغل دي، وبيشمل الملفات اللي اتعملت قبل الانقطاع واتكملت بعده.

## النتيجة

- حساب الزبون والمسحوبات والدفعات وتعديل وحذف الحركات.
- اختيار منتج، والحفظ الذري للحركة والرصيد والمخزون، واسترجاع فرق الكمية عند التعديل أو الحذف.
- تنبيه واضح قبل رصيد دائن أو مخزون سالب؛ التأكيد بيرجع لنفس رقم الحركة.
- منتجات مع تتبع اختياري، بحث وفلاتر وصفحات، وسعر شراء وحد تنبيه.
- بيانات المحل، إعدادات متابعة، إعادة تعيين كلمة المرور، لغة، تسجيل خروج، ونسخ كشف الحسابات.
- نسخ إيصال الدفعة بعد الحفظ. النسخ للحافظة، مش مشاركة ملف من النظام.
- الرئيسية فاضية زي الطلب، ومفيش dependencies جديدة.

## التحقق

- flutter analyze خلص من غير ملاحظات، وكل 29 Flutter test نجحوا. التغطية تشمل إنشاء منتج، اختيار منتج للمسحوبات، تعديل وحذف الحركة، تنبيه المخزون السالب، تنبيه الدفعة الزائدة، الإيصال والإعدادات في اللغتين على 360×640، وتجديد دورة السداد وتخصيص الدفعات للدين القديم. اتراجعت أزرار بيانات المحل، تصدير الحسابات، الأمان، المساعدة، تبديل اللغة وتسجيل الخروج، وفلاتر وبحث المنتجات وإعادة المحاولة.
- 43 فحص صلاحيات وقواعد نجحوا على Firestore/Auth Emulator بمشروع demo محلي فقط.
- 15 سيناريو من كود Flutter الفعلي على Chrome مع المحاكي نجحوا، بيغطوا تكرار الحفظ والتعديل والحذف، التعارض، تغيير المنتج، وتزامن عمليتين لنفس الزبون أو لزبونين بيستخدموا مخزون واحد.
- اتولدت معاينات 8 شاشات بالعربي والإنجليزي على 390×844 بالخط الحقيقي، واتراجعت بصريًا.
- ملفات g.dart وfreezed.dart اتولدت بـ build_runner، ومفيش تعديل يدوي عليها.
- بناء Android debug APK نجح: build/app/outputs/flutter-apk/app-debug.apk.
- مراجعة التحميل على مقاس عريض كشفت overflow في CustomersSkeleton واتصلح بتحويل الارتفاع الثابت لحد أدنى، زي الكارت الفعلي.

## نشر Firestore

- بعد موافقة المستخدم والمراجعة، اتنفّذ dry-run من غير أخطاء أو تحذيرات، وبعده نشر firestore:rules على ma7aly-app-20261102 بنجاح.
- Firebase CLI أكد: released rules firestore.rules to cloud.firestore، وبعدها Deploy complete.
- SHA256 للملف المنشور: D3A7DC0BE02EF7F94F438573ED00DCCCC3ACE71643FCDBC252C5AAA911631FC4.
- Firebase Hosting وStorage rules والـ indexes مش داخلين في النشر ده.

## مراجعة الصفحات والربط

| الصفحة / الاختيار | اللي اتراجع |
|---|---|
| الترحيب والدخول والتسجيل | عرض اللغتين، التحقق من المدخلات، والانتقال للزباين |
| الزباين وإضافة زبون | القائمة، البحث، الحفظ، والرجوع لقائمة محدثة |
| حساب الزبون | فتح الحساب وعرض الرصيد والحركات |
| إضافة وتعديل المسحوبات | اختيار منتج، الإجمالي، الحفظ، التعديل، والحذف مع التأكيد |
| تسجيل دفعة | تأكيد الزيادة، الإيصال والرجوع للحساب |
| المنتجات واختيار منتج | البحث والفلاتر، الحالة الفارغة، الخطأ وإعادة المحاولة |
| إضافة منتج | حفظ الاسم والوحدة والسعر والمخزون |
| إعدادات المحل | فتح بيانات المحل وحفظها وفتح المخزون |
| متابعة الزباين | حفظ النسبة وأيام التنبيه وتطبيق قواعد الدورة |
| التصدير والأمان | نسخ الكشف وطلب رابط كلمة المرور؛ إرسال البريد اتختبر ببديل محلي، مش بإرسال رسالة فعلية |
| المساعدة واللغة والخروج | فتح المساعدة، التبديل في الاتجاهين، ومسح تنقل الحساب عند الخروج |
| الرئيسية | Placeholder فاضي بطلب المستخدم |

## القرارات والحدود

- الفلوس بالقروش والكميات بأجزاء من ألف، مع تقريب حاصل الكمية × السعر لأقرب قرش، والنصف لأعلى.
- الوحدة الإضافية وصف، والكميات اللي بتخصم من المخزون بالوحدة الأساسية.
- الحذف بيحط علامة حذف ويحفظ سجل الحركة؛ التأثير المالي والمخزني بيتعكس في نفس العملية.
- التعديل بيراجع revision، والمحاولة المتكررة ما بتكررّش أثر الحفظ الناجح.
- ميعاد السداد بيتجدد في الدورة الحالية، والدين القديم المتأخر بيفضل متأخر. الدفعات تسدّد القديم الأول والباقي يتحسب ضمن نسبة سداد المسحوبات الجديدة.
- اتصلحت معالجة أخطاء validation في Web transactions وإعادة المحاولة المحدودة لما قراءة من السيرفر تثبت تعارض كتابة على نفس الحساب.
- عرض الحركات على صفحات محلية، لكن المجاميع بتتحسب من السجل الكامل حاليًا. السجلات الكبيرة محتاجة aggregates وتحميل تاريخ على صفحات من السيرفر.
- قواعد الحماية Prototype: بتعزل بيانات كل حساب، بتراجع الأنواع والأحجام، وبتربط تغييرات الرصيد والمخزون بالحركة. محتاجة مراجعة إضافية قبل النشر الواسع.

## المعلق

- نشر القواعد مكتمل. مفيش موافقة نشر معلقة.
- قواعد الدورة الحالية وتسديد الدين القديم أولًا اتأكدت من المستخدم واتنفذت. مفيش سؤال business معلّق.
- iOS محتاج بناء واختبار على Mac؛ اختبارات الربط هنا كانت محلية على Web، مش تشغيل فعلي للنسخة الجديدة على موبايل.

## الملفات الجديدة في الجزء المستكمل

- [lib/core/enums/async_status.dart](E:/work/private/ma7aly_app/lib/core/enums/async_status.dart)
- [lib/core/converters/safe_integer_converter.dart](E:/work/private/ma7aly_app/lib/core/converters/safe_integer_converter.dart)
- [lib/core/helpers/record_id.dart](E:/work/private/ma7aly_app/lib/core/helpers/record_id.dart)
- [lib/core/helpers/amount_format.dart](E:/work/private/ma7aly_app/lib/core/helpers/amount_format.dart)
- [lib/core/widgets/section_app_bar.dart](E:/work/private/ma7aly_app/lib/core/widgets/section_app_bar.dart)
- [lib/core/widgets/form_hint.dart](E:/work/private/ma7aly_app/lib/core/widgets/form_hint.dart)
- [lib/core/widgets/money_panel.dart](E:/work/private/ma7aly_app/lib/core/widgets/money_panel.dart)
- [lib/core/widgets/app_feedback.dart](E:/work/private/ma7aly_app/lib/core/widgets/app_feedback.dart)
- [lib/core/widgets/record_skeleton.dart](E:/work/private/ma7aly_app/lib/core/widgets/record_skeleton.dart)
- [lib/core/widgets/confirm_action.dart](E:/work/private/ma7aly_app/lib/core/widgets/confirm_action.dart)
- [lib/features/customers/domain/entities/customer_movement_entity.dart](E:/work/private/ma7aly_app/lib/features/customers/domain/entities/customer_movement_entity.dart)
- [lib/features/customers/domain/entities/customer_account_entity.dart](E:/work/private/ma7aly_app/lib/features/customers/domain/entities/customer_account_entity.dart)
- [lib/features/customers/domain/entities/movement_amounts.dart](E:/work/private/ma7aly_app/lib/features/customers/domain/entities/movement_amounts.dart)
- [lib/features/customers/domain/usecases/get_customer_account_usecase.dart](E:/work/private/ma7aly_app/lib/features/customers/domain/usecases/get_customer_account_usecase.dart)
- [lib/features/customers/domain/usecases/save_customer_movement_usecase.dart](E:/work/private/ma7aly_app/lib/features/customers/domain/usecases/save_customer_movement_usecase.dart)
- [lib/features/customers/data/models/customer_movement_model.dart](E:/work/private/ma7aly_app/lib/features/customers/data/models/customer_movement_model.dart)
- [lib/features/customers/data/models/customer_movement_model.g.dart](E:/work/private/ma7aly_app/lib/features/customers/data/models/customer_movement_model.g.dart)
- [lib/features/customers/presentation/cubit/customer_account_cubit.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/cubit/customer_account_cubit.dart)
- [lib/features/customers/presentation/cubit/customer_account_state.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/cubit/customer_account_state.dart)
- [lib/features/customers/presentation/cubit/customer_account_state.freezed.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/cubit/customer_account_state.freezed.dart)
- [lib/features/customers/presentation/cubit/save_customer_movement_cubit.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/cubit/save_customer_movement_cubit.dart)
- [lib/features/customers/presentation/cubit/save_customer_movement_state.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/cubit/save_customer_movement_state.dart)
- [lib/features/customers/presentation/cubit/save_customer_movement_state.freezed.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/cubit/save_customer_movement_state.freezed.dart)
- [lib/features/customers/presentation/screens/customer_account_screen.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/screens/customer_account_screen.dart)
- [lib/features/customers/presentation/screens/customer_movement_screen.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/screens/customer_movement_screen.dart)
- [lib/features/customers/presentation/screens/customer_movement_args.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/screens/customer_movement_args.dart)
- [lib/features/customers/presentation/widgets/customer_account_summary.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/customer_account_summary.dart)
- [lib/features/customers/presentation/widgets/customer_movement_card.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/customer_movement_card.dart)
- [lib/features/customers/presentation/widgets/customer_movement_form.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/customer_movement_form.dart)
- [lib/features/customers/presentation/widgets/movement_product_field.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/movement_product_field.dart)
- [lib/features/customers/presentation/widgets/payment_amount_field.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/payment_amount_field.dart)
- [lib/features/customers/presentation/widgets/payment_balance_preview.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/payment_balance_preview.dart)
- [lib/features/customers/presentation/widgets/payment_receipt_dialog.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/payment_receipt_dialog.dart)
- [lib/features/customers/presentation/widgets/customer_first_due_date_field.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/customer_first_due_date_field.dart)
- [lib/features/customers/presentation/widgets/customer_schedule_hint.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/customer_schedule_hint.dart)
- [lib/features/products/data/datasources/products_remote_data_source.dart](E:/work/private/ma7aly_app/lib/features/products/data/datasources/products_remote_data_source.dart)
- [lib/features/products/data/models/product_model.dart](E:/work/private/ma7aly_app/lib/features/products/data/models/product_model.dart)
- [lib/features/products/data/models/product_model.g.dart](E:/work/private/ma7aly_app/lib/features/products/data/models/product_model.g.dart)
- [lib/features/products/data/repositories/products_repository_impl.dart](E:/work/private/ma7aly_app/lib/features/products/data/repositories/products_repository_impl.dart)
- [lib/features/products/domain/entities/product_entity.dart](E:/work/private/ma7aly_app/lib/features/products/domain/entities/product_entity.dart)
- [lib/features/products/domain/repositories/products_repository.dart](E:/work/private/ma7aly_app/lib/features/products/domain/repositories/products_repository.dart)
- [lib/features/products/domain/usecases/add_product_usecase.dart](E:/work/private/ma7aly_app/lib/features/products/domain/usecases/add_product_usecase.dart)
- [lib/features/products/domain/usecases/get_products_usecase.dart](E:/work/private/ma7aly_app/lib/features/products/domain/usecases/get_products_usecase.dart)
- [lib/features/products/presentation/cubit/add_product_cubit.dart](E:/work/private/ma7aly_app/lib/features/products/presentation/cubit/add_product_cubit.dart)
- [lib/features/products/presentation/cubit/add_product_state.dart](E:/work/private/ma7aly_app/lib/features/products/presentation/cubit/add_product_state.dart)
- [lib/features/products/presentation/cubit/add_product_state.freezed.dart](E:/work/private/ma7aly_app/lib/features/products/presentation/cubit/add_product_state.freezed.dart)
- [lib/features/products/presentation/cubit/products_cubit.dart](E:/work/private/ma7aly_app/lib/features/products/presentation/cubit/products_cubit.dart)
- [lib/features/products/presentation/cubit/products_state.dart](E:/work/private/ma7aly_app/lib/features/products/presentation/cubit/products_state.dart)
- [lib/features/products/presentation/cubit/products_state.freezed.dart](E:/work/private/ma7aly_app/lib/features/products/presentation/cubit/products_state.freezed.dart)
- [lib/features/products/presentation/screens/add_product_screen.dart](E:/work/private/ma7aly_app/lib/features/products/presentation/screens/add_product_screen.dart)
- [lib/features/products/presentation/screens/products_screen.dart](E:/work/private/ma7aly_app/lib/features/products/presentation/screens/products_screen.dart)
- [lib/features/products/presentation/widgets/add_product_form.dart](E:/work/private/ma7aly_app/lib/features/products/presentation/widgets/add_product_form.dart)
- [lib/features/products/presentation/widgets/product_card.dart](E:/work/private/ma7aly_app/lib/features/products/presentation/widgets/product_card.dart)
- [lib/features/products/presentation/widgets/product_filters.dart](E:/work/private/ma7aly_app/lib/features/products/presentation/widgets/product_filters.dart)
- [lib/features/settings/data/datasources/settings_remote_data_source.dart](E:/work/private/ma7aly_app/lib/features/settings/data/datasources/settings_remote_data_source.dart)
- [lib/features/settings/data/models/shop_settings_model.dart](E:/work/private/ma7aly_app/lib/features/settings/data/models/shop_settings_model.dart)
- [lib/features/settings/data/models/shop_settings_model.g.dart](E:/work/private/ma7aly_app/lib/features/settings/data/models/shop_settings_model.g.dart)
- [lib/features/settings/data/repositories/settings_repository_impl.dart](E:/work/private/ma7aly_app/lib/features/settings/data/repositories/settings_repository_impl.dart)
- [lib/features/settings/domain/entities/shop_settings_entity.dart](E:/work/private/ma7aly_app/lib/features/settings/domain/entities/shop_settings_entity.dart)
- [lib/features/settings/domain/repositories/settings_repository.dart](E:/work/private/ma7aly_app/lib/features/settings/domain/repositories/settings_repository.dart)
- [lib/features/settings/domain/usecases/export_accounts_usecase.dart](E:/work/private/ma7aly_app/lib/features/settings/domain/usecases/export_accounts_usecase.dart)
- [lib/features/settings/domain/usecases/load_settings_usecase.dart](E:/work/private/ma7aly_app/lib/features/settings/domain/usecases/load_settings_usecase.dart)
- [lib/features/settings/domain/usecases/save_settings_usecase.dart](E:/work/private/ma7aly_app/lib/features/settings/domain/usecases/save_settings_usecase.dart)
- [lib/features/settings/domain/usecases/sign_out_usecase.dart](E:/work/private/ma7aly_app/lib/features/settings/domain/usecases/sign_out_usecase.dart)
- [lib/features/settings/presentation/cubit/settings_cubit.dart](E:/work/private/ma7aly_app/lib/features/settings/presentation/cubit/settings_cubit.dart)
- [lib/features/settings/presentation/cubit/settings_state.dart](E:/work/private/ma7aly_app/lib/features/settings/presentation/cubit/settings_state.dart)
- [lib/features/settings/presentation/cubit/settings_state.freezed.dart](E:/work/private/ma7aly_app/lib/features/settings/presentation/cubit/settings_state.freezed.dart)
- [lib/features/settings/presentation/screens/edit_settings_screen.dart](E:/work/private/ma7aly_app/lib/features/settings/presentation/screens/edit_settings_screen.dart)
- [lib/features/settings/presentation/screens/settings_screen.dart](E:/work/private/ma7aly_app/lib/features/settings/presentation/screens/settings_screen.dart)
- [lib/features/settings/presentation/widgets/settings_menu_item.dart](E:/work/private/ma7aly_app/lib/features/settings/presentation/widgets/settings_menu_item.dart)
- [lib/features/settings/presentation/widgets/shop_settings_form.dart](E:/work/private/ma7aly_app/lib/features/settings/presentation/widgets/shop_settings_form.dart)
- [test/ledger_test.dart](E:/work/private/ma7aly_app/test/ledger_test.dart)
- [test/repayment_cycle_test.dart](E:/work/private/ma7aly_app/test/repayment_cycle_test.dart)
- [test/shop_screens_test.dart](E:/work/private/ma7aly_app/test/shop_screens_test.dart)
- [test/support/fake_products_repository.dart](E:/work/private/ma7aly_app/test/support/fake_products_repository.dart)
- [test/support/fake_settings_repository.dart](E:/work/private/ma7aly_app/test/support/fake_settings_repository.dart)
- [test/support/test_app.dart](E:/work/private/ma7aly_app/test/support/test_app.dart)
- [test/support/file_test_asset_loader.dart](E:/work/private/ma7aly_app/test/support/file_test_asset_loader.dart)
- [docs/customer_inventory_implementation.md](E:/work/private/ma7aly_app/docs/customer_inventory_implementation.md)

## الملفات الموجودة اللي اتعدلت

- [README.md](E:/work/private/ma7aly_app/README.md)
- [firestore.rules](E:/work/private/ma7aly_app/firestore.rules)
- [lib/app_injector.dart](E:/work/private/ma7aly_app/lib/app_injector.dart)
- [lib/app_shell.dart](E:/work/private/ma7aly_app/lib/app_shell.dart)
- [lib/config/routes/app_routes.dart](E:/work/private/ma7aly_app/lib/config/routes/app_routes.dart)
- [lib/config/routes/route_generator.dart](E:/work/private/ma7aly_app/lib/config/routes/route_generator.dart)
- [lib/core/utils/app_strings.dart](E:/work/private/ma7aly_app/lib/core/utils/app_strings.dart)
- [lib/core/helpers/customer_input.dart](E:/work/private/ma7aly_app/lib/core/helpers/customer_input.dart)
- [lib/core/widgets/app_text_field.dart](E:/work/private/ma7aly_app/lib/core/widgets/app_text_field.dart)
- [lib/core/widgets/app_bottom_navigation.dart](E:/work/private/ma7aly_app/lib/core/widgets/app_bottom_navigation.dart)
- [assets/languages/ar.json](E:/work/private/ma7aly_app/assets/languages/ar.json)
- [assets/languages/en.json](E:/work/private/ma7aly_app/assets/languages/en.json)
- [lib/features/customers/domain/entities/customer_entity.dart](E:/work/private/ma7aly_app/lib/features/customers/domain/entities/customer_entity.dart)
- [lib/features/customers/domain/repositories/customers_repository.dart](E:/work/private/ma7aly_app/lib/features/customers/domain/repositories/customers_repository.dart)
- [lib/features/customers/data/datasources/customers_remote_data_source.dart](E:/work/private/ma7aly_app/lib/features/customers/data/datasources/customers_remote_data_source.dart)
- [lib/features/customers/data/repositories/customers_repository_impl.dart](E:/work/private/ma7aly_app/lib/features/customers/data/repositories/customers_repository_impl.dart)
- [lib/features/customers/presentation/screens/add_customer_screen.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/screens/add_customer_screen.dart)
- [lib/features/customers/presentation/screens/customers_screen.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/screens/customers_screen.dart)
- [lib/features/customers/presentation/widgets/add_customer_form.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/add_customer_form.dart)
- [lib/features/customers/presentation/widgets/customer_card.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/customer_card.dart)
- [lib/features/customers/presentation/widgets/customer_schedule_fields.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/customer_schedule_fields.dart)
- [lib/features/customers/presentation/widgets/customers_skeleton.dart](E:/work/private/ma7aly_app/lib/features/customers/presentation/widgets/customers_skeleton.dart)
- [test/customers_screen_test.dart](E:/work/private/ma7aly_app/test/customers_screen_test.dart)
- [test/support/fake_customers_repository.dart](E:/work/private/ma7aly_app/test/support/fake_customers_repository.dart)

## مساعدات التحقق والمعاينة المحلية

الملفات دي تحت .dart_tool ومش كود التطبيق:

- [.dart_tool/complete_localizations.py](E:/work/private/ma7aly_app/.dart_tool/complete_localizations.py)
- [.dart_tool/new_firestore_rules.txt](E:/work/private/ma7aly_app/.dart_tool/new_firestore_rules.txt)
- [.dart_tool/firebase-local.json](E:/work/private/ma7aly_app/.dart_tool/firebase-local.json)
- [.dart_tool/firestore.rules](E:/work/private/ma7aly_app/.dart_tool/firestore.rules)
- [.dart_tool/firestore_rules_test.mjs](E:/work/private/ma7aly_app/.dart_tool/firestore_rules_test.mjs)
- [.dart_tool/ledger_sdk_smoke.dart](E:/work/private/ma7aly_app/.dart_tool/ledger_sdk_smoke.dart)
- [.dart_tool/run_sdk_smoke.mjs](E:/work/private/ma7aly_app/.dart_tool/run_sdk_smoke.mjs)
- [.dart_tool/shop_visual_test.dart](E:/work/private/ma7aly_app/.dart_tool/shop_visual_test.dart)
- [.dart_tool/customers_visual_test.dart](E:/work/private/ma7aly_app/.dart_tool/customers_visual_test.dart)
- [.dart_tool/write_implementation_report.py](E:/work/private/ma7aly_app/.dart_tool/write_implementation_report.py)

معاينات PNG: لكل اسم من اللي جاي ملف -ar وملف -en داخل .dart_tool:

- [.dart_tool/new-customer-ar.png](E:/work/private/ma7aly_app/.dart_tool/new-customer-ar.png)
- [.dart_tool/new-customer-en.png](E:/work/private/ma7aly_app/.dart_tool/new-customer-en.png)
- [.dart_tool/customer-account-ar.png](E:/work/private/ma7aly_app/.dart_tool/customer-account-ar.png)
- [.dart_tool/customer-account-en.png](E:/work/private/ma7aly_app/.dart_tool/customer-account-en.png)
- [.dart_tool/add-withdrawal-ar.png](E:/work/private/ma7aly_app/.dart_tool/add-withdrawal-ar.png)
- [.dart_tool/add-withdrawal-en.png](E:/work/private/ma7aly_app/.dart_tool/add-withdrawal-en.png)
- [.dart_tool/edit-withdrawal-ar.png](E:/work/private/ma7aly_app/.dart_tool/edit-withdrawal-ar.png)
- [.dart_tool/edit-withdrawal-en.png](E:/work/private/ma7aly_app/.dart_tool/edit-withdrawal-en.png)
- [.dart_tool/record-payment-ar.png](E:/work/private/ma7aly_app/.dart_tool/record-payment-ar.png)
- [.dart_tool/record-payment-en.png](E:/work/private/ma7aly_app/.dart_tool/record-payment-en.png)
- [.dart_tool/products-ar.png](E:/work/private/ma7aly_app/.dart_tool/products-ar.png)
- [.dart_tool/products-en.png](E:/work/private/ma7aly_app/.dart_tool/products-en.png)
- [.dart_tool/add-product-ar.png](E:/work/private/ma7aly_app/.dart_tool/add-product-ar.png)
- [.dart_tool/add-product-en.png](E:/work/private/ma7aly_app/.dart_tool/add-product-en.png)
- [.dart_tool/shop-settings-ar.png](E:/work/private/ma7aly_app/.dart_tool/shop-settings-ar.png)
- [.dart_tool/shop-settings-en.png](E:/work/private/ma7aly_app/.dart_tool/shop-settings-en.png)
