import 'dart:convert';
import 'dart:typed_data';

import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Features/dashboard/model/clanstatusmodel.dart';
import 'package:everqpidadmin/Features/dashboard/model/overviewmodel.dart';
import 'package:everqpidadmin/Features/dashboard/model/userschartmodel.dart';
import 'package:everqpidadmin/Features/dashboard/repo/repo.dart';
import 'package:everqpidadmin/Settings/utils/file_download.dart';
import 'package:flutter/material.dart';

class DashboardViewmodel extends ChangeNotifier {
  final repo = DashboardRepo(NetworkApiServiceV2());

  GenderChartModel? genderChart;
  bool genderChartLoading = false;
  String? genderChartError;
  Future<void> fetchUserGenderChart() async {
    try {
      genderChartLoading = true;
      genderChartError = null;
      notifyListeners();

      genderChart = await repo.getUserGenderChart();
    } catch (e) {
      genderChartError = e.toString();
      genderChart = null;
    } finally {
      genderChartLoading = false;
      notifyListeners();
    }
  }

  bool isLoadingClans = false;
  String? clanError;

  List<MostActiveClan> mostActiveClans = [];

  /// -------- Fetch Most Active Clans --------
  Future<void> fetchMostActiveClans() async {
    try {
      isLoadingClans = true;
      clanError = null;
      notifyListeners();

      mostActiveClans = await repo.getMostActiveClans();
    } catch (e) {
      clanError = e.toString();
      mostActiveClans = [];
    } finally {
      isLoadingClans = false;
      notifyListeners();
    }
  }

  bool csvLoading = false;
  String? csvError;
  String? csvFilePath;
  String convertJsonToCsv(List<dynamic> data) {
    if (data.isEmpty) return '';

    final headers = data.first.keys.toList();

    final csvBuffer = StringBuffer();
    csvBuffer.writeln(headers.join(','));

    for (final row in data) {
      csvBuffer.writeln(
        headers.map((h) => row[h]?.toString() ?? '').join(','),
      );
    }

    return csvBuffer.toString();
  }

  /// -------- Download CSV --------
  Future<void> downloadDashboardCsvWeb() async {
    try {
      csvLoading = true;
      csvError = null;
      notifyListeners();

      // API call
      final jsonData = await repo.downloadDashboardCsv();

      // Convert JSON → CSV
      final csvData = convertJsonToCsv(jsonData);

      downloadBytes(
        Uint8List.fromList(utf8.encode(csvData)),
        fileName: 'dashboard_report.csv',
        mimeType: 'text/csv',
      );
    } catch (e) {
      csvError = e.toString();
    } finally {
      csvLoading = false;
      notifyListeners();
    }
  }

  DashboardSummaryModel? dashboardSummary;
  bool summaryLoading = false;
  String? summaryError;
  Future<void> fetchDashboardSummary() async {
    try {
      summaryLoading = true;
      summaryError = null;
      notifyListeners();

      dashboardSummary = await repo.getDashboardSummary();
    } catch (e) {
      summaryError = e.toString();
      dashboardSummary = null;
    } finally {
      summaryLoading = false;
      notifyListeners();
    }
  }
}
