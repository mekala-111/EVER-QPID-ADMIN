import 'package:everqpidadmin/Features/revanuemanagement/transactions/model/tarnsactiondetailsmodel.dart';
import 'package:flutter/material.dart';
import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import '../repository/transaction_repository.dart';

class TransactionDetailsProvider extends ChangeNotifier {
  final _repo = TransactionRepository(NetworkApiServiceV2());

  TransactionResponse? _details;
  bool _isLoading = false;
  String? _error;

  // =========================
  // Getters
  // =========================
  TransactionResponse? get details => _details;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get hasData => _details != null;

  // =========================
  // Fetch Transaction Details
  // =========================
  Future<void> fetchTransactionDetails(String transactionId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _repo.getTransactionDetails(
        transactionId: transactionId,
      );

      // 🔥 Use your existing model
      _details = TransactionResponse.fromJson(result['data']);
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
  void clear() {
    _details = null;
    _error = null;
    notifyListeners();
  }

  Future<void> retry(String transactionId) async {
    if (hasError) {
      await fetchTransactionDetails(transactionId);
    }
  }
}
