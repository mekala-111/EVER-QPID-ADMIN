import 'package:everqpidadmin/Features/Ticketmanagement/viewmodel/ticketdetailsviewmodel.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/auth/view_model/login_view_model.dart';
import 'package:everqpidadmin/Features/chatmangaement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/clanmanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/dashboard/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/employeemanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/helpsupport/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/hostmanagement/viewmodel/hostdetailsviewmodel.dart';
import 'package:everqpidadmin/Features/hostmanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/notification_management/add_notification/view_model/notification_provider.dart';
import 'package:everqpidadmin/Features/notification_management/notification/view_model/notification_provider.dart';
import 'package:everqpidadmin/Features/plan_management/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/revanuemanagement/revenue/view_model/revenue_chart_provider.dart';
import 'package:everqpidadmin/Features/revanuemanagement/transactions/view_model/transaction_provider.dart';
import 'package:everqpidadmin/Features/revanuemanagement/transactions/view_model/transactiondetails_provider.dart';
import 'package:everqpidadmin/Features/usermanagement/userdetails/viewmodel/reportedviewmodel.dart';
import 'package:everqpidadmin/Features/usermanagement/userdetails/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/usermanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/viewmodelnew.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/employeelogin/likemanagement/viewmodel/viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
  // ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
  ChangeNotifierProvider<WrapperViewModel>(
      create: (context) => WrapperViewModel()),
  ChangeNotifierProvider<WrapperViewModelNew>(
      create: (context) => WrapperViewModelNew()),
  ChangeNotifierProvider<UsersViewModel>(create: (_) => UsersViewModel()),
  ChangeNotifierProvider<UserDetailsViewModel>(
      create: (_) => UserDetailsViewModel()),
  ChangeNotifierProvider<ReportedViewModel>(create: (_) => ReportedViewModel()),

  ChangeNotifierProvider<HostmanagementViewmodel>(
      create: (_) => HostmanagementViewmodel()),
  ChangeNotifierProvider<Hostdetailsviewmodel>(
      create: (_) => Hostdetailsviewmodel()),
  ChangeNotifierProvider<TransactionProvider>(
      create: (_) => TransactionProvider()),
  ChangeNotifierProvider<RevenueChartProvider>(
      create: (_) => RevenueChartProvider()),
  ChangeNotifierProvider<SubscriptionViewmodel>(
      create: (_) => SubscriptionViewmodel()),
  ChangeNotifierProvider<TicketsViewModel>(create: (_) => TicketsViewModel()),
  ChangeNotifierProvider<TicketDetailsViewModel>(
      create: (_) => TicketDetailsViewModel()),
  ChangeNotifierProvider<HelpViewModel>(create: (_) => HelpViewModel()),
  ChangeNotifierProvider<NotificationProvider>(
      create: (_) => NotificationProvider()),
  ChangeNotifierProvider<AddNotificationProvider>(
      create: (_) => AddNotificationProvider()),
  ChangeNotifierProvider<ClanManagementViewModel>(
      create: (_) => ClanManagementViewModel()),
  ChangeNotifierProvider<EmployeeViewModel>(create: (_) => EmployeeViewModel()),

  ChangeNotifierProvider<ChatManagementViewModel>(
      create: (_) => ChatManagementViewModel()),
  ChangeNotifierProvider<DashboardViewmodel>(
      create: (_) => DashboardViewmodel()),
  ChangeNotifierProvider<TransactionDetailsProvider>(
      create: (_) => TransactionDetailsProvider()),
  ChangeNotifierProvider<EmployeeChatManagementViewModel>(
      create: (_) => EmployeeChatManagementViewModel()),
  ChangeNotifierProvider<LikeManagementViewmodel>(
      create: (_) => LikeManagementViewmodel()),
];
