import 'package:everqpidadmin/employeelogin/chatmangaement/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeChatfilter extends StatefulWidget {
  const EmployeeChatfilter({super.key});

  @override
  State<EmployeeChatfilter> createState() => _EmployeeChatfilterState();
}

class _EmployeeChatfilterState extends State<EmployeeChatfilter> {
  String? selectedHostId;
  String? selectedCity;
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();

    // Initialize with first employee and host after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<EmployeeChatManagementViewModel>();

      vm.getAssignedHosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeChatManagementViewModel>(
      builder: (context, vm, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Required filters indicator
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Host required',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Filters Row
              Row(
                children: [
                  /// Employee Filter (REQUIRED)

                  /// Host Filter (REQUIRED)
                  _filterDropdown(
                    label: 'Host *',
                    value: selectedHostId,
                    items: vm.hosts
                        .map(
                          (host) => DropdownMenuItem(
                            value: host.id,
                            child: Text(host.fullName ?? 'Unknown'),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedHostId = val;
                      });
                    },
                    isLoading: vm.isHostLoading,
                    isRequired: true,
                  ),
                  const SizedBox(width: 12),

                  /// City Filter (Optional)
                  _filterDropdown(
                    label: 'City',
                    value: selectedCity,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All'),
                      ),
                      ...vm.hostLocations.map(
                        (city) => DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        selectedCity = val;
                      });
                    },
                    isLoading: vm.isHostLocationLoading,
                  ),
                  const SizedBox(width: 12),

                  /// Language Filter (Optional)
                  _filterDropdown(
                    label: 'Language',
                    value: selectedLanguage,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All'),
                      ),
                      ...vm.hostLanguages.map(
                        (language) => DropdownMenuItem(
                          value: language,
                          child: Text(language),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        selectedLanguage = val;
                      });
                    },
                    isLoading: vm.isHostLanguageLoading,
                  ),
                  const SizedBox(width: 16),

                  /// Apply Button
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: (selectedHostId != null)
                          ? () => _applyFilters(vm)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  /// Clear Button
                  SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () {
                        _clearFilters(vm);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF8B5CF6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Apply filters
  void _applyFilters(EmployeeChatManagementViewModel vm) {
    if (selectedHostId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both Employee and Host'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    vm.applyFilters(
      hostId: selectedHostId!,
      city: selectedCity,
      language: selectedLanguage,
    );
  }

  /// Clear all filters
  void _clearFilters(EmployeeChatManagementViewModel vm) {
    // Reset to first employee and host
    setState(() {
      selectedHostId = null;
      selectedCity = null;
      selectedLanguage = null;
    });
  }

  /// Reusable Dropdown
  Widget _filterDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String?>> items,
    required ValueChanged<String?> onChanged,
    bool isLoading = false,
    bool isEnabled = true,
    bool isRequired = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isRequired ? Colors.red.shade700 : Colors.grey,
              fontWeight: isRequired ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String?>(
            initialValue: value,
            items: items,
            onChanged: isEnabled ? onChanged : null,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color:
                      isRequired ? Colors.red.shade300 : Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color:
                      isRequired ? Colors.red.shade300 : Colors.grey.shade300,
                ),
              ),
              suffixIcon: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : null,
            ),
            icon: isLoading
                ? const SizedBox.shrink()
                : const Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ),
    );
  }
}
