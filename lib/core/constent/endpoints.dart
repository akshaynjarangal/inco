class Api {
  // Base URL for the API
  static const String baseUrl = 'http://192.168.1.7:8000/api';

  // Endpoints
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String register = '$baseUrl/register';
  static const String userProfile = '$baseUrl/profile';
  static const String updateProfile = '$baseUrl/edit-profile';
  static const String updateProfileImage = '$baseUrl/update-profile-image';
  static const String createQr = '$baseUrl/create-qrcode';
  static const String addProduct = '$baseUrl/add-product';
  static const String getproducts = '$baseUrl/products';
  static const String deleteProduct = '$baseUrl/delete-product';
  static const String uploadQrdata = '$baseUrl/get-points';
  static const String redeemProduct = '$baseUrl/redeem-product';
  static const String getRedeemHistory = '$baseUrl/user/redeemed/products';
  static const String admingetRedeemedHistory = '$baseUrl/redeem/history';
  static const String admingetRedeemedRequestes = '$baseUrl/redeem/requests';
   static const String markAsShipped = '$baseUrl/product';
    static const String getPointRequestes = '$baseUrl/admin/complaints';
     static const String acceptRequest = '$baseUrl/admin/complaints';
      static const String repportUser = '$baseUrl/complaint';
      static const String getAllUser = '$baseUrl/admin/users/all';
      static const String getSuspendedUser = '$baseUrl/admin/users/suspended';
      static const String suspendAndActivate = '$baseUrl/toggle-status';
       static const String changePassword = '$baseUrl/change-password';
        static const String progressAndCount = '$baseUrl/counts';
        static const String getBanner = '$baseUrl/get/banners';
         static const String addBanner = '$baseUrl/create/banner';
       static const String deleteBanner = '$baseUrl/delete/banner';
         static const String editBanner = '$baseUrl/edit/banner';
          static const String sendotp = '$baseUrl/send-otp';
          static const String gettotalPoints = '$baseUrl/points';
           static const String getNotifications = '$baseUrl/notifications';

  static const String forgotPassword = '$baseUrl/reset-password';
  static const String verifyOtp = '$baseUrl/verify-otp';
  // static const String changePassword = '$baseUrl/change-password';
}
