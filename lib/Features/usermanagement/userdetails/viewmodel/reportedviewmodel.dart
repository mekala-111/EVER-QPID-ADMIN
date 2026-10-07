import 'package:flutter/material.dart';
import 'package:everqpidadmin/Features/usermanagement/model/reporteduserdetailsmodel.dart'
    show ReportedUserDetailsResponse, User, Report, SideProfileDetails;
import 'package:everqpidadmin/Features/usermanagement/repo/repo.dart';
import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import '../../../../../Settings/common/widgets/error_msg.dart';

class ReportedViewModel extends ChangeNotifier {
  // -------------------- REPO --------------------
  final UserManagementRepository repo =
      UserManagementRepository(NetworkApiServiceV2());

  // -------------------- STATE --------------------
  bool reportedUserLoading = false;
  String? reportedUserError;

  ReportedUserDetailsResponse? reportedUserDetails;
  User? reportedUser;
  List<Report> reports = [];
  SideProfileDetails? reportedSideProfile;

  // -------------------- API CALL --------------------
  Future<void> getReportedUserDetailsFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      reportedUserLoading = true;
      reportedUserError = null;
      notifyListeners();

      final result = await repo.getReportedUserDetails(userId: userId);

      if (result['status'] == true &&
          result['statusCode'] == 200 &&
          result['data'] != null) {
        // The data structure now matches the model perfectly
        reportedUserDetails =
            ReportedUserDetailsResponse.fromJson(result['data']);

        reportedUser = reportedUserDetails!.user;
        reports = reportedUserDetails!.reports;
        reportedSideProfile = reportedUserDetails!.sideProfileDetails;

        reportedUserError = null;
      } else {
        _clearReportedUserState();
        reportedUserError =
            result['message'] ?? 'Failed to load reported user details';
      }
    } catch (e) {
      _clearReportedUserState();
      reportedUserError = e.toString();
    } finally {
      reportedUserLoading = false;

      if (context.mounted) {
        notifyListeners();

        if (reportedUserError != null) {
          ErrorMsg.showSnakError(context, reportedUserError!);
        }
      }
    }
  }

  // -------------------- CLEAR --------------------
  void clearReportedUserDetails() {
    _clearReportedUserState();
    notifyListeners();
  }

  void _clearReportedUserState() {
    reportedUserDetails = null;
    reportedUser = null;
    reports = [];
    reportedSideProfile = null;
    reportedUserError = null;
  }
}
