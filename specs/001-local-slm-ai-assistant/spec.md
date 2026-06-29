# Feature Specification: Local SLM for AI Assistant (Offline-First)

**Feature Branch**: `001-local-slm-ai-assistant`

**Created**: 2026-06-29

**Status**: Draft — Discovery & Research (POC scoping)

**Input**: User description: "Offline-first local SLM inside the Flutter AI Assistant chat. On-device small language model that understands Arabic + English, later reads local schema/metadata, and produces Intent JSON for executive data questions. POC first. No implementation yet."

> ملاحظة منهجية: هذا المستند مرحلة **Discovery / Specify** فقط. لا يتضمن أي كود ولم تُعدَّل أي ملفات إنتاجية. الأرقام التقنية (أحجام الموديلات، السرعات) مبنية على بحث ويب محدث مذكور في قسم References، وما لا يمكن التأكد منه إلا بالقياس الفعلي تم وضعه في قسم Assumptions.

---

## 1. ملخص تنفيذي (Background)

تطبيق Flutter الحالي يحتوي بالفعل على شاشة **AI Assistant** (دردشة) داخل نظام `project_management`. النسخة الحالية **Online**: ترسل سؤال المستخدم إلى Backend (مستودع `rag_first`، نقطة `projects/query`) الذي يولّد SQL ويعيد صفوفًا منظمة. (المرجع: `ai_assistant_repo_impl.dart`, `ai_assistant_body.dart`.)

الاتجاه الجديد قصير المدى — كما اتُّفق مع Product Owner و AI Consultant — هو تجربة نهج **Offline-First** عبر **SLM محلي** يعمل على الجهاز. **في المرحلة الأولى** يفهم سؤال المستخدم محليًا ويُنتج **ردًا نصيًا حرًا (free-text)** (مع حقن Metadata/Schema محلية مبسّطة كسياق). أما **توليد Intent JSON الصارم** و**جلب البيانات الفعلية من قاعدة البيانات** فمؤجَّلان لمراحل/specs لاحقة (انظر Clarifications).

هذا المستند يحدد **POC** يثبت الجدوى التقنية ويقيس الأداء قبل أي التزام كامل.

---

## Clarifications

### Session 2026-06-29

- Q: ما المخرج الأساسي الذي يجب أن يثبته الـ POC من الـ SLM المحلي؟ → A: **المرحلة الأولى: رد نصي حر (free-text) فقط** — نربط الشاشة بالـ SLM المحلي ونثبّت الرد النصي أولًا. **Intent JSON مؤجَّل** إلى spec/مرحلة لاحقة.
- Q: كيف يُسلَّم الموديل للجهاز؟ → A: ~~تنزيل بعد أول تشغيل~~ **(مُحدَّث/Superseded):** **تنزيل بمبادرة المستخدم من واجهة اختيار موديل (Model Selection UI)** — **لا تنزيل تلقائي** عند بدء التطبيق أو فتح شاشة المساعد. التطبيق يحزم **manifest صغير فقط** (لا ملفات موديل). تُحفَظ **حالة الموديل** (installed/active) ولا يُحفَظ **سجل المحادثة**.
- Q: هل نقيس الـ SLM المحلي مقابل خط أساس SLM على الخادم (API key) بنفس عقد Intent JSON؟ → A: **لا في هذه المرحلة — قياس محلي فقط**؛ لا حاجة لربط API key الآن. يُجعَل **اختياريًا** عند إطلاق التطبيق في **spec متقدم لاحق**.
- Q: ما الحد الأدنى لشريحة جهاز Android المستهدفة؟ → A: **متوسط المدى، 6GB RAM** (يُفترَض Android 12+).

> أثر هذه التوضيحات: الـ POC للمرحلة الأولى = **محادثة نصية محلية (free-text)**. كل ما يخص **Intent JSON** و**التحقق من الـ schema** و**خط الأساس Online** يُنقَل إلى **Non-Goals/مرحلة لاحقة** ويبقى مذكورًا كاتجاه مستقبلي لضمان توافق المعمارية.

---

## 2. المشكلة (Problem Statement)

- النسخة الحالية تعتمد كليًا على الاتصال بالإنترنت وعلى نموذج Online؛ نريد اختبار قدرة **فهم السؤال محليًا** دون استدعاء نموذج عبر الشبكة.
- المستخدمون تنفيذيون (C-level) بأجهزة متفاوتة المواصفات؛ نحتاج معرفة هل يمكن لنموذج محلي صغير أن يدعم **العربية والإنجليزية والمزيج بينهما** بجودة مقبولة ضمن حدود حجم/ذاكرة/زمن مقبولة على الموبايل.
- لا نعرف بعد التكلفة الحقيقية (حجم التطبيق، RAM، زمن الاستجابة، البطارية) ولا الموديل/الـ Runtime الأنسب داخل Flutter.

**الهدف من الـ POC**: الإجابة بأرقام قابلة للقياس على: ما الموديل؟ ما الـ Runtime؟ ما التكلفة على الجهاز؟ هل جودة العربية وإخراج JSON مقبولة؟

---

## 3. الأهداف (Goals)

1. اختيار **2–3 مرشحين SLM** مناسبين للعربية + الموبايل + الحجم الصغير.
2. تشغيل **نموذج محلي واحد** فعليًا داخل شاشة AI Assistant في Flutter (Android أولًا).
3. إرسال الـ prompt من شاشة الدردشة إلى الـ SLM وعرض **الرد النصي الحر (free-text)** في الـ UI — **هذا هو مخرج المرحلة الأولى**.
4. إضافة ملف **Metadata JSON محلي بسيط** ودمجه في الـ prompt (لإثراء السياق، دون اشتراط مخرج JSON في هذه المرحلة).
5. اختبار أسئلة **عربية / إنجليزية / مختلطة** وتقييم جودة الرد النصي. *(توليد Intent JSON مؤجَّل لمرحلة لاحقة — انظر Clarifications.)*
6. قياس: حجم الموديل، زمن الاستجابة، RAM، أثر بدء التشغيل، الحرارة/البطارية، وجودة الرد على عيّنة أسئلة (محلي فقط، **دون** خط أساس Online في هذه المرحلة).
7. الخروج بقرار **Go / No-Go** واضح للمرحلة التالية.

---

## 4. خارج النطاق (Non-Goals)

- ❌ **توليد Intent JSON / التحقق من schema** كهدف لهذه المرحلة (مؤجَّل لـ spec لاحق — المرحلة الأولى free-text فقط).
- ❌ **خط أساس SLM على الخادم (API key)** في هذه المرحلة (قياس محلي فقط؛ يُجعَل اختياريًا في spec متقدم لاحقًا).
- ❌ توليد SQL على الجهاز (مرفوض في الـ MVP صراحةً).
- ❌ الاتصال المباشر من الموبايل بقاعدة البيانات.
- ❌ بناء Backend Query Gateway أو تنفيذ استعلامات حقيقية (مرحلة لاحقة).
- ❌ MCP في هذه المرحلة.
- ❌ Fine-tuning / LoRA (يُذكر كاحتمال مستقبلي فقط).
- ❌ دعم iOS كهدف تسليم للـ POC (يجب فقط **عدم إغلاق الباب** أمامه).
- ❌ تنسيق إجابات تنفيذية نهائية من بيانات حقيقية (لا توجد بيانات حقيقية في الـ POC).
- ❌ Multi-tenant / Permissions enforcement (لا قاعدة بيانات في الـ POC).

---

## 5. User Scenarios & Testing *(mandatory)*

### User Story 1 — محادثة نصية محلية مع SLM (Priority: P1) — **مخرج المرحلة الأولى**

يفتح المستخدم شاشة AI Assistant، يكتب سؤالًا، فيُرسَل إلى **SLM محلي على الجهاز** ويظهر **رد نصي حر (free-text)** داخل فقاعة الدردشة — بدون أي اتصال شبكي.

**Why this priority**: هذه هي الفرضية الجوهرية للاتجاه الجديد (Offline inference) ومخرج المرحلة الأولى المعتمَد. بدون إثباتها لا قيمة لبقية العمل.

**Independent Test**: تفعيل وضع الطيران، كتابة سؤال، والتأكد من ظهور رد نصي مولّد محليًا خلال زمن مقبول.

**Acceptance Scenarios**:
1. **Given** الموديل محمّل والجهاز بدون إنترنت، **When** يرسل المستخدم سؤالًا إنجليزيًا، **Then** يظهر رد نصي مولّد محليًا دون خطأ شبكة.
2. **Given** نفس الحالة، **When** يرسل سؤالًا عربيًا، **Then** يظهر رد عربي مفهوم.
3. **Given** سؤال مختلط عربي/إنجليزي، **When** يستدل الموديل، **Then** يظهر رد مفهوم بلغة مناسبة للسؤال.
4. **Given** الموديل قيد التحميل/الاستدلال، **When** ينتظر المستخدم، **Then** تظهر حالة "Thinking" الحالية ويُمنع إرسال رسالة ثانية متزامنة.

---

### User Story 2 — توليد Intent JSON صارم (Priority: P3) — **مؤجَّلة (Deferred to a future spec)**

> ⛔ **خارج نطاق POC المرحلة الأولى** بناءً على Clarifications (2026-06-29). تُوثَّق هنا فقط لضمان أن معمارية المرحلة الأولى (واجهة `LocalSlmService` + `PromptBuilder` + Metadata) **لا تغلق الباب** أمامها لاحقًا.

عند تفعيلها مستقبلًا: تزويد الـ SLM بـ Metadata + سؤال المستخدم لإنتاج **Intent JSON** مطابق لعقد محدّد (intent + params + lang) بدل/إضافةً للنص الحر، مع التحقق من الـ schema و`intent:none` للأسئلة خارج النطاق. (التفاصيل في قسمي AI Output Contract وSuccess Metrics كبنود **مؤجَّلة**.)

---

### User Story 3 — اختبار اللغة والأداء وقياس الجدوى (Priority: P2)

يشغّل الفريق مجموعة اختبار (عربي/إنجليزي/مختلط) على 2–3 موديلات ويجمع مقاييس الأداء لاتخاذ قرار.

**Why this priority**: الـ POC هدفه قرار مبني على بيانات؛ القياس جزء أصيل من التسليم.

**Independent Test**: تشغيل Golden Set على كل موديل مرشّح وتعبئة جدول المقاييس (Section: Success Metrics).

**Acceptance Scenarios**:
1. **Given** Golden Set (~30–50 سؤالًا)، **When** يُشغَّل على المرشّح، **Then** تُسجَّل latency/RAM وتقييم **جودة الرد النصي** (relevance/قابلية الفهم) بمقياس بشري بسيط (1–5).
2. **Given** جهاز mid-range (6GB RAM)، **When** يعمل الموديل، **Then** تُرصد الحرارة والبطارية خلال ~20 استعلامًا متتاليًا.

---

### User Story 4 — إدارة تحميل/تجهيز الموديل وحالة الأجهزة الضعيفة (Priority: P3)

عند أول تشغيل، يتأكد التطبيق من توفر الموديل (مضمّن أو يُنزَّل)، ويتعامل بلطف مع جهاز لا يستطيع تشغيله.

**Why this priority**: ضروري للتجربة الواقعية لكنه ليس جوهر إثبات الجدوى؛ يكفي حد أدنى في الـ POC.

**Independent Test**: محاكاة جهاز ضعيف/مساحة غير كافية والتأكد من رسالة fallback واضحة بدل انهيار.

**Acceptance Scenarios**:
1. **Given** الموديل غير موجود، **When** يفتح المستخدم الشاشة، **Then** تبدأ عملية تجهيز/تنزيل مع مؤشر تقدم.
2. **Given** جهاز دون الحد الأدنى، **When** يحاول التحميل، **Then** تظهر رسالة "جهازك لا يدعم الوضع المحلي حاليًا" دون كراش.

---

### Edge Cases

- إدخال فارغ أو رموز فقط → لا استدعاء للموديل (السلوك الحالي يمنع الإرسال الفارغ).
- سؤال طويل جدًا يتجاوز context window → يجب اقتطاع/رفض لطيف بدل تعطّل.
- *(مؤجَّل — عند تفعيل Intent JSON)* مخرج الموديل ليس JSON صالحًا → إعادة محاولة واحدة بقالب أصرم، ثم fallback إلى `intent:none`. *(في المرحلة الأولى free-text لا ينطبق.)*
- نفاد الذاكرة أثناء التحميل → التقاط الخطأ وإظهار fallback.
- تبديل اللغة منتصف المحادثة → كل رسالة تُعامَل بلغتها.
- تدوير الشاشة / خروج التطبيق أثناء الاستدلال → عدم تسريب isolate أو تعليق UI.

---

## 6. Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: يجب أن يشغّل التطبيق نموذج SLM **محليًا على الجهاز** ويولّد ردًا دون اتصال بالشبكة بعد اكتمال التجهيز.
- **FR-002**: يجب أن تُرسل شاشة الدردشة نص المستخدم إلى **خدمة SLM محلية** (طبقة جديدة) وتعرض **الرد النصي الحر** في فقاعة المحادثة بنفس نمط الـ UI الحالي (مخرج المرحلة الأولى).
- **FR-003**: يجب أن يعمل الاستدلال على **isolate/خيط منفصل** بحيث لا يتجمد الـ UI، مع إبقاء حالة "Thinking" الحالية ومنع الإرسال المتزامن (`_isSending`).
- **FR-004**: يجب أن يدعم النظام إدخال **عربي وإنجليزي ومختلط** وأن يردّ بشكل مفهوم بلغة السؤال.
- **FR-005**: يجب أن يحمِّل النظام **ملف Metadata JSON محلي** ويحقنه ضمن الـ prompt مع سؤال المستخدم (لإثراء السياق، دون اشتراط مخرج JSON في المرحلة الأولى).
- **FR-006** *(مؤجَّل — Future Spec)*: دعم وضع **Intent JSON**: إخراج JSON مطابق لعقد محدّد (intent ضمن قائمة مغلقة + params + lang). خارج نطاق المرحلة الأولى.
- **FR-007** *(مؤجَّل — Future Spec)*: التحقق من صحة JSON ومطابقته للـ schema؛ وعند الفشل إعادة محاولة واحدة ثم `intent:none`. خارج نطاق المرحلة الأولى.
- **FR-008** *(مؤجَّل — Future Spec)*: توفير intent احتياطي **`none`** يُترجَم إلى رسالة "لا تتوفر بيانات كافية". خارج نطاق المرحلة الأولى. *(ملاحظة المرحلة الأولى: يجب أن يردّ الموديل نصيًا بأدب عند عدم المعرفة بدل اختلاق حقائق.)*
- **FR-009** *(مُحدَّث)*: يجب أن يُسلَّم الموديل عبر **تنزيل بمبادرة المستخدم من واجهة اختيار موديل (Model Selection UI)** — **لا تنزيل تلقائي** عند بدء التطبيق أو فتح الشاشة. يبدأ التنزيل فقط بعد اختيار المستخدم لموديل غير مُثبَّت، مع مؤشر تقدم حقيقي، استئناف/إلغاء/إعادة محاولة، تحقق checksum وversion — **لا تضمين ملفات الموديل داخل التطبيق** (manifest فقط).
- **FR-009a** *(جديد)*: يجب أن تَعرض واجهة اختيار الموديل **2–3 موديلات موصى بها** (اسم، الحجم التقديري، وصف، حالة installed/active، CTA: "Download" أو "Use")، وأن تُظهر علامة **Installed** للموديلات المُثبَّتة.
- **FR-009b** *(جديد)*: يجب **حفظ حالة الموديل** فقط (installed ids, version, checksum, local path, installed status, active/last-selected id)؛ والسماح بالتبديل بين الموديلات المُثبَّتة **دون إعادة تنزيل**؛ وعند فشل checksum/version لا يُعتبر مُثبَّتًا ويُعرض خيار repair/redownload. **لا يُحفَظ سجل المحادثة** (في الذاكرة فقط).
- **FR-010**: يجب أن يكتشف النظام **عدم قدرة الجهاز** على التشغيل ويعرض fallback واضح بدل انهيار.
- **FR-011**: يجب أن يدعم Metadata **labels عربية وإنجليزية** وأن تكون **مبسّطة وآمنة** (لا أسماء جداول/أعمدة إنتاجية حساسة).
- **FR-012**: يجب أن يوفّر النظام **أداة قياس** (logging داخلي للـ POC) تُسجّل latency و(تقدير) استهلاك الذاكرة لكل استعلام.
- **FR-013**: يجب أن تبقى وظائف الدردشة الحالية (New Chat / Reset Context / التمرير) سليمة دون كسر للـ UI الحالي.
- **FR-014**: يجب أن يكون اختيار "المزوّد" خلف **واجهة موحّدة** (Strategy). في المرحلة الأولى المزوّد الفعّال هو **SLM المحلي فقط**؛ تُترَك الواجهة مفتوحة لإضافة مزوّد **Online (API key) اختياري** في spec متقدم لاحقًا دون كسر المعمارية.

### Key Entities

- **LocalSlmService**: واجهة تجريد للاستدلال المحلي **نصّي فقط** (load / generate / generateText / cancel / dispose / isReady).
- **ModelCatalog / ModelCatalogEntry**: قائمة موديلات (manifest) — لكل موديل: id، الاسم، الإصدار، url، format، الحجم، checksum، minRam، الدور، label/وصف. (التطبيق يحزم الـ manifest فقط، لا ملفات الموديل.)
- **ActiveModelStore**: حفظ **حالة الموديل فقط** (installed ids، version، checksum، local path، installed status، active/last-selected id). لا يحفظ سجل المحادثة.
- **ModelInstallationState**: حالة كل موديل (notInstalled / downloading / installed / corrupt / unsupported).
- **MetadataBundle**: ملف JSON محلي mobile-safe (الإصدار، المفاهيم المبسّطة، labels AR/EN، enums) — سياق اختياري فقط.
- **ChatEntry** (موجود): عنصر المحادثة (user/thinking/result) — يُعاد استخدامه لعرض **الرد النصي الحر** (في الذاكرة فقط، بلا حفظ).
- **PocMetric**: سجل قياس لكل استعلام (latency، RAM، model id، device tier، quality rating، hallucination notes، download/offline success).

> **Future Scope entities (NOT in phase 1):** `IntentResult` (`intent`, `params`, `lang`, …) و`generateIntent(...)` على `LocalSlmService` و`IntentParser/Validator` — تُفعَّل في spec لاحق فقط، ولا تُنفَّذ في المرحلة الأولى.

---

## 7. Non-Functional Requirements

- **NFR-001 (Performance)**: زمن أول رد (نموذج محمّل مسبقًا) ≤ ~5s على جهاز mid-range لسؤال قصير في الـ POC (هدف مبدئي يُراجَع بالقياس).
- **NFR-002 (Storage)**: حجم الموديل المختار ≤ ~1.2 GB (4-bit) كي يبقى الوضع المحلي واقعيًا.
- **NFR-003 (Memory)**: استهلاك RAM أثناء الاستدلال ضمن حدود لا تُسبب OOM على **جهاز متوسط المدى بذاكرة 6GB RAM (الحد الأدنى المستهدف، Android 12+)**.
- **NFR-004 (Startup)**: ألا يبطئ تحميل الموديل بدء تشغيل التطبيق العام (تحميل كسول lazy عند فتح الشاشة، لا عند إقلاع التطبيق).
- **NFR-005 (Responsiveness)**: عدم تجميد الـ UI أثناء الاستدلال (isolate).
- **NFR-006 (Compatibility)**: Android أولًا (minSdk واقعي)، مع معمارية لا تمنع iOS لاحقًا.
- **NFR-007 (License)**: استخدام موديلات برخص تسمح بالاستخدام التجاري (Apache-2.0 لـ Qwen، Gemma Terms لـ Gemma — تُراجَع قانونيًا).
- **NFR-008 (Maintainability)**: عزل منطق SLM خلف واجهة واحدة تتيح تبديل الموديل/الـ Runtime دون لمس الـ UI.
- **NFR-009 (Observability)**: تسجيل مقاييس الـ POC محليًا دون تسريب محتوى حساس.

---

## 8. Offline Requirements

- **OFF-001**: بعد اكتمال التجهيز، يجب أن يعمل **فهم السؤال + توليد الرد النصي الحر** بالكامل **دون إنترنت** (المرحلة الأولى).
- **OFF-002**: ملف Metadata المحلي يجب أن يكون متاحًا offline (مضمّن أو مُنزَّل مسبقًا).
- **OFF-003**: يجب التمييز بوضوح بين "الجزء المحلي يعمل offline" و"جلب البيانات من DB" (الأخير يتطلب اتصالًا وهو خارج نطاق الـ POC).
- **OFF-004**: عند غياب الموديل وغياب الإنترنت في آنٍ واحد، رسالة واضحة بدل سلوك غامض.

---

## 9. Local SLM Research (بحث الموديلات)

> المصادر في قسم References. الأرقام تقديرية لإصدارات GGUF/4-bit؛ تُحسم نهائيًا بالقياس على الجهاز.

### خلاصة حاكمة
- النماذج التي تدعم العربية **بجودة عالية حقًا** تقع غالبًا عند **7B+** (≈ 4.5–6 GB مكمَّمة) → **غير عملية** للموبايل/التطبيق.
- النماذج بحجم الموبايل (**1–3B ≈ 1–2 GB**) عربيتها **مقبولة (fair)** — كافية لـ **تصنيف Intent**، وليست مثالية للتوليد الإنشائي الطويل.
- لذلك توجيه الـ POC: استخدام الموديل الصغير لإنتاج **Intent JSON** (تصنيف/استخلاص) لا لكتابة فقرات عربية فصيحة.

### جدول المقارنة

| الموديل | الحجم (params) | حجم تقريبي 4-bit | عربي | إنجليزي | مختلط | ثبات JSON | جدوى موبايل | Android | iOS | Runtime | الرخصة | للـ POC؟ |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **Qwen2.5-1.5B-Instruct** | 1.5B | ~0.99 GB | جيد لحجمه (أفضل صغير متعدد اللغات) | جيد | جيد | جيد (function calling) | عالية | ✅ | ✅ | flutter_gemma / llama.cpp | Apache-2.0 | ✅ **مرشّح أساسي** |
| **Gemma 3 1B** | 1B | ~0.5 GB | مقبول (140+ لغة) | قوي | مقبول | جيد | عالية جدًا | ✅ | ✅ | flutter_gemma (أصلي) | Gemma Terms | ✅ **مرشّح خفيف** |
| **Qwen2.5-0.5B / Qwen3-0.6B** | 0.5–0.6B | ~0.4 GB | ضعيف–مقبول | مقبول | مقبول | متوسط | ممتازة | ✅ | ✅ | flutter_gemma / llama.cpp | Apache-2.0 | ✅ **fallback أجهزة ضعيفة** |
| Qwen2.5-3B | 3B | ~1.9 GB | أفضل قليلًا | جيد | جيد | جيد | متوسطة (ثقيل) | ✅ | ⚠️ | llama.cpp | Apache-2.0 | ⏳ خيار جودة لاحق |
| Phi-4-mini | ~3.8B | ~2.2 GB | متوسط | قوي | متوسط | جيد | منخفضة (ثقيل) | ✅ | ⚠️ | flutter_gemma | MIT | ❌ ثقيل للهدف |
| Llama 3.2 1B/3B | 1–3B | ~0.7–1.8 GB | **عربي ضعيف** | قوي | ضعيف عربي | جيد | عالية | ✅ | ✅ | llama.cpp | Llama license | ❌ فجوة عربية |
| Gemma 3 270M | 270M | ~125 MB | ضعيف للحر، جيد بعد fine-tune للمنظَّم | محدود | محدود | جيد بعد توجيه | فائقة | ✅ | ✅ | flutter_gemma | Gemma Terms | ⏳ تجربة "intent-only" متقدمة |
| نماذج عربية مخصّصة (ALLaM 7B, Fanar 7–9B, SILMA 9B, AceGPT) | 7–9B | ~4.5–6 GB | **ممتاز** | جيد | جيد | جيد | ❌ كبيرة جدًا | — | — | llama.cpp/خادم | متفاوتة | ❌ للموبايل (خيار Online فقط) |

---

## 10. Recommended SLM Candidates (التوصية)

1. **Qwen2.5-1.5B-Instruct (4-bit)** — *المرشّح الأساسي*: أفضل توازن عربي/إنجليزي/JSON مقابل ~1 GB، رخصة Apache-2.0 مريحة، مدعوم في flutter_gemma وllama.cpp، يدعم function calling (مفيد لإخراج منظَّم).
2. **Gemma 3 1B (4-bit)** — *المرشّح الخفيف*: ~0.5 GB فقط، تكامل أصلي ممتاز مع flutter_gemma، جيد للأجهزة المتوسطة؛ عربيته أقل من Qwen لكنه أخف.
3. **Qwen2.5-0.5B / Qwen3-0.6B** — *fallback للأجهزة الضعيفة*: ~0.4 GB، لقياس الحد الأدنى المقبول.

> توصية إضافية صريحة (Product-level): الـ POC المحلي **يُثبت الجدوى**، لكن لإطلاق MVP سريع منخفض المخاطر يُنصح بإبقاء خيار **SLM عبر API key على الخادم** (نفس عقد Intent JSON) كخط أساس للمقارنة — لأن جودة العربية أعلى وحجم التطبيق أصغر. القرار للـ PO (انظر Open Questions).

---

## 11. Runtime / Flutter Integration Options

| Runtime | Android | iOS | تعقيد التكامل مع Flutter | صيغ الموديل | الأداء | التكميم | إخراج منظَّم/JSON | المخاطر | للـ POC |
|---|---|---|---|---|---|---|---|---|---|
| **flutter_gemma** (حزمة pub) | ✅ | ✅ (iOS 16+, memory entitlements) | **منخفض** (واجهة Dart جاهزة) | `.task`/`.litertlm`/مدعوم Gemma,Qwen2.5/3,Phi-4,SmolLM,DeepSeek | جيد (GPU/CPU) | 4-bit مدعوم | **Function calling مدعوم** (مفيد لـ Intent JSON) | حزمة طرف ثالث؛ توافق صيغ؛ نضج متفاوت | ✅ **الخيار الأساسي للـ POC** |
| **fllama / llama_cpp_dart** (llama.cpp) | ✅ | ✅ (Metal: Apple7+) | متوسط (إعداد cmake/ndk، pods) | **GGUF** (أوسع مرونة) | جيد (CPU غالبًا أفضل من GPU على Mali/Adreno) | GGUF 4/5/8-bit | عبر grammar/GBNF (constrained decoding ممكن) | إعداد native أعقد؛ صيانة | ✅ **بديل/خطة B لمرونة GGUF + grammar** |
| **MediaPipe LLM Inference** (Google) | ✅ | ✅ | متوسط (عبر MethodChannel) | `.task` (Gemma وغيرها) | جيد على GPU | مدعوم | محدود | **Experimental** (وصفته Google للأبحاث) | ⏳ مراقبة، ليس أساسًا |
| **MLC LLM** | ✅ | ✅ | مرتفع | أوزان MLC | أداء GPU على موبايل غير Apple ضعيف (5–20% ALU) | مدعوم | محدود | تعقيد بناء/توزيع | ❌ ليس للـ POC |
| **ONNX Runtime Mobile** | ✅ | ✅ | مرتفع لنماذج LLM توليدية | ONNX | متغيّر | INT4/INT8 | يدوي | نضج LLM التوليدي أقل | ❌ ليس للـ POC |
| **TensorFlow Lite / LiteRT** | ✅ | ✅ | متوسط–مرتفع | TFLite/LiteRT | جيد للنماذج الصغيرة | مدعوم | يدوي | LLM توليدي محدود مقارنةً بالبدائل | ⏳ غير أساسي |

**التوصية**: ابدأ الـ POC بـ **flutter_gemma** (أقل احتكاك، Dart-first، يدعم Qwen2.5 + Gemma + function calling، Android/iOS). احتفظ بـ **fllama/llama_cpp_dart** كخطة B عند الحاجة لمرونة GGUF أو **constrained decoding عبر GBNF grammar** لضمان JSON صالح 100%.

---

## 12. Recommended POC Architecture

```
AI Assistant Entry (ai_assistant_view.dart)
        ▼
Model Selection UI / ModelCatalog (model_selection_view.dart) — يعرض 2–3 موديلات (لا تنزيل تلقائي)
        │   المستخدم يختار موديلًا
        ▼
ModelSelectionController (جديد) — يفحص حالة التثبيت
        ├── مُثبَّت  → ActiveModelStore.setActiveModel(id) → فتح المحادثة (بلا تنزيل)
        └── غير مُثبَّت → حالة تنزيل بمبادرة المستخدم:
                          ModelManager.downloadSelectedModel(id) [progress · checksum · version]
                          → تثبيت → ActiveModelStore.setActiveModel(id) → تفعيل المحادثة
        ▼
AiAssistantBody (chat UI الحالي: input, thinking, entries)
        │  نقطة الدمج: _onSend() → AiInferenceController.generate(text)  (للموديل النشط)
        ▼
AiInferenceController / Strategy (جديد)  ── يقرأ الموديل النشط من ActiveModelStore
        └── LocalSlmService (جديد، نصّي فقط) ── FlutterGemmaLocalSlmService (isolate)
                 ├── PromptBuilder (جديد): system + (metadata اختيارية) + user → prompt
                 └── MetadataLoader (جديد): يقرأ assets/ai/metadata.sample.json (mobile-safe)
        ▼
عرض **رد نصي حر فقط** في نفس فقاعات المحادثة (بلا حفظ — في الذاكرة فقط)
        ▼
PocMetrics (جديد): latency / RAM / model id / device tier / quality rating (logging محلي)
```
> ملاحظة: المسار الـ Online الحالي (`AiAssistantRepo`) يبقى كما هو دون تغيير. **llama.cpp/GGUF ليست جزءًا من معمارية المرحلة الأولى** — هي fallback مشروط مؤجَّل فقط (انظر القسم 10/البحث).

### نقاط الدمج في الكود الحالي (من الفحص)
- شاشة الدردشة: `ai_assistant_view.dart` → `AiAssistantBody` (`ai_assistant_body.dart`).
- حقل الإدخال + الإرسال: `TextField` + `_onSend()` (السطور ~178–262) — **نقطة الدمج الرئيسية**.
- عرض الرسائل: `_buildEntry()` و`_ChatEntry` (user/thinking/result) — قابلة لإعادة الاستخدام لرد نصي/JSON.
- الحقن (DI): يوجد `projectManagementSl<AiAssistantRepo>()` عبر `project_management_locator` → نسجّل `LocalSlmService`/`AiInferenceController` بنفس الأسلوب.
- إدارة الحالة: حاليًا `StatefulWidget` + `setState` + `_isSending` + `GlobalKey<AiAssistantBodyState>` — كافٍ للـ POC دون إدخال state management جديد.

### ملفات جديدة متوقعة (لا تُنشأ الآن)
- `lib/features/ai_assistant/local_slm/local_slm_service.dart` (واجهة)
- `.../local_slm/flutter_gemma_slm_service.dart` (تنفيذ)
- `.../local_slm/prompt_builder.dart`
- `.../local_slm/intent_parser.dart` + `intent_contract.dart`
- `.../local_slm/model_manager.dart` (توفّر/تنزيل/checksum/جاهزية)
- `.../local_slm/metadata_loader.dart`
- `assets/ai/metadata.sample.json`, `assets/ai/prompts/*.txt`
- `.../local_slm/poc_metrics.dart`
- اختبارات تحت `test/features/ai_assistant/local_slm/`

---

## 13. Local Metadata/Schema Strategy

**ما يُستخرَج من DB (على الخادم/أداة، لا على الموبايل):** views، أعمدة، أنواع، enums/statuses، علاقات، تعريفات أعمال، قائمة intents. ثم **يُجمَّع يدويًا/آليًا** إلى ملف **mobile-safe** مبسّط.

**ما يُضمَّن محليًا (Mobile-safe):**
- أسماء **views منطقية مبسّطة** (مثل `projects`, `action_items`, `kpis`) — لا أسماء جداول إنتاجية.
- أعمدة قابلة للترشيح فقط + أنواعها + قيم enum/status.
- **labels عربية/إنجليزية** لكل مفهوم/عمود.
- قائمة **intents المسموحة** وبارامتراتها.
- تعريفات أعمال مختصرة (وصف لا قاعدة SQL).

**ما لا يُضمَّن محليًا:**
- ❌ قواعد SQL الفعلية، أسماء/مخطط الجداول الإنتاجية، مفاتيح، DSN/credentials.
- ❌ منطق الصلاحيات/الـ tenant، أي صفوف بيانات حقيقية.
- ❌ أعمدة حساسة (رواتب/بيانات شخصية).

**تجنّب كشف تفاصيل حساسة:** الفصل بين "metadata العرض" (موبايل) و"قواعد التنفيذ" (خادم لاحقًا). الموبايل يعرف *ماذا* يُسأل، والخادم يعرف *كيف* يُنفَّذ.

**كامل أم مبسّط؟** → **مبسّط (mobile-safe) فقط**، لسببين: حجم context window صغير، وأمان كشف النموذج.

**حجم context:** إبقاء الملف صغيرًا (هدف بضعة KB)؛ **تقسيمه حسب module/domain** (project/meetings/strategy) وتحميل الجزء ذي الصلة فقط في الـ prompt.

**Versioning/Update:** حقل `version` + `generated_at`. في الـ POC: مضمّن في assets. لاحقًا: تنزيل نسخة مُوقّعة بعد تسجيل الدخول وفحص الإصدار.

**دعم التحقق المستقبلي بالـ Backend:** أسماء intents والبارامترات في الملف هي نفسها التي سيعرفها الـ Gateway لاحقًا، لتطابق العقد بين الموبايل والخادم.

### عقد Metadata (مثال مبسّط)
```json
{
  "version": 1,
  "generated_at": "2026-06-29",
  "domain": "project_management",
  "views": {
    "projects": {
      "label": {"en": "Projects", "ar": "المشاريع"},
      "columns": [
        {"name": "status", "type": "enum",
         "enum": ["active","delayed","completed","on_hold"],
         "label": {"en":"Status","ar":"الحالة"}, "filterable": true},
        {"name": "end_date", "type": "date", "filterable": true}
      ]
    }
  },
  "business_terms": {
    "delayed_project": {"label": {"en":"Delayed project","ar":"مشروع متأخر"}}
  },
  "intents": [
    {"name": "delayed_projects", "params": ["limit?"]},
    {"name": "project_responsible", "params": ["project_name"]},
    {"name": "none", "params": []}
  ]
}
```

---

## 14. AI Output Contract (عقد المخرج) — *مؤجَّل (Future Spec)*

> ⛔ المرحلة الأولى مخرجها **نص حر** ولا تستخدم هذا العقد. يبقى هنا كمرجع تصميمي للمرحلة اللاحقة عند تفعيل Intent JSON.

```json
{
  "intent": "delayed_projects",
  "params": { "project_name": "Atlas", "status": "delayed", "limit": 10 },
  "lang": "ar",
  "confidence": 0.0
}
```
قواعد: `intent` **يجب** أن يكون ضمن قائمة Metadata المغلقة أو `none`؛ المخرج **JSON فقط** بلا نص إضافي؛ عند عدم اليقين → `none`؛ قيم البيانات لا تُختلق (الموديل يستخرج نية لا بيانات).

---

## 15. Backend Validation Expectations (مستقبلي — خارج الـ POC)

عند ربط البيانات لاحقًا: الـ Backend Gateway (وليس الموبايل) يتولى Auth، فرض tenant/scope من الـ token، تحويل intent→استعلام مُعامَل على views للقراءة فقط، SELECT-only، LIMIT/timeout، masking، وaudit. الموبايل لا يلمس DB ولا يولّد SQL إطلاقًا. (يُذكر هنا فقط لضمان توافق عقد Intent JSON مع المرحلة القادمة.)

---

## 16. Security Considerations

- **SEC-001**: لا credentials/DSN ولا منطق SQL على الجهاز.
- **SEC-002**: Metadata المحلية mobile-safe فقط؛ لا مخطط إنتاجي حساس ولا صفوف حقيقية.
- **SEC-003**: لا اتصال مباشر من الموبايل بـ DB في أي مرحلة.
- **SEC-004**: عند اعتماد تنزيل الموديل/الميتاداتا لاحقًا: نقل عبر TLS + checksum، وحماية نسخة الميتاداتا على الجهاز (تشفير at-rest) وربطها بمستخدم مُصادَق.
- **SEC-005**: عدم تسجيل محتوى حساس في logs الـ POC (يتوافق مع ممارسة إخفاء `sql/dsn/token` في الكود الحالي).
- **SEC-006**: ملف الموديل قد يكون كبيرًا/قابلًا للاستخراج — لا تضع فيه أي أسرار؛ الموديل عام.

---

## 17. Performance Considerations

- زمن **التحميل الأولي** للموديل (مرة واحدة) مقابل زمن **الاستدلال** لكل رسالة — يُقاسان منفصلين.
- **Prefill vs decode**: على Android، CPU غالبًا أفضل من GPU لضعف استغلال Mali/Adreno؛ سرعات decode للنماذج 3–8B/4-bit ~20–50 tok/s على أجهزة رائدة، وأقل على mid-range.
- تحميل **كسول** عند فتح الشاشة لا عند إقلاع التطبيق (NFR-004).
- إبقاء الموديل محمّلًا أثناء الجلسة وتحريره عند الخروج (إدارة ذاكرة).
- اختبار سؤال قصير وآخر متوسط؛ تقييد طول المخرج (max tokens) لتقليل الزمن.

---

## 18. Device Compatibility

- **Android أولًا**: الحد الأدنى المستهدف **جهاز متوسط المدى بذاكرة 6GB RAM (Android 12+)**. أجهزة اختبار mid/high على الأقل. فحص قدرة (RAM/تخزين) قبل التنزيل/التشغيل.
- **iOS**: غير مستهدف للتسليم لكن flutter_gemma يدعمه (iOS 16+، memory entitlements) — تُترك المعمارية مفتوحة.
- **fallback**: أجهزة دون الحد الأدنى → تعطيل الوضع المحلي بلطف (والإبقاء على المسار الـ Online الحالي كخيار).

---

## 19. Packaging and Model Update Strategy

| الخيار | الوصف | متى |
|---|---|---|
| **تضمين مباشر في APK/IPA** | الموديل ضمن assets | ❌ يضخّم حجم المتجر بشدة (~1 GB) — غير مفضّل |
| **تنزيل عند أول تشغيل/Setup** | تنزيل بعد التثبيت (Wi-Fi، resume، checksum) | ✅ **المفضّل** لتحقيق offline دون تضخيم المتجر |
| **Play Asset Delivery / Split** | توصيل أصول ديناميكي (Android) | ⏳ تحسين لاحق |

- **مكان التخزين**: مجلد تطبيق خاص (app-specific storage).
- **السلامة**: checksum (SHA-256) بعد التنزيل قبل الاستخدام.
- **تشفير/تعتيم**: اختياري للميتاداتا؛ الموديل عام لا يحتاج سرية لكن يُتحقق من سلامته.
- **تحديث بدون إصدار تطبيق كامل**: manifest يحمل (modelId, version, url, checksum, minDeviceTier)؛ التطبيق يقارن الإصدار ويُحدّث عند الحاجة.
- **أجهزة لا تدعم**: منطق tier + fallback (OFF-004/FR-010).

---

## 20. Acceptance Criteria (للـ POC)

- **AC-001**: يُولِّد التطبيق **ردًا نصيًا حرًا** من **SLM محلي** على Android (6GB RAM) في وضع الطيران (US1).
- **AC-002**: على Golden Set، **≥ 70%** من الردود تحصل على تقييم جودة بشري **≥ 3/5** (مفهومة وذات صلة) بالعربية والإنجليزية والمختلط (US1/US3).
- **AC-003**: عند سؤال خارج معرفة الموديل، يردّ نصيًا بتحفّظ (لا يختلق حقائق صريحة) في غالبية الحالات (US1).
- **AC-004**: متوسط زمن الاستدلال وRAM والحجم مُسجَّلة لكل مرشّح في جدول المقاييس (US3).
- **AC-005**: لا تجميد للـ UI أثناء الاستدلال؛ حالة Thinking تعمل (FR-003).
- **AC-006**: جهاز دون الحد الأدنى/مساحة غير كافية → fallback واضح بدون كراش (US4).
- **AC-007**: وظائف الدردشة الحالية (New Chat/Reset/تمرير) سليمة (FR-013).
- **AC-008**: تنزيل الموديل **بمبادرة المستخدم من واجهة اختيار الموديل** يعمل (لا تنزيل تلقائي؛ تقدم حقيقي + checksum)، واختيار موديل مُثبَّت يفتح المحادثة دون تنزيل، والموديل النشط يُحفَظ ويعمل offline لاحقًا (FR-009/009a/009b).
- **AC-009**: توصية نهائية موثَّقة Go/No-Go + الموديل/الـ Runtime المختار.
- **AC-010** *(مؤجَّل — Future Spec)*: عند تفعيل Intent JSON لاحقًا: ≥ 90% JSON صالح مطابق للـ schema، و≥ 90% `none` للأسئلة خارج النطاق.

---

## 21. Success Metrics (مقاييس قابلة للقياس)

| المقياس | الهدف المبدئي | طريقة القياس |
|---|---|---|
| جودة الرد النصي (عربي/إنجليزي/مختلط) | ≥ 70% بتقييم ≥ 3/5 | Golden Set + تقييم بشري 1–5 |
| متوسط زمن الاستدلال | ≤ ~5s (mid-range 6GB, سؤال قصير) | timestamp قبل/بعد |
| أثر بدء التشغيل | لا تأثير (تحميل كسول) | قياس وقت إقلاع مع/بدون |
| استهلاك RAM | بلا OOM على **6GB** | أدوات profiling/النظام |
| حجم الموديل | ≤ ~1.2 GB | حجم الملف |
| البطارية/الحرارة | لا ارتفاع حرج خلال ~20 استعلامًا | رصد يدوي/أدوات النظام |
| نجاح تنزيل الموديل + offline لاحقًا | يعمل (تقدم/checksum/استئناف) | اختبار يدوي |
| سلوك الغموض/خارج المعرفة | رد متحفّظ بلا اختلاق | حالات اختبار مخصّصة |
| *(مؤجَّل)* نسبة JSON صالح | ≥ 90% (بعد retry) | تحقق آلي من schema — Future Spec |
| *(مؤجَّل)* دقة Intent | ≥ 80% | Golden Set موسوم — Future Spec |

---

## 22. Failure Criteria (متى نعتبر POC فاشلًا/نعيد التوجيه)

- جودة الرد النصي العربي/المختلط < 50% بتقييم ≥ 3/5 على Golden Set.
- زمن استدلال > ~15s على mid-range (6GB) لسؤال قصير.
- OOM/كراش متكرر على جهاز 6GB.
- حجم الموديل المقبول جودةً يتجاوز بوضوح حدود التطبيق.
> في أي من الحالات أعلاه: التوصية تتحول إلى مسار **SLM على الخادم عبر API key** (يُفعَّل كخيار في spec متقدم — انظر Clarifications/Open Questions).

---

## 23. Risks and Mitigations

| المخاطرة | التأثير | التخفيف | ما نخسره بالحل |
|---|---|---|---|
| عربية النماذج الصغيرة "مقبولة" فقط | جودة فهم أقل | حصر المهمة في Intent (تصنيف)؛ خط أساس Online | مرونة الإجابة الحرة |
| حجم ~1 GB يتعارض مع "تخزين منخفض" | تبنٍّ أقل | تنزيل بعد التثبيت لا تضمين؛ خيار Online | offline منذ اللحظة صفر |
| أجهزة C-level متفاوتة/ضعيفة | فشل تشغيل | tier check + fallback Online | تجربة محلية موحّدة |
| JSON غير صالح من نموذج صغير | كسر العقد | schema validation + retry + GBNF grammar (llama.cpp) | تعقيد runtime أعلى |
| نضج حزم Flutter للـ on-device | مخاطر تكامل/صيانة | flutter_gemma أساسي + fllama خطة B | وقت تجريب إضافي |
| بطارية/حرارة | تجربة سيئة | تقييد max tokens، تحميل كسول، تحرير الموديل | ردود أقصر |
| iOS لاحقًا (entitlements/Metal) | تأخير توسعة | اختيار runtime يدعم iOS من البداية | لا شيء جوهري |
| تسرب مخطط حساس عبر Metadata | أمني | mobile-safe فقط + تشفير at-rest | تفاصيل أقل للنموذج |

---

## 24. Open Questions (للـ Product Owner / AI Consultant)

> ✅ حُسِمت في جلسة 2026-06-29 (انظر Clarifications): مخرج المرحلة الأولى (نص حر)، التغليف (**تنزيل بمبادرة المستخدم من واجهة اختيار موديل، لا تنزيل تلقائي**)، خط الأساس Online (مؤجَّل/اختياري لاحقًا)، الحد الأدنى للجهاز (mid-range 6GB).

المتبقّي مفتوحًا:
1. **العربية**: هل الفصحى (MSA) كافية أم نحتاج دعم لهجات؟ (يؤثر على اختيار الموديل وبناء Golden Set.) — *Answer in <=5 words.*
2. **محتوى Golden Set**: نوعية الأسئلة لتقييم الرد النصي (أعمال/عام)، وحجمها النهائي (~30–50).
3. **الرخص**: موافقة قانونية على Apache-2.0 (Qwen) / Gemma Terms قبل التبني التجاري.
4. **iOS**: ضمن أي أفق زمني؟ (يحدد صرامة اختبار التوافق الآن.)
5. **توقيت Intent JSON**: متى نفتح spec المرحلة التالية لتفعيل Intent JSON + ربط البيانات؟

---

## 25. Implementation Plan (خطوات المرحلة التالية — بعد اعتماد هذا الـ Spec)

> المرحلة الأولى = **محادثة نصية محلية (free-text)**. Intent JSON مؤجَّل.

1. **تثبيت النطاق**: بناء Golden Set أولي (عربي/إنجليزي/مختلط، ~30–50 سؤالًا) لتقييم **جودة الرد النصي** + حسم سؤال اللهجات (Open Q1).
2. **PoC بيئة معزولة**: تجربة flutter_gemma مع Qwen2.5-1.5B وGemma 3 1B في تطبيق صغير (Android، 6GB) قبل الدمج — قياس latency/RAM وجودة الرد.
3. **واجهة التجريد**: تصميم `LocalSlmService` (generate نصّي) + `PromptBuilder` خلف Strategy موحّدة (تترك مكانًا لمزوّد Online اختياري لاحقًا).
4. **الدمج في الشاشة**: ربط `AiInferenceController` عند `_onSend` خلف DI لعرض الرد النصي، دون كسر الـ UI الحالي.
5. **Metadata**: إضافة `assets/ai/metadata.sample.json` (mobile-safe) + حقنها في الـ prompt كسياق.
6. **ModelManager + Model Selection UI + ActiveModelStore**: **تنزيل بمبادرة المستخدم** (لا تلقائي) + catalog manifest + حفظ حالة الموديل (installed/active) + checksum/version + استئناف/إلغاء + tier check (6GB) + fallback.
7. **القياس**: `PocMetrics` + تشغيل Golden Set على المرشّحين وتعبئة جدول المقاييس (تقييم بشري 1–5).
8. **التقرير**: توصية Go/No-Go + الموديل/الـ Runtime + المخاطر المتبقية + توقيت فتح spec الـ Intent JSON.

---

## 26. Timeline Estimate (تقديري للـ POC)

| المرحلة | المدة التقديرية |
|---|---|
| تثبيت النطاق + Golden Set | 2–3 أيام |
| تجربة الموديلات/الـ Runtime معزولة | 3–5 أيام |
| ModelCatalog + ActiveModelStore (حفظ حالة الموديل) | 2–3 أيام |
| Model Selection UI + ModelSelectionController (Entry flow) | 2–3 أيام |
| ModelManager (تنزيل بمبادرة المستخدم/checksum/version/tier) | 2–3 أيام |
| واجهة التجريد (LocalSlmService/AiInferenceController) + الدمج في الشاشة | 3–5 أيام |
| PromptBuilder + MetadataLoader (metadata.sample.json) | 2–3 أيام |
| القياس + التقرير والتوصية | 2–3 أيام |
| **الإجمالي التقريبي للـ POC** | **~2.5–4 أسابيع** (مطوّر Flutter واحد + دعم بيانات جزئي) |

---

## 27. Assumptions

- "Offline" في المرحلة الأولى يعني **فهم السؤال + توليد رد نصي حر محليًا**؛ (Intent JSON وجلب البيانات الحقيقي مؤجَّلان لمراحل لاحقة).
- الحد الأدنى للجهاز المستهدف **mid-range 6GB RAM (Android 12+)**؛ التغليف عبر **تنزيل بمبادرة المستخدم من واجهة اختيار موديل (لا تنزيل تلقائي؛ manifest فقط)**؛ القياس **محلي فقط** بلا خط أساس Online في هذه المرحلة.
- الأرقام (أحجام/سرعات) تقديرية من References وتُحسم بالقياس الفعلي على أجهزة الاختبار.
- البنية الحالية (`StatefulWidget` + `setState` + `get_it` عبر `project_management_locator`) كافية للـ POC دون إدخال state management جديد.
- شاشة الدردشة الحالية تبقى كما هي بصريًا؛ يُضاف منطق SLM خلف واجهة موحّدة دون كسر UI.
- Android هو هدف الـ POC؛ iOS مفتوح معماريًا فقط.
- لا توجد بيانات إنتاجية حقيقية في الـ POC؛ Metadata عيّنة mobile-safe فقط.
- الرخص (Apache-2.0 / Gemma Terms) ستُراجَع قانونيًا قبل التبني التجاري.

---

## 28. References (مصادر البحث — يونيو 2026)

- Qwen2.5-1.5B GGUF (Q4 ~986MB): https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF
- Arabic LLM Broad Leaderboard (ABBL, فئة Nano <3.5B): https://huggingface.co/blog/silma-ai/arabic-llm-leaderboard
- aiXplain Arabic LLM Benchmark Report (May 2025): https://aixplain.com/wp-content/uploads/2025/05/aiXplain-Arabic-Benchmark-Report-May-2025-v2.1.pdf
- Evaluating Arabic LLMs survey (ALLaM/Fanar/أحجام): https://arxiv.org/html/2510.13430v1
- Gemma 3 QAT sizes (1B int4 ~0.5GB): https://developers.googleblog.com/en/gemma-3-quantized-aware-trained-state-of-the-art-ai-to-consumer-gpus/
- flutter_gemma (pub.dev): https://pub.dev/packages/flutter_gemma
- flutter_gemma (GitHub): https://github.com/DenisovAV/flutter_gemma
- fllama (llama.cpp for Flutter): https://github.com/Telosnex/fllama
- llama_cpp_dart: https://pub.dev/packages/llama_cpp_dart
- On-Device LLM Inference Guide 2025–2026: https://docs.octomil.com/blog/on-device-llm-inference-2025-2026/
- MediaPipe/llama.cpp/ExecuTorch on Android: https://meetprajapati.com/blogs/running-on-device-ai-models-android-mediapipe-llamacpp-executorch/
- Best Mobile LLMs 2026 (Qwen2.5-1.5B multilingual, on-phone tok/s): https://www.promptquorum.com/power-local-llm/mobile-llm-models-phi4-gemma-smollm

---

## 29. Prioritized Action Plan (للبدء فورًا بعد الاعتماد)

1. **(عاجل)** حسم Open Questions المتبقية (لهجات العربية، محتوى Golden Set، الرخص).
2. **(عاجل)** تجهيز Golden Set أولي (عربي/إنجليزي/مختلط) لتقييم **جودة الرد النصي**.
3. **(أساسي)** PoC معزول بـ flutter_gemma + Qwen2.5-1.5B على جهاز Android mid-range (6GB)؛ قياس latency/RAM وجودة الرد.
4. **(أساسي)** تكرار القياس مع Gemma 3 1B (وfallback 0.5–0.6B).
5. **(دمج)** ربط النموذج الأفضل خلف `LocalSlmService` عند `_onSend` لعرض الرد النصي مع Metadata عيّنة.
6. **(تغليف)** تنفيذ Model Selection UI + ModelManager بنمط **تنزيل بمبادرة المستخدم** (لا تلقائي) + ActiveModelStore (حفظ الموديل المُثبَّت/النشط) + checksum/version + tier check.
7. **(قرار)** تجميع المقاييس وكتابة توصية Go/No-Go والموديل/الـ Runtime النهائي.
8. **(تجهيز المرحلة التالية)** عند Go: الانتقال إلى `/speckit-plan` لتفصيل تصميم المرحلة الأولى (free-text)، ثم فتح spec لاحق لـ Intent JSON + ربط البيانات.
