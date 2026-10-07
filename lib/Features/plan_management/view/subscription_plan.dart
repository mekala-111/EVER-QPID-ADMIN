import 'package:everqpidadmin/Features/plan_management/view/widgets/plancard.dart';
import 'package:everqpidadmin/Features/plan_management/view/widgets/subheaderwidget.dart';
import 'package:everqpidadmin/Features/plan_management/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/constants/sized_box.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionPlan extends StatefulWidget {
  const SubscriptionPlan({super.key});

  @override
  State<SubscriptionPlan> createState() => _SubscriptionPlanState();
}

class _SubscriptionPlanState extends State<SubscriptionPlan> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionViewmodel>().getSubscriptions(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Plan Pricing Management",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizeBoxH(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SubHeader(title: "Subscription Plan"),
                Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: GestureDetector(
                    onTap: () {
                      // Clear any selected plan and navigate to Add Plan
                      final viewModel = context.read<SubscriptionViewmodel>();
                      viewModel.clearSelectedPlan();
                      viewModel.resetSubscriptionFields();

                      // Navigate to Add Plan screen
                      // context.read<SidebarProvider>().selectItem('Add Plan');
                      context
                          .read<WrapperViewModel>()
                          .updatePageIndex(GetWrapperPageViewStatus.addPlan);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: PColors.primaryColor,
                        // border: Border.all(color: const Color(0xff4BAF4F)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          'ADD PLANS +',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Display subscription plans
            Expanded(
              child: Consumer<SubscriptionViewmodel>(
                builder: (context, viewmodel, child) {
                  if (viewmodel.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: PColors.primaryColor,
                      ),
                    );
                  }

                  if (viewmodel.subscriptions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No subscription plans available",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Click 'ADD PLAN' to create your first plan",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: viewmodel.subscriptions.length,
                    itemBuilder: (context, index) {
                      final subscription = viewmodel.subscriptions[index];

                      return Plancard(
                        plan: subscription,
                        planName: subscription.planName,
                        planTitle: subscription.planTitle,
                        price: subscription.price,
                        imageUrl: subscription.imageUrl,
                        features: subscription.features.toList(),
                        durationValue: subscription.durationValue,
                        durationUnit: subscription.durationUnit,
                        isPlanActive: subscription.isPlanActive,
                        onEdit: () {
                          // Add your edit logic here
                          // Example: viewmodel.selectPlanForEdit(subscription);
                        },
                        onRemove: () {
                          // Add your remove logic here
                          // Example: viewmodel.deletePlan(context, subscription.id);
                        },
                        onActiveToggle: (value) {
                          // Add your toggle logic here
                          // Example: viewmodel.updatePlanStatus(context, subscription.id, value);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
