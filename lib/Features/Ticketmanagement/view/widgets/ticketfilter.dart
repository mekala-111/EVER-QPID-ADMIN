import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';

class TicketFilterBar extends StatefulWidget {
  final void Function({
    required String search,
    String? statusFilter,
    String? priorityFilter,
  }) onSearch;

  final VoidCallback onClear;

  const TicketFilterBar({
    super.key,
    required this.onSearch,
    required this.onClear,
  });

  @override
  State<TicketFilterBar> createState() => _TicketFilterBarState();
}

class _TicketFilterBarState extends State<TicketFilterBar> {
  final TextEditingController searchController = TextEditingController();
  String? selectedStatus;
  String? selectedPriority;

  bool get _shouldShowClearButton =>
      searchController.text.isNotEmpty ||
      selectedStatus != null ||
      selectedPriority != null;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    searchController.clear();
    selectedStatus = null;
    selectedPriority = null;
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
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: _inputDecoration(
                "Search by ticket ID, user, or subject",
                prefix: Icons.search,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 12),

          /// Status Filter
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
              initialValue: selectedStatus,
              decoration: _inputDecoration("Status"),
              items: const [
                DropdownMenuItem(value: null, child: Text("All Status")),
                DropdownMenuItem(value: "open", child: Text("Open")),
                DropdownMenuItem(value: "closed", child: Text("Closed")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
              },
            ),
          ),
          const SizedBox(width: 12),

          /// Priority Filter
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
              initialValue: selectedPriority,
              decoration: _inputDecoration("Priority"),
              items: const [
                DropdownMenuItem(value: null, child: Text("All Priority")),
                DropdownMenuItem(value: "high", child: Text("High")),
                DropdownMenuItem(value: "medium", child: Text("Medium")),
                DropdownMenuItem(value: "low", child: Text("Low")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPriority = value;
                });
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
                  statusFilter: selectedStatus,
                  priorityFilter: selectedPriority,
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

  InputDecoration _inputDecoration(String hint, {IconData? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14, color: PColors.color042F40),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      prefixIcon: prefix != null ? Icon(prefix, size: 20) : null,
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
