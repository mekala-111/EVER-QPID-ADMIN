import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/viewmodelnew.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/view/ui.dart';
import 'package:everqpidadmin/employeelogin/likemanagement/view/ui.dart';
import 'package:everqpidadmin/employeelogin/userdetails.dart/view/ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Employeewrapperbody extends StatelessWidget {
  const Employeewrapperbody({super.key});

  @override
  Widget build(BuildContext context) {
    return main(context);
  }

  Widget main(BuildContext context) {
    return Selector<WrapperViewModelNew, String>(
      selector: (p0, p1) => p1.viewStatus,
      builder: (context, value, child) {
        switch (value) {
          case GetWrapperPageViewStatus.employeechat:
            return EmployeeChatManagementPage();
          case GetWrapperPageViewStatus.employyedetails:
            return UserDetailsPanel();
          case GetWrapperPageViewStatus.recievedLikes:
            return const RecievedLikes();

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
