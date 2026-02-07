class AppStrings {
  final bool isArabic;

  AppStrings(this.isArabic);
  // ================= Dental Chart =================

  String get orthodonticDiagnosisTitle =>
      isArabic ? 'تشخيص تقويم الأسنان' : 'Orthodontic Diagnosis';

  String get upperLabel => isArabic ? 'الفك العلوي' : 'Upper';

  String get lowerLabel => isArabic ? 'الفك السفلي' : 'Lower';

  String get finalLabel => isArabic ? 'النتيجة النهائية' : 'Final';

  String get toothText => isArabic ? 'سن' : 'Tooth';

  String get settings => isArabic ? "الإعدادات" : "Settings";
  String get darkMode => isArabic ? "الوضع الداكن" : "Dark Mode";
  String get LightMode => isArabic ? "الوضع الفاتح" : "Light Mode";
  String get language =>
      isArabic ? "اللغة (عربي / إنجليزي)" : "Language (AR/EN)";
  String get logout => isArabic ? "تسجيل الخروج" : "Log Out";

  String get bookings => isArabic ? "الحجوزات" : "Booking";
  String get show => isArabic ? "عرض" : "Show";

  String get rateFeedback =>
      isArabic ? "التقييم والملاحظات" : "Rate & Feedback";
  String get cancel => isArabic ? "إلغاء" : "Cancel";
  String get send => isArabic ? "إرسال" : "Send";

  String get aiDental =>
      isArabic ? "علاج الأسنان بالذكاء الاصطناعي" : "Dental Treatment with AI";

  String get uploadPanorama => isArabic ? "رفع صورة الأشعة" : "Upload Panorama";

  String get chooseFile => isArabic ? "اختر ملف" : "Choose File";
  // Auth
  String get welcomeLogin =>
      isArabic
          ? "مرحبًا، استخدم بريدك الإلكتروني لتسجيل الدخول"
          : "Welcome, Use Your Email To Sign On";

  String get emailHint => isArabic ? "example@email.com" : "Example@email.com";

  String get confirm => isArabic ? "تسجيل دخول" : "Login";

  String get loggingIn => isArabic ? "جاري تسجيل الدخول..." : "Logging in...";

  String get noAccount =>
      isArabic ? "ليس لديك حساب؟" : "Don't have an account?";

  String get signUp => isArabic ? "إنشاء حساب" : "Sign up";

  // Dialogs
  String get tapStars =>
      isArabic ? "اضغط على النجوم للتقييم:" : "Tap the stars to rate:";
  String get writeFeedback =>
      isArabic ? "اكتب ملاحظاتك هنا..." : "Write your feedback here...";

  String get selectRating =>
      isArabic ? "يرجى اختيار تقييم." : "Please select a rating.";

  // Logout
  String get loggingOut => isArabic ? "جاري تسجيل الخروج..." : "Logging out...";
  String get confirmLogout =>
      isArabic
          ? "هل أنت متأكد أنك تريد تسجيل الخروج؟"
          : "Are you sure you want to logout?";

  String get Keepsmile =>
      isArabic
          ? "حافظ على صحة ابتسامتك اليوم!"
          : "Keep your smile healthy today!";

  // Before / After
  String get before => isArabic ? "قبل" : "Before";
  String get after => isArabic ? "بعد" : "After";

  // Home
  String get topDoctors => isArabic ? " الرئيسية " : "Home";
  String get seeAll => isArabic ? "عرض الكل" : "See All";

  // Edit Profile
  String get editProfile => isArabic ? "تعديل الملف الشخصي" : "Edit Profile";
  String get displayName => isArabic ? "الاسم المعروض" : "Display Name";
  String get userName => isArabic ? "اسم المستخدم" : "User Name";
  String get email => isArabic ? "البريد الإلكتروني" : "Email";
  String get emailOptional =>
      isArabic ? "البريد الإلكتروني (اختياري)" : "Email (Optional)";
  String get phoneNumber => isArabic ? "رقم الهاتف" : "Phone Number";
  String get saveEdit => isArabic ? "حفظ التعديل" : "Save Edit";
  String get selectPhoto =>
      isArabic ? "اختر صورتك الشخصية" : "select your photo";

  // Messages
  String get uploadingPhoto =>
      isArabic ? "جاري رفع الصورة..." : "Uploading photo...";
  String get deletingPhoto =>
      isArabic ? "جاري حذف الصورة..." : "Deleting photo...";
  String get selectImageFirst =>
      isArabic ? "يرجى اختيار صورة أولاً!" : "Select image first!";
  String get profileUpdated =>
      isArabic
          ? "تم تحديث الملف الشخصي بنجاح!"
          : "Profile updated successfully!";
  // Booking
  String get booking => isArabic ? "الحجوزات" : "Booking";
  String get findSpecialist =>
      isArabic ? "ابحث عن طبيب مختص" : "Find a Specialist";
  String get browseDoctors =>
      isArabic
          ? "تصفح الأطباء وإدارة مواعيدك."
          : "Browse doctors and manage your appointments.";

  // Tabs
  String get onProgress => isArabic ? "قيد التنفيذ" : "OnProgress";
  String get waiting => isArabic ? "قيد الانتظار" : "Waiting";
  String get done => isArabic ? "مكتمل" : "Done";
  String get canceled => isArabic ? "ملغي" : "Canceled";

  // ===== AI PAGE =====
  String get aiTreatment =>
      isArabic ? 'علاج الأسنان بالذكاء الاصطناعي' : 'Dental Treatment with AI';

  String get aiScanTitle =>
      isArabic ? 'فحص العلاج بالذكاء الاصطناعي' : 'AI Treatment Scan';

  String get aiScanDesc =>
      isArabic
          ? 'حلّل أسنانك باستخدام الذكاء الاصطناعي\nلاكتشاف المشاكل المحتملة.'
          : 'Analyze your teeth with AI\nto detect possible issues.';

  String get submit => isArabic ? 'تشخيص الأسنان' : 'Dental diagnosis';
  String get OrthodonticDiagnosis =>
      isArabic ? 'تشخيص التقويمي' : 'Orthodontic Diagnosis';
  String get Close => isArabic ? 'إغلاق' : 'Close';
  // ===== SHOW RESULT =====
  String get showResultTitle =>
      isArabic
          ? 'سيتم عرض نتيجة علاج الأسنان هنا'
          : 'Here will show the result of your tooth treatment';

  String get showResultDesc =>
      isArabic
          ? 'يقوم الذكاء الاصطناعي بتحليل صورتك بدقة، ويحدد أي أسنان قد تعاني من مشاكل، ويُبرز المناطق التي تحتاج إلى اهتمام.\n\n'
              'يساعدك ذلك على فهم حالتك السنية بوضوح قبل زيارة طبيب الأسنان — سريع، دقيق، وسهل الاستخدام.'
          : 'The AI carefully analyzes your image, identifies any teeth that may have issues, and highlights areas that need attention.\n\n'
              'This helps you understand your dental condition clearly before visiting your dentist — quick, accurate, and easy to use.';

  String get showResultInstruction =>
      isArabic
          ? 'لبدء تحليل الأسنان بالذكاء الاصطناعي، انتقل إلى الخطوة التالية ودع النظام يفحص أسنانك باستخدام الكشف الذكي.'
          : 'To begin your AI dental analysis, continue to the next step and let the system examine your teeth with smart detection.';

  String get startAiTreatment =>
      isArabic ? 'ابدأ علاج الذكاء الاصطناعي' : 'Start AI Treatment';

  // ===== DOCTORS LIST =====
  String get doctors => isArabic ? 'الأطباء' : 'Doctors';

  String get doctorsHint =>
      isArabic
          ? 'اختر الطبيب المناسب لاحتياجاتك.\nابحث بالاسم، التخصص، أو الموقع.'
          : 'Click the right doctor for your needs.\nSearch by doctor, specialization, or location.';

  String get search => isArabic ? 'بحث...' : 'Search...';

  String get noDoctors => isArabic ? 'لا يوجد أطباء' : 'No doctors found';

  String get specialization => isArabic ? 'التخصص' : 'Specialization';

  String get time => isArabic ? 'الوقت' : 'Time';

  String get km => isArabic ? 'كم' : 'KM';

  String get notAvailable => isArabic ? 'غير متوفر' : 'N/A';

  // ===== DOCTOR DETAILS =====

  String get selectTime => isArabic ? 'اختر الوقت' : 'Select Time';

  String get selectDate => isArabic ? 'اختر التاريخ' : 'Select Date';

  String get takeDate => isArabic ? 'احجز موعد' : 'Book Appointment';

  String get distance => isArabic ? 'المسافة' : 'Distance';

  String get availableTime => isArabic ? 'الوقت المتاح' : 'Available Time';
}
