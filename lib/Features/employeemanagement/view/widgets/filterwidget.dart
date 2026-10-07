import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';

class EmployeeFilterBar extends StatefulWidget {
  final void Function({
    required String search,
    required String status,
    required String role,
    DateTime? fromDate,
    DateTime? toDate,
  }) onSearch;

  final VoidCallback onClear;

  const EmployeeFilterBar({
    super.key,
    required this.onSearch,
    required this.onClear,
  });

  @override
  State<EmployeeFilterBar> createState() => _EmployeeFilterBarState();
}

class _EmployeeFilterBarState extends State<EmployeeFilterBar> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  String status = "";
  String role = "";
  DateTime? startDate;
  DateTime? endDate;

  bool get _shouldShowClearButton =>
      searchController.text.isNotEmpty ||
      status.isNotEmpty ||
      role.isNotEmpty ||
      fromDateController.text.isNotEmpty ||
      toDateController.text.isNotEmpty;

  @override
  void dispose() {
    searchController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    searchController.clear();
    fromDateController.clear();
    toDateController.clear();
    status = "";
    role = "";
    startDate = null;
    endDate = null;
    setState(() {});
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PColors.colorFFFFFF,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          /// Search
          SizedBox(
            width: 240,
            child: TextField(
              controller: searchController,
              decoration: _inputDecoration("Search by name or email",
                  prefix: Icons.search),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          const SizedBox(width: 12),

          /// Status
          SizedBox(
            width: 160,
            child: DropdownButtonFormField<String>(
              initialValue: status.isEmpty ? null : status,
              decoration: _inputDecoration("Status"),
              items: const [
                DropdownMenuItem(value: "", child: Text("All")),
                DropdownMenuItem(value: "active", child: Text("Active")),
                DropdownMenuItem(value: "inactive", child: Text("Inactive")),
              ],
              onChanged: (value) {
                status = value ?? "";
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 12),

          /// Role
          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              initialValue: role.isEmpty ? null : role,
              decoration: _inputDecoration("Role"),
              items: const [
                DropdownMenuItem(value: "", child: Text("All")),
                DropdownMenuItem(value: "Manager", child: Text("Manager")),
                DropdownMenuItem(value: "Marketing", child: Text("Marketing")),
                DropdownMenuItem(
                    value: "Chat Support", child: Text("Chat Support")),
                DropdownMenuItem(value: "Finance", child: Text("Finance")),
              ],
              onChanged: (value) {
                role = value ?? "";
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 12),

          /// From Date
          // SizedBox(
          //   width: 160,
          //   child: TextField(
          //     controller: fromDateController,
          //     readOnly: true,
          //     decoration: _inputDecoration("From Date",
          //         suffix: Icons.calendar_today),
          //     onTap: () async {
          //       final date = await showDatePicker(
          //         context: context,
          //         initialDate: startDate ?? DateTime.now(),
          //         firstDate: DateTime(2020),
          //         lastDate: DateTime.now(),
          //       );
          //       if (date != null) {
          //         startDate = date;
          //         fromDateController.text =
          //             DateFormat('yyyy-MM-dd').format(date);

          //         if (endDate != null && endDate!.isBefore(date)) {
          //           endDate = null;
          //           toDateController.clear();
          //         }
          //         setState(() {});
          //       }
          //     },
          //   ),
          // ),
          // const SizedBox(width: 12),

          // /// To Date
          // SizedBox(
          //   width: 160,
          //   child: TextField(
          //     controller: toDateController,
          //     readOnly: true,
          //     decoration: _inputDecoration("To Date",
          //         suffix: Icons.calendar_today),
          //     onTap: () async {
          //       final date = await showDatePicker(
          //         context: context,
          //         initialDate: endDate ?? startDate ?? DateTime.now(),
          //         firstDate: startDate ?? DateTime(2020),
          //         lastDate: DateTime.now(),
          //       );
          //       if (date != null) {
          //         endDate = date;
          //         toDateController.text =
          //             DateFormat('yyyy-MM-dd').format(date);
          //         setState(() {});
          //       }
          //     },
          //   ),
          // ),
          // const SizedBox(width: 12),

          /// Search Button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: PColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _performSearch,
              child: textWidget(
                text: "Search",
                color: Colors.white,
                fontsize: 14,
                fontweight: FontWeight.w500,
              ),
            ),
          ),

          /// Clear Button
          if (_shouldShowClearButton) ...[
            const SizedBox(width: 12),
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: _clearFilters,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF007BFF)),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: textWidget(
                  text: "Clear",
                  color: const Color(0xFF007BFF),
                  fontsize: 14,
                  fontweight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _performSearch() {
    widget.onSearch(
      search: searchController.text,
      status: status,
      role: role,
      fromDate: startDate,
      toDate: endDate,
    );
  }

  InputDecoration _inputDecoration(String hint,
      {IconData? prefix, IconData? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14, color: PColors.color042F40),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      prefixIcon: prefix != null ? Icon(prefix, size: 20) : null,
      suffixIcon: suffix != null ? Icon(suffix, size: 18) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: PColors.color042F40),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: PColors.color042F40),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF007BFF)),
      ),
    );
  }
}
