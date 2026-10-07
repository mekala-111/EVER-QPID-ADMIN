import 'package:everqpidadmin/Features/plan_management/model/subscriptionmodel.dart';
import 'package:everqpidadmin/Features/plan_management/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Plancard extends StatelessWidget {
  final String planName;
  final String planTitle;
  final int price;
  final String imageUrl;
  final List<dynamic> features;
  final int durationValue;
  final String durationUnit;
  final bool isPlanActive;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;
  final ValueChanged<bool>? onActiveToggle;
  final SubscriptionModel plan;

  const Plancard({
    super.key,
    required this.planName,
    required this.planTitle,
    required this.price,
    required this.imageUrl,
    required this.features,
    required this.durationValue,
    required this.durationUnit,
    required this.isPlanActive,
    this.onEdit,
    this.onRemove,
    this.onActiveToggle,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            planName,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  height: 35,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(Images.everqpid, height: 35);
                  },
                )
              : Image.asset(Images.everqpid, height: 35),
          const SizedBox(height: 8),
          Text(
            planTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8E5CF6),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹$price",
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "/for $durationValue ${_getDurationText()}",
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];

                if (feature is Map<String, dynamic>) {
                  if (feature.containsKey('feature')) {
                    return _feature(feature['feature'].toString());
                  }
                } else if (feature is FeatureModel) {
                  return _feature(feature.feature);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Active",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Switch(
                value: isPlanActive,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF8E5CF6),
                onChanged: onActiveToggle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8E5CF6),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    context.read<SubscriptionViewmodel>().setSelectedPlan(plan);
                    context
                        .read<WrapperViewModel>()
                        .updatePageIndex(GetWrapperPageViewStatus.addPlan);
                  },
                  child: const Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  onPressed: () {
                    _showDeleteSubscriptionDialog(context, plan.id.toString());
                  },
                  child: const Text(
                    "Remove",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteSubscriptionDialog(BuildContext context, String planId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text("Remove Subscription"),
            ],
          ),
          content: const Text(
            "Are you sure you want to remove this subscription? This action cannot be undone.",
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                Navigator.pop(context);

                final success = await context
                    .read<SubscriptionViewmodel>()
                    .deleteSubscription(planId, context);

                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Subscription deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child:
                  const Text("Remove", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  String _getDurationText() {
    if (durationValue == 1) {
      return durationUnit.toLowerCase().replaceAll('s', '');
    }
    return durationUnit.toLowerCase();
  }

  static Widget _feature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.black, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
