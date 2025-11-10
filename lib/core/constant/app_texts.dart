import 'package:flutter/material.dart';

import '../localization/app_language.dart';

final class AppTexts {
  AppTexts._();

  static AppLanguage _currentLanguage = AppLanguage.ar;

  static void updateLocale(Locale locale) {
    _currentLanguage = appLanguageFromLocale(locale);
  }

  static AppLanguage get currentLanguage => _currentLanguage;

  static String _text(String key) {
    final translations = _localizedValues[key];
    if (translations == null) return key;
    return translations[_currentLanguage] ??
        translations[AppLanguage.en] ??
        key;
  }

  static String get welcomeBack => _text('welcomeBack');
  static String get loginToCont => _text('loginToCont');
  static String get email => _text('email');
  static String get password => _text('password');
  static String get confirmPassword => _text('confirmPassword');
  static String get phoneNum => _text('phoneNum');
  static String get login => _text('login');
  static String get loginLoading => _text('loginLoading');
  static String get pleaseEnterPass => _text('pleaseEnterPass');
  static String get pleaseEnterEmail => _text('pleaseEnterEmail');
  static String get pleaseEnterValidEmail => _text('pleaseEnterValidEmail');
  static String get loginSuccess => _text('loginSuccess');
  static String get signUp => _text('signUp');
  static String get fullName => _text('fullName');
  static String get dontHaveAcc => _text('dontHaveAcc');
  static String get createAcc => _text('createAcc');

  static String get onTitle1 => _text('onTitle1');
  static String get onDesTitle1 => _text('onDesTitle1');
  static String get onTitle2 => _text('onTitle2');
  static String get onDesTitle2 => _text('onDesTitle2');
  static String get onTitle3 => _text('onTitle3');
  static String get onDesTitle3 => _text('onDesTitle3');

  static String get skip => _text('skip');
  static String get prev => _text('prev');
  static String get getStarted => _text('getStarted');
  static String get next => _text('next');
  static String get camera => _text('camera');
  static String get gallery => _text('gallery');
  static String get videoAvailable => _text('videoAvailable');
  static String get tapToPlay => _text('tapToPlay');
  static String get cart => _text('cart');
  static String get cartEmpty => _text('cartEmpty');
  static String get addItemsToCart => _text('addItemsToCart');

  static String get allProducts => _text('allProducts');
  static String get bestProducts => _text('bestProducts');
  static String get viewProducts => _text('viewProducts');
  static String get noAvailableProducts => _text('noAvailableProducts');

  static String get settings => _text('settings');
  static String get updateProfile => _text('updateProfile');
  static String get editYourInfo => _text('editYourInfo');
  static String get contactUs => _text('contactUs');
  static String get sendUsMessage => _text('sendUsMessage');
  static String get logout => _text('logout');
  static String get logoutConfirmationMessage =>
      _text('logoutConfirmationMessage');
  static String get cancel => _text('cancel');
  static String get signOutReturn => _text('signOutReturn');
  static String get language => _text('language');
  static String get changeLanguage => _text('changeLanguage');
  static String get arabic => _text('arabic');
  static String get english => _text('english');
  static String get allBrands => _text('allBrands');
  static String get noBrandsAvailable => _text('noBrandsAvailable');
  static String get seeAll => _text('seeAll');
  static String get myAccount => _text('myAccount');
  static String get orders => _text('orders');
  static String get noOrdersYet => _text('noOrdersYet');
  static String get total => _text('total');
  static String get checkout => _text('checkout');
  static String get eGP => _text('eGP');
  static String get contactInformation => _text('contactInformation');
  static String get phone => _text('phone');
  static String get pleaseEnterPhone => _text('pleaseEnterPhone');
  static String get shippingAddress => _text('shippingAddress');
  static String get addressLine => _text('addressLine');
  static String get pleaseEnterAddress => _text('pleaseEnterAddress');
  static String get city => _text('city');
  static String get pleaseEnterCity => _text('pleaseEnterCity');
  static String get state => _text('state');
  static String get pleaseEnterState => _text('pleaseEnterState');
  static String get zipCode => _text('zipCode');
  static String get pleaseEnterZipCode => _text('pleaseEnterZipCode');
  static String get paymentMethod => _text('paymentMethod');
  static String get card => _text('card');
  static String get cash => _text('cash');
  static String get promoCodeOptional => _text('promoCodeOptional');
  static String get enterPromoCode => _text('enterPromoCode');
  static String get processing => _text('processing');
  static String get placeOrder => _text('placeOrder');
  static String get search => _text('search');
  static String get searchProductsHint => _text('searchProductsHint');
  static String get startTypingToSearchProducts =>
      _text('startTypingToSearchProducts');
  static String get noResultsFound => _text('noResultsFound');
  static String get wishlist => _text('wishlist');
  static String get retry => _text('retry');
  static String get wishlistEmpty => _text('wishlistEmpty');
  static String get addItemsToWishlist => _text('addItemsToWishlist');
  static String get addReview => _text('addReview');
  static String get pleaseSelectRating => _text('pleaseSelectRating');
  static String get rateThisProduct => _text('rateThisProduct');
  static String get writeYourReview => _text('writeYourReview');
  static String get shareYourExperience => _text('shareYourExperience');
  static String get pleaseWriteReview => _text('pleaseWriteReview');
  static String get reviewMinCharacters => _text('reviewMinCharacters');
  static String get submitting => _text('submitting');
  static String get submitReview => _text('submitReview');
  static String get order => _text('order');
  static String get orderInformation => _text('orderInformation');
  static String get orderNumberLabel => _text('orderNumberLabel');
  static String get orderDate => _text('orderDate');
  static String get customer => _text('customer');
  static String get paymentInformation => _text('paymentInformation');
  static String get paymentStatus => _text('paymentStatus');
  static String get promoCode => _text('promoCode');
  static String get orderItems => _text('orderItems');
  static String get quantity => _text('quantity');
  static String get paid => _text('paid');
  static String get pending => _text('pending');
  static String get cancelOrder => _text('cancelOrder');
  static String get deleteOrder => _text('deleteOrder');
  static String get confirmCancelOrder => _text('confirmCancelOrder');
  static String get cancelOrderConfirmationMessage =>
      _text('cancelOrderConfirmationMessage');
  static String get confirmDeleteOrder => _text('confirmDeleteOrder');
  static String get deleteOrderConfirmationMessage =>
      _text('deleteOrderConfirmationMessage');
  static String get orderCancelledSuccess => _text('orderCancelledSuccess');
  static String get orderDeletedSuccess => _text('orderDeletedSuccess');
  static String get orderNotLoaded => _text('orderNotLoaded');
  static String get close => _text('close');
  static String get deleteAccount => _text('deleteAccount');
  static String get deleteAccountConfirmationTitle =>
      _text('deleteAccountConfirmationTitle');
  static String get deleteAccountConfirmationMessage =>
      _text('deleteAccountConfirmationMessage');
  static String get deleteAccountSuccess => _text('deleteAccountSuccess');
  static String get shopWithConfidence => _text('shopWithConfidence');
  static String get secureTransaction => _text('secureTransaction');
  static String get safeDelivery => _text('safeDelivery');
  static String get returnIn15Days => _text('returnIn15Days');
  static String get freeDelivery => _text('freeDelivery');
  static String get oneYearWarranty => _text('oneYearWarranty');
  static String get description => _text('description');
  static String get productDetails => _text('productDetails');
  static String get type => _text('type');
  static String get color => _text('color');
  static String get quantityAvailable => _text('quantityAvailable');
  static String get inCart => _text('inCart');
  static String get addToCart => _text('addToCart');
  static String get addingToCart => _text('addingToCart');
  static String get reviewsTitle => _text('reviewsTitle');
  static String get reviewsCountLabel => _text('reviewsCountLabel');
  static String get writeAReview => _text('writeAReview');
  static String get anonymous => _text('anonymous');
  static String get failedToUpdateCart => _text('failedToUpdateCart');
  static String get off => _text('off');

  static const Map<String, Map<AppLanguage, String>> _localizedValues = {
    'welcomeBack': {
      AppLanguage.en: 'Welcome back',
      AppLanguage.ar: 'مرحباً بعودتك',
    },
    'loginToCont': {
      AppLanguage.en: 'Login to continue',
      AppLanguage.ar: 'سجّل الدخول للمتابعة',
    },
    'email': {AppLanguage.en: 'Email', AppLanguage.ar: 'البريد الإلكتروني'},
    'total': {AppLanguage.en: 'Total', AppLanguage.ar: 'المجموع'},
    'eGP': {AppLanguage.en: 'EGP', AppLanguage.ar: 'جنيه'},
    'checkout': {AppLanguage.en: 'Checkout', AppLanguage.ar: 'الدفع'},
    'myAccount': {AppLanguage.en: 'My Account', AppLanguage.ar: 'حسابي'},
    'noOrdersYet': {
      AppLanguage.en: 'No Orders Yet',
      AppLanguage.ar: 'لا يوجد طالبات',
    },
    'orders': {AppLanguage.en: 'Orders', AppLanguage.ar: 'طلباتي'},
    'allBrands': {
      AppLanguage.en: 'All Brands',
      AppLanguage.ar: 'جميع الماركات',
    },
    'seeAll': {AppLanguage.en: 'see all', AppLanguage.ar: 'كل المنتجات'},
    'noBrandsAvailable': {
      AppLanguage.en: 'No Brands available',
      AppLanguage.ar: 'لا يوجد ماركات متاحه',
    },
    'password': {AppLanguage.en: 'Password', AppLanguage.ar: 'كلمة المرور'},
    'confirmPassword': {
      AppLanguage.en: 'Confirm password',
      AppLanguage.ar: 'تأكيد كلمة المرور',
    },
    'phoneNum': {AppLanguage.en: 'Phone number', AppLanguage.ar: 'رقم الهاتف'},
    'login': {AppLanguage.en: 'Login', AppLanguage.ar: 'تسجيل الدخول'},
    'loginLoading': {
      AppLanguage.en: 'Logging in...',
      AppLanguage.ar: 'جارٍ تسجيل الدخول...',
    },
    'pleaseEnterPass': {
      AppLanguage.en: 'Please enter your password',
      AppLanguage.ar: 'يرجى إدخال كلمة المرور',
    },
    'pleaseEnterEmail': {
      AppLanguage.en: 'Please enter your email',
      AppLanguage.ar: 'يرجى إدخال البريد الإلكتروني',
    },
    'pleaseEnterValidEmail': {
      AppLanguage.en: 'Please enter a valid email',
      AppLanguage.ar: 'يرجى إدخال بريد إلكتروني صالح',
    },
    'loginSuccess': {
      AppLanguage.en: 'Login successful!',
      AppLanguage.ar: 'تم تسجيل الدخول بنجاح!',
    },
    'signUp': {AppLanguage.en: 'Sign Up', AppLanguage.ar: 'إنشاء حساب'},
    'fullName': {AppLanguage.en: 'Full name', AppLanguage.ar: 'الاسم الكامل'},
    'dontHaveAcc': {
      AppLanguage.en: 'Don\'t have an account?',
      AppLanguage.ar: 'ليس لديك حساب؟',
    },
    'createAcc': {
      AppLanguage.en: 'Create Account',
      AppLanguage.ar: 'إنشاء حساب',
    },
    'onTitle1': {
      AppLanguage.en: 'All Your Spare Parts\nin One Place',
      AppLanguage.ar: 'جميع قطع الغيار الإلكترونية\nفي مكان واحد',
    },
    'onDesTitle1': {
      AppLanguage.en: 'Discover a wide range of original electronic spare parts, all at your fingertips.',
      AppLanguage.ar: 'اكتشف مجموعة واسعة من قطع الغيار الأصلية للأجهزة الإلكترونية، جميعها بين يديك.',
    },
    'onTitle2': {
      AppLanguage.en: 'Search & Order Instantly',
      AppLanguage.ar: 'ابحث واطلب فوراً',
    },
    'onDesTitle2': {
      AppLanguage.en:
          'Use smart search to find the right part for your device in seconds.',
      AppLanguage.ar:
          'استخدم البحث الذكي للعثور على القطعة المناسبة لجهازك في ثوانٍ.',
    },
    'onTitle3': {
      AppLanguage.en: 'Fast & Secure Delivery',
      AppLanguage.ar: 'توصيل سريع وآمن',
    },
    'onDesTitle3': {
      AppLanguage.en: 'Get your orders delivered quickly and safely right to your doorstep.',
      AppLanguage.ar: 'استلم طلباتك بسرعة وأمان حتى باب منزلك.',
    },
    'skip': {AppLanguage.en: 'Skip', AppLanguage.ar: 'تخطي'},
    'prev': {AppLanguage.en: 'Prev', AppLanguage.ar: 'السابق'},
    'getStarted': {AppLanguage.en: 'Get Started', AppLanguage.ar: 'ابدأ الآن'},
    'next': {AppLanguage.en: 'Next', AppLanguage.ar: 'التالي'},
    'camera': {AppLanguage.en: 'Camera', AppLanguage.ar: 'الكاميرا'},
    'gallery': {AppLanguage.en: 'Gallery', AppLanguage.ar: 'المعرض'},
    'videoAvailable': {
      AppLanguage.en: 'Video Available',
      AppLanguage.ar: 'فيديو متاح',
    },
    'tapToPlay': {
      AppLanguage.en: 'Tap to play',
      AppLanguage.ar: 'اضغط للتشغيل',
    },
    'cart': {AppLanguage.en: 'Cart', AppLanguage.ar: 'السلة'},
    'cartEmpty': {
      AppLanguage.en: 'Your cart is empty',
      AppLanguage.ar: 'سلة التسوق فارغة',
    },
    'addItemsToCart': {
      AppLanguage.en: 'Add items to your cart to see them here',
      AppLanguage.ar: 'أضف عناصر إلى سلة التسوق لتظهر هنا',
    },
    'allProducts': {
      AppLanguage.en: 'All Products',
      AppLanguage.ar: 'كل المنتجات',
    },
    'bestProducts': {
      AppLanguage.en: 'Best Products',
      AppLanguage.ar: 'أفضل المنتجات',
    },
    'viewProducts': {
      AppLanguage.en: 'View Product',
      AppLanguage.ar: 'عرض المنتج',
    },
    'noAvailableProducts': {
      AppLanguage.en: 'No products available',
      AppLanguage.ar: 'لا توجد منتجات متاحة',
    },
    'settings': {AppLanguage.en: 'Settings', AppLanguage.ar: 'الإعدادات'},
    'updateProfile': {
      AppLanguage.en: 'Update Profile',
      AppLanguage.ar: 'تحديث الملف الشخصي',
    },
    'editYourInfo': {
      AppLanguage.en: 'Edit your info',
      AppLanguage.ar: 'عدّل معلوماتك',
    },
    'contactUs': {AppLanguage.en: 'Contact Us', AppLanguage.ar: 'تواصل معنا'},
    'sendUsMessage': {
      AppLanguage.en: 'Send us a message',
      AppLanguage.ar: 'أرسل لنا رسالة',
    },
    'logout': {AppLanguage.en: 'Logout', AppLanguage.ar: 'تسجيل الخروج'},
    'logoutConfirmationMessage': {
      AppLanguage.en: 'Are you sure you want to logout?',
      AppLanguage.ar: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
    },
    'cancel': {AppLanguage.en: 'Cancel', AppLanguage.ar: 'إلغاء'},
    'signOutReturn': {
      AppLanguage.en: 'Sign out and return to login',
      AppLanguage.ar: 'سجّل الخروج وعد إلى شاشة الدخول',
    },
    'language': {AppLanguage.en: 'Language', AppLanguage.ar: 'اللغة'},
    'changeLanguage': {
      AppLanguage.en: 'Change the app language',
      AppLanguage.ar: 'غيّر لغة التطبيق',
    },
    'arabic': {AppLanguage.en: 'Arabic', AppLanguage.ar: 'العربية'},
    'english': {AppLanguage.en: 'English', AppLanguage.ar: 'الإنجليزية'},
    'contactInformation': {
      AppLanguage.en: 'Contact Information',
      AppLanguage.ar: 'معلومات التواصل',
    },
    'phone': {AppLanguage.en: 'Phone', AppLanguage.ar: 'الهاتف'},
    'pleaseEnterPhone': {
      AppLanguage.en: 'Please enter your phone number',
      AppLanguage.ar: 'يرجى إدخال رقم هاتفك',
    },
    'shippingAddress': {
      AppLanguage.en: 'Shipping Address',
      AppLanguage.ar: 'عنوان الشحن',
    },
    'addressLine': {
      AppLanguage.en: 'Address Line',
      AppLanguage.ar: 'العنوان التفصيلي',
    },
    'pleaseEnterAddress': {
      AppLanguage.en: 'Please enter your address',
      AppLanguage.ar: 'يرجى إدخال عنوانك',
    },
    'city': {AppLanguage.en: 'City', AppLanguage.ar: 'المدينة'},
    'pleaseEnterCity': {
      AppLanguage.en: 'Please enter city',
      AppLanguage.ar: 'يرجى إدخال المدينة',
    },
    'state': {AppLanguage.en: 'State', AppLanguage.ar: 'المحافظة'},
    'pleaseEnterState': {
      AppLanguage.en: 'Please enter state',
      AppLanguage.ar: 'يرجى إدخال المحافظة',
    },
    'zipCode': {AppLanguage.en: 'Zip Code', AppLanguage.ar: 'الرمز البريدي'},
    'pleaseEnterZipCode': {
      AppLanguage.en: 'Please enter zip code',
      AppLanguage.ar: 'يرجى إدخال الرمز البريدي',
    },
    'paymentMethod': {
      AppLanguage.en: 'Payment Method',
      AppLanguage.ar: 'طريقة الدفع',
    },
    'card': {AppLanguage.en: 'Card', AppLanguage.ar: 'بطاقة'},
    'cash': {AppLanguage.en: 'Cash', AppLanguage.ar: 'نقداً'},
    'promoCodeOptional': {
      AppLanguage.en: 'Promo Code (Optional)',
      AppLanguage.ar: 'رمز الخصم (اختياري)',
    },
    'enterPromoCode': {
      AppLanguage.en: 'Enter promo code',
      AppLanguage.ar: 'أدخل رمز الخصم',
    },
    'processing': {
      AppLanguage.en: 'Processing...',
      AppLanguage.ar: 'جارٍ المعالجة...',
    },
    'placeOrder': {
      AppLanguage.en: 'Place Order',
      AppLanguage.ar: 'إتمام الطلب',
    },
    'search': {AppLanguage.en: 'Search', AppLanguage.ar: 'بحث'},
    'searchProductsHint': {
      AppLanguage.en: 'Search products...',
      AppLanguage.ar: 'ابحث عن المنتجات...',
    },
    'startTypingToSearchProducts': {
      AppLanguage.en: 'Start typing to search products',
      AppLanguage.ar: 'ابدأ بالكتابة للبحث عن المنتجات',
    },
    'noResultsFound': {
      AppLanguage.en: 'No results found',
      AppLanguage.ar: 'لا توجد نتائج',
    },
    'wishlist': {AppLanguage.en: 'Wishlist', AppLanguage.ar: 'المفضلة'},
    'retry': {AppLanguage.en: 'Retry', AppLanguage.ar: 'إعادة المحاولة'},
    'wishlistEmpty': {
      AppLanguage.en: 'Your wishlist is empty',
      AppLanguage.ar: 'قائمة المفضلة فارغة',
    },
    'addItemsToWishlist': {
      AppLanguage.en: 'Add items to your wishlist to see them here',
      AppLanguage.ar: 'أضف عناصر إلى قائمة المفضلة لتظهر هنا',
    },
    'addReview': {AppLanguage.en: 'Add Review', AppLanguage.ar: 'إضافة مراجعة'},
    'pleaseSelectRating': {
      AppLanguage.en: 'Please select a rating',
      AppLanguage.ar: 'يرجى اختيار التقييم',
    },
    'rateThisProduct': {
      AppLanguage.en: 'Rate this product',
      AppLanguage.ar: 'قيّم هذا المنتج',
    },
    'writeYourReview': {
      AppLanguage.en: 'Write your review',
      AppLanguage.ar: 'اكتب مراجعتك',
    },
    'shareYourExperience': {
      AppLanguage.en: 'Share your experience...',
      AppLanguage.ar: 'شاركنا تجربتك...',
    },
    'pleaseWriteReview': {
      AppLanguage.en: 'Please write a review',
      AppLanguage.ar: 'يرجى كتابة مراجعة',
    },
    'reviewMinCharacters': {
      AppLanguage.en: 'Review must be at least 10 characters',
      AppLanguage.ar: 'يجب أن تحتوي المراجعة على 10 أحرف على الأقل',
    },
    'submitting': {
      AppLanguage.en: 'Submitting...',
      AppLanguage.ar: 'جارٍ الإرسال...',
    },
    'submitReview': {
      AppLanguage.en: 'Submit Review',
      AppLanguage.ar: 'إرسال المراجعة',
    },
    'description': {AppLanguage.en: 'Description', AppLanguage.ar: 'الوصف'},
    'productDetails': {
      AppLanguage.en: 'Product Details',
      AppLanguage.ar: 'تفاصيل المنتج',
    },
    'type': {AppLanguage.en: 'Type', AppLanguage.ar: 'النوع'},
    'color': {AppLanguage.en: 'Color', AppLanguage.ar: 'اللون'},
    'quantityAvailable': {AppLanguage.en: 'Quantity Available', AppLanguage.ar: 'الكمية المتاحة',},
    'inCart': {AppLanguage.en: 'In Cart', AppLanguage.ar: 'في السلة'},
    'addToCart': {
      AppLanguage.en: 'Add to Cart',
      AppLanguage.ar: 'أضف إلى السلة',
    },
    'addingToCart': {
      AppLanguage.en: 'Adding to Cart...',
      AppLanguage.ar: 'جارٍ الإضافة إلى السلة...',
    },
    'reviewsTitle': {AppLanguage.en: 'Reviews', AppLanguage.ar: 'المراجعات'},
    'reviewsCountLabel': {AppLanguage.en: 'reviews', AppLanguage.ar: 'مراجعات'},
    'writeAReview': {
      AppLanguage.en: 'Write a Review',
      AppLanguage.ar: 'اكتب مراجعة',
    },
    'anonymous': {AppLanguage.en: 'Anonymous', AppLanguage.ar: 'مجهول'},
    'failedToUpdateCart': {
      AppLanguage.en: 'Failed to update cart',
      AppLanguage.ar: 'فشل تحديث السلة',
    },
    'off': {AppLanguage.en: 'Off', AppLanguage.ar: 'خصم'},
    'order': {AppLanguage.en: 'Order', AppLanguage.ar: 'طلب'},
    'orderInformation': {
      AppLanguage.en: 'Order Information',
      AppLanguage.ar: 'معلومات الطلب',
    },
    'orderNumberLabel': {
      AppLanguage.en: 'Order Number',
      AppLanguage.ar: 'رقم الطلب',
    },
    'orderDate': {AppLanguage.en: 'Date', AppLanguage.ar: 'التاريخ'},
    'customer': {AppLanguage.en: 'Customer', AppLanguage.ar: 'العميل'},
    'paymentInformation': {
      AppLanguage.en: 'Payment Information',
      AppLanguage.ar: 'معلومات الدفع',
    },
    'paymentStatus': {
      AppLanguage.en: 'Payment Status',
      AppLanguage.ar: 'حالة الدفع',
    },
    'promoCode': {AppLanguage.en: 'Promo Code', AppLanguage.ar: 'رمز الخصم'},
    'orderItems': {
      AppLanguage.en: 'Order Items',
      AppLanguage.ar: 'عناصر الطلب',
    },
    'quantity': {AppLanguage.en: 'Qty', AppLanguage.ar: 'الكمية'},
    'paid': {AppLanguage.en: 'Paid', AppLanguage.ar: 'مدفوع'},
    'pending': {AppLanguage.en: 'Pending', AppLanguage.ar: 'قيد الانتظار'},
    'cancelOrder': {
      AppLanguage.en: 'Cancel Order',
      AppLanguage.ar: 'إلغاء الطلب',
    },
    'deleteOrder': {
      AppLanguage.en: 'Delete Order',
      AppLanguage.ar: 'حذف الطلب',
    },
    'confirmCancelOrder': {
      AppLanguage.en: 'Confirm Cancellation',
      AppLanguage.ar: 'تأكيد الإلغاء',
    },
    'cancelOrderConfirmationMessage': {
      AppLanguage.en: 'Are you sure you want to cancel this order?',
      AppLanguage.ar: 'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟',
    },
    'confirmDeleteOrder': {
      AppLanguage.en: 'Confirm Deletion',
      AppLanguage.ar: 'تأكيد الحذف',
    },
    'deleteOrderConfirmationMessage': {
      AppLanguage.en: 'Are you sure you want to delete this order?',
      AppLanguage.ar: 'هل أنت متأكد أنك تريد حذف هذا الطلب؟',
    },
    'orderCancelledSuccess': {
      AppLanguage.en: 'Order cancelled successfully.',
      AppLanguage.ar: 'تم إلغاء الطلب بنجاح.',
    },
    'orderDeletedSuccess': {
      AppLanguage.en: 'Order deleted successfully.',
      AppLanguage.ar: 'تم حذف الطلب بنجاح.',
    },
    'orderNotLoaded': {
      AppLanguage.en: 'Order data is not available yet.',
      AppLanguage.ar: 'بيانات الطلب غير متاحة بعد.',
    },
    'close': {AppLanguage.en: 'Close', AppLanguage.ar: 'إغلاق'},
    'deleteAccount': {
      AppLanguage.en: 'Delete Account',
      AppLanguage.ar: 'حذف الحساب',
    },
    'deleteAccountConfirmationTitle': {
      AppLanguage.en: 'Confirm Account Deletion',
      AppLanguage.ar: 'تأكيد حذف الحساب',
    },
    'deleteAccountConfirmationMessage': {
      AppLanguage.en:
          'This action is permanent. Do you really want to delete your account?',
      AppLanguage.ar: 'هذا الإجراء نهائي. هل تريد بالتأكيد حذف حسابك؟',
    },
    'deleteAccountSuccess': {
      AppLanguage.en: 'Account deleted successfully.',
      AppLanguage.ar: 'تم حذف الحساب بنجاح.',
    },
    'shopWithConfidence': {
      AppLanguage.en: 'Shop with confidence',
      AppLanguage.ar: 'تسوق بثقة',
    },
    'secureTransaction': {
      AppLanguage.en: 'Secure transaction',
      AppLanguage.ar: 'معاملتك آمنة',
    },
    'safeDelivery': {
      AppLanguage.en: 'Safe delivery',
      AppLanguage.ar: 'توصيلك آمن',
    },
    'returnIn15Days': {
      AppLanguage.en: '15-day return',
      AppLanguage.ar: '١٥ يوم للارجاع',
    },
    'freeDelivery': {
      AppLanguage.en: 'Free delivery',
      AppLanguage.ar: 'توصيل مجاني',
    },
    'oneYearWarranty': {
      AppLanguage.en: '1-year warranty',
      AppLanguage.ar: 'ضمان لمدة عام',
    },
  };
}
