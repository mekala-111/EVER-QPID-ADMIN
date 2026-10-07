import 'package:flutter/material.dart';
import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';

import '../model/transaction_list_model.dart';
import '../repository/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final _repo = TransactionRepository(NetworkApiServiceV2());

  TransactionListModel? _transactionList;
  bool _isLoading = false;
  String? _error;

  // Filters
  String _searchQuery = '';
  String? _selectedStatus;
  DateTime? _fromDate;
  DateTime? _toDate;

  int _rowsPerPage = 10;

  // =========================
  // Setters (Filters)
  // =========================
  void setSearchQuery(String value) {
    _searchQuery = value;
  }

  void setStatus(String? status) {
    _selectedStatus = status;
  }

  void setFromDate(DateTime? date) {
    _fromDate = date;
  }

  void setToDate(DateTime? date) {
    _toDate = date;
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedStatus = null;
    _fromDate = null;
    _toDate = null;
    fetchTransactions(page: 1);
  }

  // =========================
  // Getters
  // =========================
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  List<TransactionItem> get transactions =>
      _transactionList?.data.transactions ?? [];

  bool get hasData => transactions.isNotEmpty;

  int get rowsPerPage => _rowsPerPage;

  int get currentPage => _transactionList?.data.pagination.page ?? 1;

  int get totalPages => _transactionList?.data.pagination.totalPages ?? 1;

  int get totalTransactions =>
      _transactionList?.data.pagination.totalRecords ?? 0;

  bool get canGoBack => currentPage > 1;
  bool get canGoForward => currentPage < totalPages;

  // Pagination label
  String get paginationInfo {
    if (transactions.isEmpty) return '0–0 of 0';
    final start = ((currentPage - 1) * _rowsPerPage) + 1;
    final end = (start + transactions.length - 1).clamp(0, totalTransactions);
    return '$start–$end of $totalTransactions';
  }

  // =========================
  // Fetch Transactions
  // =========================
  Future<void> fetchTransactions({int page = 1}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _repo.getAllTransactions(
        page: page,
        limit: _rowsPerPage,
        search: _searchQuery,
        status: _selectedStatus,
        fromDate: _fromDate,
        toDate: _toDate,
      );

      _transactionList = TransactionListModel.fromJson(result);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Summary? get summary => _transactionList?.data.summary;

  int get totalRevenue => summary?.totalRevenue.totalRevenue ?? 0;

  int get totalUsers => summary?.totalRevenue.totalUsers ?? 0;

  int get averageRevenuePerUser =>
      summary?.totalRevenue.averageRevenuePerUser ?? 0;

  int get activePlansRevenue => summary?.activePlansTotalAmount ?? 0;
  String formatCurrency(int value) {
    return '₹${value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        )}';
  }

  // =========================
  // Pagination Controls
  // =========================
  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      fetchTransactions(page: page);
    }
  }

  void nextPage() {
    if (canGoForward) {
      fetchTransactions(page: currentPage + 1);
    }
  }

  void previousPage() {
    if (canGoBack) {
      fetchTransactions(page: currentPage - 1);
    }
  }

  void setRowsPerPage(int rows) {
    _rowsPerPage = rows;
    fetchTransactions(page: 1);
  }

  Future<void> refreshTransactions() async {
    await fetchTransactions(page: 1);
  }

  // =========================
  // Helpers
  // =========================
  String formatAmount(int amount) {
    return '₹${amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        )}';
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void clearTransactions() {
    _transactionList = null;
    _error = null;
    notifyListeners();
  }

  Future<void> retry() async {
    if (hasError) {
      await fetchTransactions(page: currentPage);
    }
  }

  bool _isExporting = false;
  String? _exportError;

  bool get isExporting => _isExporting;
  String? get exportError => _exportError;
  Future<void> exportTransactionsCsv() async {
    try {
      _isExporting = true;
      _exportError = null;
      notifyListeners();

      // Call repository export
      await _repo.exportTransactionCsvWeb();
    } catch (e) {
      _exportError = e.toString();
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }
}
