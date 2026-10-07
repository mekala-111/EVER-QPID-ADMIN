import 'dart:convert';
import 'dart:typed_data';

import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';
import 'package:everqpidadmin/Settings/utils/file_download.dart';
import 'package:intl/intl.dart';

class TransactionRepository {
  final BaseApiService apiService;
  TransactionRepository(this.apiService);

  /// =========================
  /// Export Transactions (CSV)
  /// =========================

  /// =========================
  /// Get All Transactions (RAW)
  /// =========================
  Future<Map<String, dynamic>> getAllTransactions({
    required int page,
    required int limit,
    String? search,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getAlltansactions,
        token: LoggedInUser.accessToken,
        queryParameters: {
          "page": page.toString(),
          "limit": limit.toString(),
          if (search != null && search.isNotEmpty) "search": search,
          if (status != null && status.isNotEmpty && status != "All")
            "status": status,
          if (fromDate != null) "fromDate": _formatDate(fromDate),
          if (toDate != null) "toDate": _formatDate(toDate),
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

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // =========================
// Get Transaction Details
// =========================
  Future<Map<String, dynamic>> getTransactionDetails({
    required String transactionId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        '${AppUrl.transactionDetails}/$transactionId',
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw 'No response from server';
      }

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> exportTransaction() async {
    try {
      String endpoint = 'api/v1/revenue/export-transactions';

      // Add status filter if not 'all'

      final result = await apiService.getGetApiResponse(
        endpoint,
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null response from API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Failed to export transactions";
      }

      return List<dynamic>.from(result['data']);
    } catch (e) {
      rethrow;
    }
  }

  String convertTransactionsToCsv(List<dynamic> transactions) {
    if (transactions.isEmpty) return '';

    // CSV Headers
    final headers = [
      'Transaction ID',
      'User Name',
      'User Email',
      'Plan Name',
      'Amount',
      'Currency',
      'Status',
      'Date'
    ];

    // Build CSV
    final csvRows = <String>[];
    csvRows.add(headers.join(','));

    for (var transaction in transactions) {
      final row = [
        _escapeCsvField(transaction['transactionId'] ?? ''),
        _escapeCsvField(transaction['userName'] ?? ''),
        _escapeCsvField(transaction['userEmail'] ?? ''),
        _escapeCsvField(transaction['planName'] ?? ''),
        transaction['amount']?.toString() ?? '0',
        transaction['currency'] ?? 'INR',
        transaction['status'] ?? '',
        _formatDateForCsv(transaction['createdAt']),
      ];
      csvRows.add(row.join(','));
    }

    return csvRows.join('\n');
  }

  String _formatDateForCsv(dynamic dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString.toString());
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString.toString();
    }
  }

  String _escapeCsvField(String field) {
    // Escape fields containing commas, quotes, or newlines
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  // String _formatDate(dynamic dateString) {
  //   if (dateString == null) return '';
  //   try {
  //     final date = DateTime.parse(dateString);
  //     return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  //   } catch (e) {
  //     return dateString.toString();
  //   }
  // }

  Future<void> exportTransactionCsvWeb() async {
    try {
      // Fetch transaction data
      final jsonData = await exportTransaction();

      if (jsonData.isEmpty) {
        throw "No transactions found to export";
      }

      // Convert JSON → CSV
      final csvData = convertTransactionsToCsv(jsonData);

      final now = DateTime.now();
      final timestamp =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
      final filename = 'transactions__$timestamp.csv';

      downloadBytes(
        Uint8List.fromList(utf8.encode(csvData)),
        fileName: filename,
        mimeType: 'text/csv',
      );
    } catch (e) {
      rethrow;
    }
  }
}
