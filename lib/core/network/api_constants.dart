final class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'https://job.professionalacademyedu.com';

  // API Endpoints
  static const String register = '/api/front/register';
  static const String login = '/api/front/login';
  static const String logout = '/api/front/logout';
  static const String refreshToken = '/api/front/refresh';
  static const String categories = '/api/front/categories';
  static const String cards = '/api/front/cards';
  static const String cart = '/api/front/cart';
  static const String createOrder = '/api/front/create-order';
  static const String favorite = '/api/front/favorite';
  static const String offers = '/api/front/offers';
  static const String updateProfile = '/api/front/update-profile';
  static const String contactUs = '/api/contacts';
  static const String checkAuth = '/api/front/check-auth';
  
  static String orderDetails(String orderNumber) => '/api/front/order/$orderNumber';
  static String deleteOrder(int orderId) => '/api/front/order/$orderId';
  static String orderChangeStatus(int orderId) => '/api/orders/change-status/$orderId';
  static String orderById(int orderId) => '/api/orders/$orderId';
  static const String deleteAccount = '/api/user/delete';
}

