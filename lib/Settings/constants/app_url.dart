class AppUrl {
  static const bool isProduction =
      bool.fromEnvironment('PRODUCTION', defaultValue: true);
  static const String baseurl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://server.everqpid.com/',
  );

  static String get scurity => Uri.parse(baseurl).scheme;
  static String get httpBaseUrl => Uri.parse(baseurl).authority;

// API Routes
  static const String auth = 'api/v1/auth/user-auth';
  static const String refreshToken = 'api/v1/auth/refresh-tokens';
  static const String checkUserExist = 'api/v1/auth/check-user-exists';
  static const String userLogout = 'api/v1/auth/log-out';
  static const String getProfile = 'api/v1/profile/get-profile';

//login and forgot password
  static const String login = 'api/v1/admin/login';
  static const String forgot = 'api/v1/admin/forgot-password';
  static const String reset = 'api/v1/admin/set-new-password';
  static const String verifyOtp = 'api/v1/admin/verify-otp';
  //user management
  static const String getAllUsers = 'api/v1/profile/admin/get-all-profiles';
  static const String getUserDetails =
      'api/v1/profile/admin/get-profiles-details';
  static const String getUserPhotos = 'api/v1/profile/admin/photos';
  static const String deleteUserPhoto = 'api/v1/profile/admin/photos';
  static const String deleteAllphoto = 'api/v1/profile/admin/photos/all';

  static const String getUsermatches = 'api/v1/profile/admin/matches';
  static const String getChatlog = 'api/v1/profile/admin/chat-logs';

  static const String getReportedUSers = 'api/v1/report/reports';
  static const String getReporteduserdetails = 'api/v1/report/reports';

  static const String getSupport = 'api/v1/tickets/tickets-details';
  static const String getTransaction =
      'api/v1/subscription-purchase/transaction-details';

  //Host Management
  static const String getHsot = 'api/v1/host/admin-host';
  static const String getHsotdetails = 'api/v1/host/admin-host';
  static const String getHsotMatches = 'api/v1/host/admin-host';
  static const String adminHost = 'api/v1/host/admin-host';
  static const String getsignedUrl = 'api/v1/signed-url/get-signed-url';

//Revanue
  static const String getrevanueChart =
      'api/v1/revenue/transactions-status-chart';
  static const String exportTransaction =
      'api/admin/all-transactions/export-csv';
  static const String getAlltansactions = 'api/v1/revenue/get-all-transactions';
  static const String transactionDetails = 'api/v1/revenue/transaction';

  //plan Management

  static const String getAllSub =
      'api/v1/subscription-plans/get-all-subscriptions';
  static const String createSub = 'api/v1/subscription-plans/add-subscription';
  static const String updateSub =
      'api/v1/subscription-plans/update-subscription';
  static const String deleteSub =
      'api/v1/subscription-plans/delete-subscription';

  static const String getAllTickets = 'api/v1/tickets/all-tickets';
  static const String getAllEmployees = 'api/v1/employee/get-all-employees';
  static const String getticketDetails = 'api/v1/tickets';

//help
  static const String getEmail = 'api/v1/email/get-email';
  static const String updateEmail = 'api/v1/email/update-email';
  static const String createNotification =
      'api/v1/notification/create-push-notification';
  static const String updateNotification =
      'api/v1/notification/update-push-notification';
  static const String deleteNotification =
      'api/v1/notification/delete-push-notification';
  static const String toggleNotification =
      'api/v1/notification/pause-notification';
  static const String allNotification =
      'api/v1/notification/get-push-notifications';

//Clan Management
  static const String getclanUsers = 'api/v1/clan/fetch-clan-users';

//Employee management
  static const String getEmployee = 'api/v1/employee/get-all-employees';
  static const String deleteEmployee = 'api/v1/employee/delete-employee';
  static const String editEmployee = 'api/v1/employee/edit-employee';
  static const String addEmployee = 'api/v1/employee/create-employee';

//Chat Management
  static const String recentChat = 'api/v1/chat-Message/recent-chats-admin';
  static const String chatHistoryByAdmin =
      'api/v1/chat-Message/chat-history-byAdmin';

//Dashboard

  static const String userGenderChart = 'api/v1/dashboard/user-gender-chart';
  static const String mostActiveClansChart =
      'api/v1/dashboard/most-active-clans-chart';
}
