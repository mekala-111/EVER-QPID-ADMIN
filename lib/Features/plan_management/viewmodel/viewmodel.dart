import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Features/plan_management/model/subscriptionmodel.dart';
import 'package:everqpidadmin/Features/plan_management/repo/subscriptionrepo.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SubscriptionViewmodel extends ChangeNotifier {
  void refresh() => notifyListeners();

  final repo = Subscriptionrepo(NetworkApiServiceV2());

  List<SubscriptionModel> subscriptions = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  final int _currentPage = 1;
  int pageSize = 10;
  int totalCount = 0;
  int totalPages = 0;

  // Selected plan for editing
  SubscriptionModel? _selectedPlan;
  SubscriptionModel? get selectedPlan => _selectedPlan;

  // Image URL
  String? uploadedImageUrl;

  // Controllers
  final TextEditingController subscriptionNameController =
      TextEditingController();
  final TextEditingController subscriptionTitleController =
      TextEditingController();
  final TextEditingController subscriptionpriceController =
      TextEditingController();
  final TextEditingController subscriptiondurationValueController =
      TextEditingController();
  final TextEditingController subscriptiondurationUnitController =
      TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();

  // Boolean fields - updated to match new API
  bool subscriptionunlimitedLikes = false;
  bool subscriptionUnlimitedMessages = false;
  bool subscriptionUnlimitedSuperLikes = false;
  bool subscriptionSetPreferences = false;
  bool subscriptionAccessToClan = false;
  bool subscriptionAccessToRecentPass = false;
  bool subscriptionIsPlanActive = false;

  // Features list
  List<String> subscriptionfeatures = [];

  // Set selected plan for editing
  void setSelectedPlan(SubscriptionModel plan) {
    _selectedPlan = plan;
    uploadedImageUrl = plan.imageUrl;
    notifyListeners();
  }

  // Clear selected plan
  void clearSelectedPlan() {
    _selectedPlan = null;
    uploadedImageUrl = null;
    notifyListeners();
  }

  Future<void> getSubscriptions(
    BuildContext context, {
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        _isLoading = true;
        notifyListeners();
      }

      subscriptions.clear();
      notifyListeners();

      var result = await repo.getSubscriptions(
        pageNumber: _currentPage.toString(),
        pageSize: pageSize.toString(),
      );

      if (result['status'] == true) {
        final data = result['data'];

        if (data != null) {
          totalCount = data['totalCount'] ?? 0;
          totalPages = (totalCount / pageSize).ceil();

          if (data['subscriptions'] != null && data['subscriptions'] is List) {
            final List<dynamic> subsData = data['subscriptions'];

            final List<SubscriptionModel> newSubs =
                subsData.map((e) => SubscriptionModel.fromJson(e)).toList();

            subscriptions = newSubs;
          } else {
            subscriptions.clear();
          }
        } else {
          subscriptions.clear();
        }
      } else {
        subscriptions.clear();
      }
    } catch (e) {
      subscriptions.clear();
    } finally {
      if (showLoading) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  Future<bool> createSubscription(BuildContext context) async {
    try {
      _isCreating = true;
      notifyListeners();

      final planData = _buildPlanData();

      final result = await repo.createSubscription(planData: planData);

      if (result['status'] == true) {
        Fluttertoast.showToast(msg: "Subscription created successfully");

        resetSubscriptionFields();
        if (!context.mounted) return false;
        await getSubscriptions(context, showLoading: false);
        if (!context.mounted) return false;
        context
            .read<WrapperViewModel>()
            .updatePageIndex(GetWrapperPageViewStatus.plans);
        _isCreating = false;
        notifyListeners();

        return true;
      } else {
        _isCreating = false;
        notifyListeners();
        throw result['message'] ?? 'Failed to create subscription';
      }
    } catch (e) {
      _isCreating = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      return false;
    }
  }

  Future<bool> updateSubscription(
    String subscriptionId,
    BuildContext context,
  ) async {
    try {
      _isCreating = true;
      notifyListeners();

      final planData = _buildPlanData();

      final result = await repo.updateSubscription(
        subscriptionId: subscriptionId,
        planData: planData,
      );

      if (result['status'] == true) {
        Fluttertoast.showToast(msg: "Subscription updated successfully");

        resetSubscriptionFields();
        if (!context.mounted) return false;
        await getSubscriptions(context, showLoading: false);
        if (!context.mounted) return false;
        context
            .read<WrapperViewModel>()
            .updatePageIndex(GetWrapperPageViewStatus.plans);
        _isCreating = false;
        notifyListeners();

        return true;
      } else {
        _isCreating = false;
        notifyListeners();
        throw result['message'] ?? 'Failed to update subscription';
      }
    } catch (e) {
      _isCreating = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      return false;
    }
  }

  Future<bool> deleteSubscription(
    String subscriptionId,
    BuildContext context,
  ) async {
    try {
      _isCreating = true;
      notifyListeners();

      final result = await repo.deleteSubscription(
        subscriptionId: subscriptionId,
      );

      if (result['status'] == true) {
        Fluttertoast.showToast(
          msg: "Subscription deleted successfully",
          backgroundColor: Colors.red,
        );

        resetSubscriptionFields();
        if (!context.mounted) return false;
        await getSubscriptions(context, showLoading: false);

        _isCreating = false;
        notifyListeners();

        return true;
      } else {
        _isCreating = false;
        notifyListeners();
        throw result['message'] ?? 'Failed to delete subscription';
      }
    } catch (e) {
      _isCreating = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      return false;
    }
  }

  Map<String, dynamic> _buildPlanData() {
    final data = {
      "adminId": LoggedInUser.id,
      "planName": subscriptionNameController.text.trim(),
      "planTitle": subscriptionTitleController.text.trim(),
      "price": int.tryParse(subscriptionpriceController.text.trim()) ?? 0,
      'sellingPrice': int.tryParse(sellingPriceController.text.trim()) ?? 0,
      "features": subscriptionfeatures.map((feature) {
        return {"feature": feature};
      }).toList(),
      "durationValue":
          int.tryParse(subscriptiondurationValueController.text.trim()) ?? 1,
      "durationUnit": subscriptiondurationUnitController.text.trim().isNotEmpty
          ? subscriptiondurationUnitController.text.trim()
          : "Months",

      // Boolean fields matching the new API structure
      "unlimitedLikes": subscriptionunlimitedLikes,
      "unlimitedMessages": subscriptionUnlimitedMessages,
      "unlimitedSuperLikes": subscriptionUnlimitedSuperLikes,
      "setPreferences": subscriptionSetPreferences,
      "accessToClan": subscriptionAccessToClan,
      "accessToRecentPasses": subscriptionAccessToRecentPass,
      "isPlanActive": subscriptionIsPlanActive,
    };

    // Add imageUrl if available
    if (uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty) {
      data["imageUrl"] = uploadedImageUrl!;
    }

    return data;
  }

  void resetSubscriptionFields() {
    subscriptionNameController.clear();
    subscriptionTitleController.clear();
    subscriptionpriceController.clear();
    subscriptiondurationValueController.clear();
    sellingPriceController.clear();
    subscriptiondurationUnitController.text = "Months";

    subscriptionunlimitedLikes = false;
    subscriptionUnlimitedMessages = false;
    subscriptionUnlimitedSuperLikes = false;
    subscriptionSetPreferences = false;
    subscriptionAccessToClan = false;
    subscriptionAccessToRecentPass = false;
    subscriptionIsPlanActive = false;

    subscriptionfeatures.clear();
    uploadedImageUrl = null;

    notifyListeners();
  }

  @override
  void dispose() {
    subscriptionNameController.dispose();
    subscriptionTitleController.dispose();
    subscriptionpriceController.dispose();
    subscriptiondurationValueController.dispose();
    subscriptiondurationUnitController.dispose();
    sellingPriceController.dispose();

    super.dispose();
  }
}
