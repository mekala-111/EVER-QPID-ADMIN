import 'package:everqpidadmin/Features/revanuemanagement/revenue/model/summarymodel.dart';
import 'package:flutter/material.dart';
import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';

import '../model/revenue_chart_model.dart';
import '../repository/revenue_repository.dart';

class RevenueChartProvider extends ChangeNotifier {
  final RevenueRepository _repo = RevenueRepository(NetworkApiServiceV2());

  RevenueChartModel? _revenueChart;
  RevenueSummary? _revenueSummary;

  bool _isLoading = false;
  String? _error;

  DateTime? _fromDate;
  DateTime? _toDate;

  // =========================
  // Getters
  // =========================
  RevenueChartModel? get revenueChart => _revenueChart;
  RevenueSummary? get revenueSummary => _revenueSummary;

  List<TransactionChartData> get chartPoints => _revenueChart?.data ?? [];

  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get hasData => chartPoints.isNotEmpty;
  bool get hasError => _error != null;

  // =========================
  // Aggregates
  // =========================
  int get totalSuccess => chartPoints.fold(0, (sum, e) => sum + e.success);

  int get totalFailed => chartPoints.fold(0, (sum, e) => sum + e.failed);

  int get totalPending => chartPoints.fold(0, (sum, e) => sum + e.pending);

  // =========================
  // Fetch Revenue Chart
  // =========================
  Future<void> fetchRevenueChart({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _repo.getRevenueChart(
        fromDate: from?.toIso8601String(),
        toDate: to?.toIso8601String(),
      );

      _revenueChart = RevenueChartModel.fromJson(response);
      _fromDate = from;
      _toDate = to;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // Fetch Revenue Summary
  // =========================
  Future<void> fetchRevenueSummary() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _repo.getRevenueSummary();

      // ✅ FIX HERE
      _revenueSummary = RevenueSummary.fromJson(response);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // Helpers
  // =========================
  void clearAll() {
    _revenueChart = null;
    _revenueSummary = null;
    _error = null;
    notifyListeners();
  }

  Future<void> retry() async {
    if (_error != null) {
      await fetchRevenueChart(from: _fromDate, to: _toDate);
      await fetchRevenueSummary();
    }
  }
}
