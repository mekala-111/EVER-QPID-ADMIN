import 'package:everqpidadmin/Features/plan_management/view/widgets/addplan/imagewidget.dart';
import 'package:everqpidadmin/Features/plan_management/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddPlanPage extends StatefulWidget {
  const AddPlanPage({super.key});

  @override
  State<AddPlanPage> createState() => _AddPlanPageState();
}

class _AddPlanPageState extends State<AddPlanPage> {
  bool _isInitialized = false;

  final GlobalKey<RightSidePlanSectionState> _featuresKey =
      GlobalKey<RightSidePlanSectionState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _isInitialized = true;
      final viewModel = context.read<SubscriptionViewmodel>();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (viewModel.selectedPlan != null) {
            _populateFieldsForEdit(viewModel);
          } else {
            viewModel.resetSubscriptionFields();
          }
        }
      });
    }
  }

  void _populateFieldsForEdit(SubscriptionViewmodel viewModel) {
    final plan = viewModel.selectedPlan!;

    // Populate text controllers
    viewModel.subscriptionNameController.text = plan.planName;
    viewModel.subscriptionTitleController.text = plan.planTitle;
    viewModel.subscriptionpriceController.text = plan.price.toString();
    viewModel.subscriptiondurationValueController.text =
        plan.durationValue.toString();
    viewModel.subscriptiondurationUnitController.text = plan.durationUnit;
    viewModel.sellingPriceController.text = plan.sellingPrice.toString();

    // Populate boolean fields
    viewModel.subscriptionunlimitedLikes = plan.unlimitedLikes;
    viewModel.subscriptionUnlimitedMessages = plan.unlimitedMessages;
    viewModel.subscriptionUnlimitedSuperLikes = plan.unlimitedSuperLikes;
    viewModel.subscriptionSetPreferences = plan.setPreferences;
    viewModel.subscriptionAccessToClan = plan.accessToClan;
    viewModel.subscriptionAccessToRecentPass = plan.accessToRecentPasses;
    viewModel.subscriptionIsPlanActive = plan.isPlanActive;

    // Populate features
    viewModel.subscriptionfeatures =
        plan.features.map((f) => f.feature).toList();

    viewModel.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: Consumer<SubscriptionViewmodel>(
        builder: (context, viewModel, child) {
          final isEditMode = viewModel.selectedPlan != null;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                    text: isEditMode ? "Edit Plan" : "Add Plan",
                    fontweight: FontWeight.w700,
                    fontsize: 20,
                  ),
                  const SizedBox(height: 8),
                  textWidget(
                    text: isEditMode
                        ? "Admin / Plan Management / Edit Plan"
                        : "Admin / Plan Management / Add Plan",
                    fontsize: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _planForm(viewModel, isEditMode),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 360,
                        child: RightSidePlanSection(
                          key: _featuresKey,
                          viewModel: viewModel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _planForm(
    SubscriptionViewmodel viewModel,
    bool isEditMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditMode ? "Edit Plan" : "Add Plan",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          _input(
              "Plan Name", "Weekly Plan", viewModel.subscriptionNameController),
          _input("Plan Title", "Everqpid Plus",
              viewModel.subscriptionTitleController),
          _input("Subscription Price (₹)", "199",
              viewModel.subscriptionpriceController,
              isNumber: true),
          _input("Selling Price (₹)", "199", viewModel.sellingPriceController,
              isNumber: true),
          _input("Duration Value", "1",
              viewModel.subscriptiondurationValueController,
              isNumber: true),
          _dropdown(
            "Duration Unit",
            viewModel.subscriptiondurationUnitController.text.isEmpty
                ? "Months"
                : viewModel.subscriptiondurationUnitController.text,
            ["Days", "Weeks", "Months", "Years"],
            (value) {
              viewModel.subscriptiondurationUnitController.text = value!;
              viewModel.refresh();
            },
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            "Features",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _switchRow("Unlimited Likes", viewModel.subscriptionunlimitedLikes,
              (v) {
            viewModel.subscriptionunlimitedLikes = v;
            viewModel.refresh();
          }),
          _switchRow(
              "Unlimited Messages", viewModel.subscriptionUnlimitedMessages,
              (v) {
            viewModel.subscriptionUnlimitedMessages = v;
            viewModel.refresh();
          }),
          _switchRow("Unlimited Super Likes",
              viewModel.subscriptionUnlimitedSuperLikes, (v) {
            viewModel.subscriptionUnlimitedSuperLikes = v;
            viewModel.refresh();
          }),
          _switchRow("Set Preferences", viewModel.subscriptionSetPreferences,
              (v) {
            viewModel.subscriptionSetPreferences = v;
            viewModel.refresh();
          }),
          _switchRow("Access To Clan", viewModel.subscriptionAccessToClan, (v) {
            viewModel.subscriptionAccessToClan = v;
            viewModel.refresh();
          }),
          _switchRow("Access to Recent Passes",
              viewModel.subscriptionAccessToRecentPass, (v) {
            viewModel.subscriptionAccessToRecentPass = v;
            viewModel.refresh();
          }),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _switchRow("Plan Active", viewModel.subscriptionIsPlanActive, (v) {
            viewModel.subscriptionIsPlanActive = v;
            viewModel.refresh();
          }),
          const Text(
            "This will determine if the plan is visible to users",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  viewModel.clearSelectedPlan();
                  viewModel.resetSubscriptionFields();
                  context
                      .read<WrapperViewModel>()
                      .updatePageIndex(GetWrapperPageViewStatus.plans);
                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: viewModel.isCreating
                    ? null
                    : () async {
                        if (_validateForm(viewModel)) {
                          bool success;
                          if (isEditMode) {
                            success = await viewModel.updateSubscription(
                              viewModel.selectedPlan!.id,
                              context,
                            );
                          } else {
                            success =
                                await viewModel.createSubscription(context);
                          }

                          if (success && context.mounted) {
                            viewModel.clearSelectedPlan();
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: viewModel.isCreating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        isEditMode ? "Update" : "Create",
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _validateForm(SubscriptionViewmodel viewModel) {
    if (viewModel.subscriptionNameController.text.trim().isEmpty) {
      _showError("Please enter plan name");
      return false;
    }
    if (viewModel.subscriptionTitleController.text.trim().isEmpty) {
      _showError("Please enter plan title");
      return false;
    }
    if (viewModel.subscriptionpriceController.text.trim().isEmpty) {
      _showError("Please enter price");
      return false;
    }
    if (viewModel.sellingPriceController.text.trim().isEmpty) {
      _showError("Please enter selling price");
      return false;
    }
    if (viewModel.subscriptiondurationValueController.text.trim().isEmpty) {
      _showError("Please enter duration value");
      return false;
    }
    if (viewModel.subscriptionfeatures.isEmpty) {
      _showError("Please add at least one feature");
      return false;
    }
    if (viewModel.uploadedImageUrl == null ||
        viewModel.uploadedImageUrl!.isEmpty) {
      _showError("Please upload an image");
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _switchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Switch(
              value: value,
              activeThumbColor: Colors.purple,
              onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _input(String label, String hint, TextEditingController controller,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: isNumber
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            inputFormatters: isNumber
                ? [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ]
                : null,
            decoration: InputDecoration(
              hintText: hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: value,
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
