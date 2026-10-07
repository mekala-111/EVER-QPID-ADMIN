import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FemaleUserFilterBar extends StatefulWidget {
  final void Function({
    required String search,
    required String status,
    DateTime? fromDate,
    DateTime? toDate,
  }) onSearch;

  final VoidCallback onClear;

  const FemaleUserFilterBar({
    super.key,
    required this.onSearch,
    required this.onClear,
  });

  @override
  State<FemaleUserFilterBar> createState() => _FemaleUserFilterBarState();
}

class _FemaleUserFilterBarState extends State<FemaleUserFilterBar> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  String status = "";
  DateTime? startDate;
  DateTime? endDate;

  bool get _shouldShowClearButton =>
      searchController.text.isNotEmpty ||
      status.isNotEmpty ||
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
            width: 260,
            child: TextField(
              controller: searchController,
              decoration: _inputDecoration("Search by name or phone",
                  prefix: Icons.search),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 12),

          /// Status
          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              initialValue: status.isEmpty ? null : status,
              decoration: _inputDecoration("Status (All)"),
              items: const [
                DropdownMenuItem(value: "", child: Text("All")),
                DropdownMenuItem(value: "active", child: Text("Active")),
                DropdownMenuItem(value: "inactive", child: Text("Inactive")),
                DropdownMenuItem(value: "suspended", child: Text("Suspended")),
              ],
              onChanged: (value) {
                status = value ?? "";
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 12),

          /// From Date
          SizedBox(
            width: 160,
            child: TextField(
              controller: fromDateController,
              readOnly: true,
              decoration:
                  _inputDecoration("From Date", suffix: Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  startDate = date;
                  fromDateController.text =
                      DateFormat('yyyy-MM-dd').format(date);

                  if (endDate != null && endDate!.isBefore(date)) {
                    endDate = null;
                    toDateController.clear();
                  }
                  setState(() {});
                }
              },
            ),
          ),
          const SizedBox(width: 12),

          /// To Date
          SizedBox(
            width: 160,
            child: TextField(
              controller: toDateController,
              readOnly: true,
              decoration:
                  _inputDecoration("To Date", suffix: Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: endDate ?? startDate ?? DateTime.now(),
                  firstDate: startDate ?? DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  endDate = date;
                  toDateController.text = DateFormat('yyyy-MM-dd').format(date);
                  setState(() {});
                }
              },
            ),
          ),
          const SizedBox(width: 12),

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
              onPressed: () {
                widget.onSearch(
                  search: searchController.text,
                  status: status,
                  fromDate: startDate,
                  toDate: endDate,
                );
              },
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
