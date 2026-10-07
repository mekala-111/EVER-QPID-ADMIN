// import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
// import 'package:flutter/material.dart';

// import '../model/revenue_details_model.dart';
// import '../repository/revenue_repository.dart';

// class RevenueDetailProvider extends ChangeNotifier {
//   final _repo = RevenueRepository(NetworkApiServiceV2());

//   RevenueDetailsModel? _revenue;
//   bool _isLoading = false;
//   String? _error;

//   // Getters
//   RevenueDetailsModel? get revenue => _revenue;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get hasData => _revenue != null;
//   bool get hasError => _error != null;

//   // Fetch revenue details
//   // In revenue_provider.dart (RevenueDetailProvider)
// // Future<void> fetchRevenueDetails({DateTime? from, DateTime? to}) async {
// //   try {
// //     _isLoading = true;
// //     _error = null;
// //     notifyListeners();

// //     final fetchedRevenue = await _repo.getRevenueDetails(
// //       fromDate: from?.toIso8601String(),
// //       toDate: to?.toIso8601String(),
// //     );

// //     _revenue = fetchedRevenue;
// //   } catch (e) {
// //     _error = e.toString();
// //   } finally {
// //     _isLoading = false;
// //     notifyListeners();
// //   }
// // }

//   // Refresh revenue data
//   // Future<void> refreshRevenue() async {
//   //   await fetchRevenueDetails();
//   // }

//   // Clear revenue data
//   void clearRevenue() {
//     _revenue = null;
//     _error = null;
//     notifyListeners();
//   }

//   // Update revenue locally (optional - for optimistic updates)
//   void updateRevenue(RevenueDetailsModel newRevenue) {
//     _revenue = newRevenue;
//     notifyListeners();
//   }

//   // Clear error
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }

//   // Retry after error
//   Future<void> retry() async {
//     if (hasError) {
//       await fetchRevenueDetails();
//     }
//   }

//   @override
//   void dispose() {
//     // Clean up if needed
//     super.dispose();
//   }
// }
