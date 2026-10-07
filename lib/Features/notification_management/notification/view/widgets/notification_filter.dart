import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';

class NotificationFilterWidget extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final Function(String?)? onLanguageChanged;
  final Function(DateTime?)? onFromDateChanged;
  final Function(DateTime?)? onToDateChanged;
  final VoidCallback? onFilterPressed;

  const NotificationFilterWidget({
    super.key,
    this.onSearchChanged,
    this.onLanguageChanged,
    this.onFromDateChanged,
    this.onToDateChanged,
    this.onFilterPressed,
  });

  @override
  State<NotificationFilterWidget> createState() =>
      _NotificationFilterWidgetState();
}

class _NotificationFilterWidgetState extends State<NotificationFilterWidget> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: PColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF67728D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          widget.onFromDateChanged?.call(picked);
        } else {
          _toDate = picked;
          widget.onToDateChanged?.call(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Notifications',
              style: TextStyle(
                color: const Color(0xFF091128),
                fontSize: 17,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                height: 1.30,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Search Field
                _buildSearchField(),
                const SizedBox(width: 12),

                // Language Dropdown
                // _buildLanguageDropdown(),
                // const SizedBox(width: 12),

                // From Date Picker
                _buildDateField(
                  label: _fromDate == null
                      ? 'From'
                      : '${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}',
                  isFromDate: true,
                ),
                const SizedBox(width: 12),

                // To Date Picker
                _buildDateField(
                  label: _toDate == null
                      ? 'To'
                      : '${_toDate!.day}/${_toDate!.month}/${_toDate!.year}',
                  isFromDate: false,
                ),
                const SizedBox(width: 12),

                // Filter Button
                _buildFilterButton(),
                const SizedBox(width: 12),
                _buildClearButton(),
                SizedBox(width: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: 282,
      height: 41,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xFFE4E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Color(0xFF67728D)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              style: const TextStyle(
                color: Color(0xFF67728D),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
              decoration: const InputDecoration(
                hintText: 'Search by title',
                // counterText: 'name',
                hintStyle: TextStyle(
                  color: Color(0xFF67728D),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildLanguageDropdown() {
  //   return Container(
  //     width: 147,
  //     height: 41,
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border.all(
  //         width: 1,
  //         color: const Color(0xFFE4E7EB),
  //       ),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<String>(
  //         value: _selectedLanguage,
  //         hint: const Text(
  //           'Language (All)',
  //           style: TextStyle(
  //             color: Color(0xFF67728D),
  //             fontSize: 14,
  //             fontFamily: 'Roboto',
  //             fontWeight: FontWeight.w400,
  //             height: 1.50,
  //           ),
  //         ),
  //         icon: const Icon(
  //           Icons.keyboard_arrow_down,
  //           size: 20,
  //           color: Color(0xFF67728D),
  //         ),
  //         isExpanded: true,
  //         isDense: true,
  //         items: ['All', 'English', 'Spanish', 'French', 'German']
  //             .map((String value) {
  //           return DropdownMenuItem<String>(
  //             value: value,
  //             child: Text(
  //               value == 'All' ? 'Language ($value)' : value,
  //               style: const TextStyle(
  //                 color: Color(0xFF67728D),
  //                 fontSize: 14,
  //                 fontFamily: 'Roboto',
  //                 fontWeight: FontWeight.w400,
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (String? newValue) {
  //           setState(() {
  //             _selectedLanguage = newValue;
  //           });
  //           widget.onLanguageChanged?.call(newValue);
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDateField({required String label, required bool isFromDate}) {
    return InkWell(
      onTap: () => _selectDate(context, isFromDate),
      child: Container(
        width: 150,
        height: 41,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: const Color(0xFFE4E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Color(0xFF67728D),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF67728D),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: widget.onFilterPressed,
      child: Container(
        height: 41,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: PColors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Search',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _searchController.clear();
          _fromDate = null;
          _toDate = null;
        });

        // Call the callbacks with null/empty values
        widget.onSearchChanged?.call('');
        widget.onFromDateChanged?.call(null);
        widget.onToDateChanged?.call(null);
        widget.onLanguageChanged?.call(null);

        // Trigger API fetch with cleared filters
        if (widget.onFilterPressed != null) {
          widget.onFilterPressed!(); // You can reuse your filter button logic
        }
      },
      child: Container(
        height: 41,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Clear',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
      ),
    );
  }
}
