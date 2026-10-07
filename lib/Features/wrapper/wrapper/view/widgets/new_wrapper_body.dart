import 'package:everqpidadmin/Features/Ticketmanagement/view/ticketdetails/ui.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/view/ui.dart';
import 'package:everqpidadmin/Features/chatmangaement/view/ui.dart';
import 'package:everqpidadmin/Features/clanmanagement/view/ui.dart';
import 'package:everqpidadmin/Features/dashboard/view/ui.dart';
import 'package:everqpidadmin/Features/employeemanagement/view/ui.dart';
import 'package:everqpidadmin/Features/helpsupport/view/ui.dart';
import 'package:everqpidadmin/Features/hostmanagement/view/activehost/ui.dart';
import 'package:everqpidadmin/Features/hostmanagement/view/addhost/view/ui.dart';
import 'package:everqpidadmin/Features/hostmanagement/view/allhost/ui.dart';
import 'package:everqpidadmin/Features/hostmanagement/view/hostdetails/view/ui.dart';
import 'package:everqpidadmin/Features/hostmanagement/view/inactivehost/ui.dart';
import 'package:everqpidadmin/Features/notification_management/add_notification/view/ui.dart';
import 'package:everqpidadmin/Features/notification_management/notification/view/ui.dart';
import 'package:everqpidadmin/Features/plan_management/view/subscription_plan.dart';
import 'package:everqpidadmin/Features/plan_management/view/widgets/addplan/addplan.dart';
import 'package:everqpidadmin/Features/revanuemanagement/revenue/view/ui.dart';
import 'package:everqpidadmin/Features/revanuemanagement/transactions/view/transactiondetails/ui.dart';
import 'package:everqpidadmin/Features/revanuemanagement/transactions/view/ui.dart';
import 'package:everqpidadmin/Features/usermanagement/userdetails/view/userdetails.dart';
import 'package:everqpidadmin/Features/usermanagement/view/allusers/ui.dart';
import 'package:everqpidadmin/Features/usermanagement/view/femaleusers/ui.dart';
import 'package:everqpidadmin/Features/usermanagement/view/maleusers/ui.dart';
import 'package:everqpidadmin/Features/usermanagement/view/reportedusers/ui.dart';
import 'package:everqpidadmin/Features/usermanagement/view/reportedusers/widgets/userdetails.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/view/ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WrapperBodySection extends StatelessWidget {
  const WrapperBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return main(context);
  }

  Widget main(BuildContext context) {
    return Selector<WrapperViewModel, String>(
      selector: (p0, p1) => p1.viewStatus,
      builder: (context, value, child) {
        switch (value) {
          case GetWrapperPageViewStatus.dashboard:
            return Dashboard();
          case GetWrapperPageViewStatus.users:
            return UserManagementScreen();
          case GetWrapperPageViewStatus.maleusers:
            return MaleusersScreen();
          case GetWrapperPageViewStatus.femaleusers:
            return FemaleusersScreen();
          case GetWrapperPageViewStatus.reported:
            return ReportedUsersScreen();
          case GetWrapperPageViewStatus.userDetails:
            return UserDetailsScreen();
          case GetWrapperPageViewStatus.reporteduserDetails:
            return ReportedUserDetailsScreen();
          case GetWrapperPageViewStatus.allhost:
            return AllHostsScreen();
          case GetWrapperPageViewStatus.activehost:
            return ActiveHostsScreen();
          case GetWrapperPageViewStatus.inactivehost:
            return InactiveHostsScreen();
          case GetWrapperPageViewStatus.hostDetails:
            return HostDetailsScreen();
          case GetWrapperPageViewStatus.addHost:
            return CreatehostUi();
          case GetWrapperPageViewStatus.transaction:
            return TransactionUi();
          case GetWrapperPageViewStatus.revenue:
            return RevenueUi();
          case GetWrapperPageViewStatus.plans:
            return SubscriptionPlan();
          case GetWrapperPageViewStatus.addPlan:
            return AddPlanPage();
          case GetWrapperPageViewStatus.tickets:
            return AllTicketsScreen();
          case GetWrapperPageViewStatus.ticketDetails:
            return Ticketdetails();
          case GetWrapperPageViewStatus.email:
            return HelpUi();
          case GetWrapperPageViewStatus.notification:
            return NotificationUi();
          case GetWrapperPageViewStatus.addnotification:
            return AddNotificationUi();

          case GetWrapperPageViewStatus.chat:
            return ChatManagementPage();
          case GetWrapperPageViewStatus.clan:
            return ClanManagementScreen();
          case GetWrapperPageViewStatus.employees:
            return EmployeeManagementScreen();
          case GetWrapperPageViewStatus.transactionDeatils:
            return TransactiondetailsUi();

          case GetWrapperPageViewStatus.employeechat:
            return EmployeeChatManagementPage();

          //   return const UserManagementScreen();
          // case GetWrapperPageViewStatus.userDetails:
          //   return UserDetailsScreen();

          // case GetWrapperPageViewStatus.partners:
          //   return const PartnerManagementScreen();
          // case GetWrapperPageViewStatus.partnerdetails:
          //   return const PartnerDetailsScreen();
          // case GetWrapperPageViewStatus.suspiciousAccount:
          //   return const AccountsScreen();
          // case GetWrapperPageViewStatus.suspiciousAccountsdetails:
          //   return const AccountsDetailsScreen();
          // case GetWrapperPageViewStatus.allbooking:
          //   return const AllBookings();
          // case GetWrapperPageViewStatus.bookingdetails:
          //   return const BookingDetailsScreen();
          // case GetWrapperPageViewStatus.ticket:
          //   return const TicketManagementScreen();
          // case GetWrapperPageViewStatus.ticketsDetails:
          //   return const TicketDetailsPage();
          // case GetWrapperPageViewStatus.call:
          //   return const CallManagementScreen();

          // case GetWrapperPageViewStatus.banners:
          //   return const BannersPage();
          //    case GetWrapperPageViewStatus.expertTalks:
          //   return const ExpertTalksPage();
          // case GetWrapperPageViewStatus.category:
          //   return const CategoryScreen();
          // case GetWrapperPageViewStatus.categorydetails:
          //   return const CategoryDetailsScreen();
          // case GetWrapperPageViewStatus.addcategory:
          //   return const AddCategoryPage();

          //    case GetWrapperPageViewStatus.subcategory:
          //   return const SubCategoryScreen();
          // case GetWrapperPageViewStatus.subcategorydetails:
          //   return const SubCategoryDetailsScreen();
          // case GetWrapperPageViewStatus.addsubcategory:
          //   return const AddSubCategoryPage();

          //       case GetWrapperPageViewStatus.editcategory:
          //   return const EditCategoryPage();
          //   case GetWrapperPageViewStatus.editsubcategory:
          //   return const EditSubCategoryPage();

          // case GetWrapperPageViewStatus.plans:
          //   return const PlansUi();
          // case GetWrapperPageViewStatus.editPlan:
          //   return const EditPlansUi();
          // case GetWrapperPageViewStatus.addPlan:
          //   return const EditPlansUi();
          // case GetWrapperPageViewStatus.callLogs:
          //   return const CallLogsUi();
          // case GetWrapperPageViewStatus.callDetails:
          //   return CallDetailsPage();
          // case GetWrapperPageViewStatus.profileImage:
          //   return const ProfileImages();
          // case GetWrapperPageViewStatus.adduserProfile:
          //   return const EditProfileImg();

          // case GetWrapperPageViewStatus.edituserProfile:
          //   return const EditProfileImg();

          // case GetWrapperPageViewStatus.analytics:
          //   return const AnalyticsDashboard(); //AnalyticsDashboard

          // case GetWrapperPageViewStatus.tickets:
          //   return const TicketsUI();

          // case GetWrapperPageViewStatus.ticketsDetails:
          //   return const TicketDetailsScreen();

          // case GetWrapperPageViewStatus.notification:
          //   return const NotificationUi();
          // case GetWrapperPageViewStatus.addNotification:
          //   return const NotificationScreen();
          // case GetWrapperPageViewStatus.editNotification:
          //   return const UpdateNotificationScreen();

          // case GetWrapperPageViewStatus.employees:
          //   return const EmployeeManagementScreen();

          // case GetWrapperPageViewStatus.skills:
          //   return SkillManagementScreen();
          // case GetWrapperPageViewStatus.userCoinSettings:
          //   return UserCoinSettingsUI();
          // case GetWrapperPageViewStatus.withdraw:
          //   return WithdrawSettingsUi();
          // case GetWrapperPageViewStatus.requestDeatils:
          //   return RequestDeatilsUi();
          // case GetWrapperPageViewStatus.banners:
          //   return Banners();
          // case GetWrapperPageViewStatus.addBanner ||
          //       GetWrapperPageViewStatus.editBanner:
          //   return AddOrEditBannerScreen();
          // case GetWrapperPageViewStatus.gifts:
          //   return GiftsScreen();
          // case GetWrapperPageViewStatus.addGift ||
          //       GetWrapperPageViewStatus.editGift:
          //   return AddOrEditGift();
          default:
            return Container();
        }
      },
    );
  }
}
