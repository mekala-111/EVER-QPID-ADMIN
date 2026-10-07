import 'package:everqpidadmin/Features/hostmanagement/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageCard extends StatefulWidget {
  const LanguageCard({super.key});

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
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
              hostVM.setLanguages(hostVM.editingHost!.otherLanguages);
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
                "Languages",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...hostVM.availableLanguages.map(
                (lang) => CheckboxListTile(
                  value: hostVM.selectedLanguages.contains(lang),
                  onChanged: (_) => hostVM.toggleLanguage(lang),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(lang, style: const TextStyle(fontSize: 14)),
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
