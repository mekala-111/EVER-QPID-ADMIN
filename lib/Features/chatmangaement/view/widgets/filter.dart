import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:everqpidadmin/Features/chatmangaement/viewmodel/viewmodel.dart';

class Chatfilter extends StatefulWidget {
  const Chatfilter({super.key});

  @override
  State<Chatfilter> createState() => _ChatfilterState();
}

class _ChatfilterState extends State<Chatfilter> {
  String? selectedEmployeeId;
  String? selectedHostId;
  String? selectedCity;
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();

    // Initialize with first employee and host after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ChatManagementViewModel>();

      if (vm.employees.isNotEmpty) {
        setState(() {
          selectedEmployeeId = vm.employees.first.id;
        });

        // Load hosts for first employee
        vm.getAssignedHosts(employeeId: selectedEmployeeId!).then((_) {
          if (vm.hosts.isNotEmpty) {
            setState(() {
              selectedHostId = vm.hosts.first.id;
            });

            // Apply initial filter
            _applyFilters(vm);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatManagementViewModel>(
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
                      'Employee & Host required',
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
                  _filterDropdown(
                    label: 'Employee *',
                    value: selectedEmployeeId,
                    items: vm.employees
                        .map(
                          (employee) => DropdownMenuItem(
                            value: employee.id,
                            child: Text(employee.name ?? 'Unknown'),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedEmployeeId = val;
                        selectedHostId =
                            null; // Reset host when employee changes
                      });

                      // Load hosts for selected employee
                      if (val != null) {
                        vm.getAssignedHosts(employeeId: val);
                      } else {
                        vm.hosts.clear();
                      }
                    },
                    isLoading: vm.isEmployeesLoading,
                    isRequired: true,
                  ),
                  const SizedBox(width: 12),

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
                    isEnabled: selectedEmployeeId != null,
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
                      onPressed:
                          (selectedEmployeeId != null && selectedHostId != null)
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
  void _applyFilters(ChatManagementViewModel vm) {
    if (selectedEmployeeId == null || selectedHostId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both Employee and Host'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    vm.applyFilters(
      employeeId: selectedEmployeeId!,
      hostId: selectedHostId!,
      city: selectedCity,
      language: selectedLanguage,
    );
  }

  /// Clear all filters
  void _clearFilters(ChatManagementViewModel vm) {
    // Reset to first employee and host
    if (vm.employees.isNotEmpty) {
      setState(() {
        selectedEmployeeId = vm.employees.first.id;
        selectedCity = null;
        selectedLanguage = null;
      });

      // Load hosts for first employee
      vm.getAssignedHosts(employeeId: selectedEmployeeId!).then((_) {
        if (vm.hosts.isNotEmpty) {
          setState(() {
            selectedHostId = vm.hosts.first.id;
          });

          // Apply filter with first employee and host
          vm.clearFilters();
        }
      });
    }
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
