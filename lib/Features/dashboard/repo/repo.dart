import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Features/dashboard/model/clanstatusmodel.dart';
import 'package:everqpidadmin/Features/dashboard/model/overviewmodel.dart';
import 'package:everqpidadmin/Features/dashboard/model/userschartmodel.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';

class DashboardRepo {
  final BaseApiService apiService;
  DashboardRepo(this.apiService);

  Future<GenderChartModel> getUserGenderChart() async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.userGenderChart, // api/v1/dashboard/user-gender-chart
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null response from API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Failed to fetch gender chart";
      }

      return GenderChartModel.fromJson(result['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MostActiveClan>> getMostActiveClans() async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.mostActiveClansChart,
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null response from API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Failed to fetch active clans";
      }

      final List list = result['data'] ?? [];
      return list.map((e) => MostActiveClan.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> downloadDashboardCsv() async {
    try {
      final result = await apiService.getGetApiResponse(
        'api/v1/dashboard/dashboard-csv-data',
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null response from API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Failed to download CSV";
      }

      return List<dynamic>.from(result['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashboardSummaryModel> getDashboardSummary() async {
    try {
      final result = await apiService.getGetApiResponse(
        'api/v1/dashboard/dashboard-overall-summary',
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null response from API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Failed to fetch dashboard summary";
      }

      return DashboardSummaryModel.fromJson(result['data']);
    } catch (e) {
      rethrow;
    }
  }
}
