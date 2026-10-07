import 'dart:convert';
import 'dart:typed_data';

import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';
import 'package:everqpidadmin/Settings/utils/file_download.dart';

class RevenueRepository {
  final BaseApiService apiService;
  RevenueRepository(this.apiService);

  /// =========================
  /// Export Revenue (CSV)
  /// =========================
  Future<bool> exportRevenue({String status = 'all'}) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.exportTransaction,
        token: LoggedInUser.accessToken,
        queryParameters: {"status": status},
      );

      if (result == null) return false;

      final csvContent = result is String ? result : result.toString();

      final filename =
          'revenue_${status}_${DateTime.now().millisecondsSinceEpoch}.csv';
      downloadBytes(
        Uint8List.fromList(utf8.encode(csvContent)),
        fileName: filename,
        mimeType: 'text/csv;charset=utf-8',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// =========================
  /// Get Revenue Chart (RAW)
  /// =========================
  Future<Map<String, dynamic>> getRevenueChart({
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getrevanueChart,
        token: LoggedInUser.accessToken,
        queryParameters: {
          if (fromDate != null) "fromDate": fromDate,
          if (toDate != null) "toDate": toDate,
        },
      );

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // Get Revenue Summary
  // =========================
  Future<Map<String, dynamic>> getRevenueSummary() async {
    try {
      final result = await apiService.getGetApiResponse(
        'api/v1/revenue/revenue-summary',
        token: LoggedInUser.accessToken,
      );

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
