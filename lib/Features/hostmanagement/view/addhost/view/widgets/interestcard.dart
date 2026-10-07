import 'package:everqpidadmin/Features/hostmanagement/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ✅ Fixed InterestCard - only initialize once
class InterestCard extends StatefulWidget {
  const InterestCard({super.key});

  @override
  State<InterestCard> createState() => _InterestCardState();
}

class _InterestCardState extends State<InterestCard> {
  bool _hasInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<HostmanagementViewmodel>(
      builder: (context, hostVM, child) {
        // ✅ Only initialize once when in edit mode
        if (hostVM.isEditMode &&
            hostVM.editingHost != null &&
            !_hasInitialized &&
            hostVM.isInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_hasInitialized) {
              hostVM.setInterests(hostVM.editingHost!.interests);
              setState(() => _hasInitialized = true);
            }
          });
        }

        // ✅ Reset flag when exiting edit mode
        if (!hostVM.isEditMode && _hasInitialized) {
          _hasInitialized = false;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Interests",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...hostVM.availableInterests.map(
                (item) => CheckboxListTile(
                  value: hostVM.selectedInterests.contains(item),
                  onChanged: (_) => hostVM.toggleInterest(item),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(item, style: const TextStyle(fontSize: 14)),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: const Color(0xFF9B5DE5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }
}

// ✅ Fixed LanguageCard - only initialize once
