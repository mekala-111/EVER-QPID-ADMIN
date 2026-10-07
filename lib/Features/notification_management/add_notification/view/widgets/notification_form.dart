import 'package:everqpidadmin/Features/notification_management/add_notification/model/notification_list_model.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../view_model/notification_provider.dart';

class AddNotificationForm extends StatefulWidget {
  final NotificationModel? notificationToEdit;
  final bool isEditMode;

  const AddNotificationForm({
    super.key,
    this.notificationToEdit,
    this.isEditMode = false,
  });

  @override
  State<AddNotificationForm> createState() => _AddNotificationFormState();
}

class _AddNotificationFormState extends State<AddNotificationForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlController;

  late String _selectedType;
  final List<String> _notificationTypes = ['Promotional', 'Offer', 'Other'];

  late String _selectedTargetUser;
  final Map<String, String> _targetUserOptions = {
    'All Users': 'All_Users',
    'Male Users': 'Male_Users',
    'Female Users': 'Female_Users',
    'New Users': 'New_Users',
    'Users not Subscribed': 'Users_not_Subscribed',
    'Users with expiring plan': 'Users_with_expiring_plan',
  };

  Uint8List? _webImageBytes;
  String? _imageName;
  String? _existingImageUrl;

  DateTimeRange? _selectedDateRange;
  TimeOfDay? _selectedTime;

  final int _maxCharacters = 742;
  late int _selectedInterval;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    if (widget.isEditMode && widget.notificationToEdit != null) {
      final notification = widget.notificationToEdit!;

      _titleController = TextEditingController(text: notification.title);
      _descriptionController = TextEditingController(
        text: notification.description,
      );
      _urlController = TextEditingController(text: notification.url ?? '');

      if (notification.type.isNotEmpty) {
        final type = notification.type;
        _selectedType = type[0].toUpperCase() + type.substring(1);
      } else {
        _selectedType = 'Promotional';
      }

      _selectedTargetUser = notification.recipients.isNotEmpty
          ? notification.recipients[0]
          : 'All Users';

      _existingImageUrl = notification.image;

      // ✅ Initialize interval from notification data
      _selectedInterval = notification.interval;

      // Initialize time
      try {
        final time = notification.schedule.time;

        if (time != null && time.isNotEmpty && time.contains(":")) {
          final parts = time.split(':');

          if (parts.length >= 2) {
            final hour = int.tryParse(parts[0]);
            final minute = int.tryParse(parts[1]);

            if (hour != null && minute != null) {
              _selectedTime = TimeOfDay(hour: hour, minute: minute);
            }
          }
        }
      } catch (_) {
        _selectedTime = null;
      }

      // ✅ FIX: Parse dates as date-only (ignore time component)
      try {
        final startDate = notification.schedule.startDate;
        final endDate = notification.schedule.endDate;

        _selectedDateRange = DateTimeRange(
          start: DateTime(startDate.year, startDate.month, startDate.day),
          end: DateTime(endDate.year, endDate.month, endDate.day),
        );
      } catch (e) {
        _selectedDateRange = DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 7)),
        );
      }
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _urlController = TextEditingController();

      _selectedType = 'Promotional';
      _selectedTargetUser = 'all_users';

      // ✅ Initialize interval for add mode
      _selectedInterval = 1; // Default to 1 hour
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  // String _formatStartDateForApi(DateTime date) {
  //   // Set time to 00:00:00 (start of day) in local time, then convert to UTC
  //   final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
  //   return startOfDay.toUtc().toIso8601String();
  // }

  String _formatApiTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  /// Format end date to end of day in UTC
  // String _formatEndDateForApi(DateTime date) {
  //   // Set time to 23:59:59 (end of day) in local time, then convert to UTC
  //   final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
  //   return endOfDay.toUtc().toIso8601String();
  // }

  // Alternative: If you want to keep dates in local timezone without UTC conversion
  String _formatStartDateForApi(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    return startOfDay.toIso8601String(); // No .toUtc() call
  }

  String _formatEndDateForApi(DateTime date) {
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return endOfDay.toIso8601String(); // No .toUtc() call
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNotificationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildBreadcrumb(),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildFormCard(provider)),
                        const SizedBox(width: 24),
                        SizedBox(width: 332, child: _buildTargetUsersCard()),
                      ],
                    ),
                  ],
                ),
              ),
              if (provider.isCreating ||
                  provider.isUpdating ||
                  provider.isDeleting)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        PColors.primaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Text(
      widget.isEditMode ? 'Edit Notification' : 'Create Notification',
      style: const TextStyle(
        color: Color(0xFF091128),
        fontSize: 29,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w700,
        height: 1.20,
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Admin / Notifications / ',
            style: TextStyle(
              color: Color(0xFF67728D),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          TextSpan(
            text:
                widget.isEditMode ? 'Edit Notification' : 'Create Notification',
            style: const TextStyle(
              color: Color(0xFF67728D),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(AddNotificationProvider provider) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isEditMode ? 'Edit Notification' : 'Create Notification',
              style: const TextStyle(
                color: Color(0xFF091E42),
                fontSize: 17,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                height: 1.40,
              ),
            ),
            const SizedBox(height: 24),
            _buildFormRow(
              label: 'Notification Title',
              child: _buildTextField(
                controller: _titleController,
                hint: 'Title of your notification',
                enabled: !provider.isCreating && !provider.isUpdating,
              ),
            ),
            const SizedBox(height: 24),
            _buildFormRow(
              label: 'Notification Type',
              child: _buildDropdown(
                value: _selectedType,
                items: _notificationTypes,
                onChanged: provider.isCreating || provider.isUpdating
                    ? null
                    : (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                color: Color(0xFF67728D),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            const SizedBox(height: 8),
            _buildDescriptionField(provider),
            const SizedBox(height: 24),
            _buildFormRow(
              label: 'Notification Link',
              child: _buildTextField(
                controller: _urlController,
                hint: 'https://example.com',
                enabled: !provider.isCreating && !provider.isUpdating,
                isRequired: false,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Notification Image',
              style: TextStyle(
                color: Color(0xFF67728D),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            const SizedBox(height: 8),
            _buildImageUploader(provider),
            const SizedBox(height: 4),
            const Text(
              'SVG, PNG, JPEG Or GIF (Max. 3MB)',
              style: TextStyle(
                color: Color(0xFF67728D),
                fontSize: 12,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.60,
              ),
            ),
            const SizedBox(height: 24),
            _buildFormRow(
              label: 'Notification Schedule',
              child: _buildDateRangePicker(provider),
            ),
            const SizedBox(height: 24),
            _buildFormRow(
              label: 'Notification Time',
              child: _buildTimePicker(provider),
            ),

            const SizedBox(height: 24),
            const SizedBox(height: 24),
            _buildFormRow(
              label: 'Notification Interval',
              child: _buildIntervalField(provider),
            ),

            // _buildPauseToggle(provider),
            const SizedBox(height: 32),
            _buildActionButtons(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetUsersCard() {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E8EC)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Target Users',
            style: TextStyle(
              color: Color(0xFF091128),
              fontSize: 17,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 1.30,
            ),
          ),
          const SizedBox(height: 20),
          ..._targetUserOptions.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: _buildCheckboxOption(value: entry.key, label: entry.value),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFormRow({required String label, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 160,
          child: Text(
            label,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Color(0xFF67728D),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
    bool isRequired = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE4E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
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
        style: const TextStyle(
          color: Color(0xFF091128),
          fontSize: 14,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _buildIntervalField(AddNotificationProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE4E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedInterval,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF67728D)),
          style: const TextStyle(
            color: Color(0xFF091128),
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
          items: List.generate(30, (index) => index + 1).map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('Daily'),
            );
          }).toList(),
          onChanged: provider.isCreating || provider.isUpdating
              ? null
              : (value) {
                  setState(() {
                    _selectedInterval = value!;
                  });
                },
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE4E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF67728D)),
          style: const TextStyle(
            color: Color(0xFF091128),
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDescriptionField(AddNotificationProvider provider) {
    final remainingChars = _maxCharacters - _descriptionController.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 126,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFE4E7EB)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: TextFormField(
            controller: _descriptionController,
            enabled: !provider.isCreating && !provider.isUpdating,
            maxLines: null,
            maxLength: _maxCharacters,
            decoration: const InputDecoration(
              hintText: 'Add a short description',
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
              counterText: '',
            ),
            style: const TextStyle(
              color: Color(0xFF091128),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
            onChanged: (value) {
              setState(() {});
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Description is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$remainingChars Characters left',
              style: const TextStyle(
                color: Color(0xFF67728D),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.format_bold,
                    size: 16,
                    color: Color(0xFF67728D),
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(
                    Icons.format_italic,
                    size: 16,
                    color: Color(0xFF67728D),
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(
                    Icons.link,
                    size: 16,
                    color: Color(0xFF67728D),
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(
                    Icons.format_list_bulleted,
                    size: 16,
                    color: Color(0xFF67728D),
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageUploader(AddNotificationProvider provider) {
    final isDisabled = provider.isCreating || provider.isUpdating;

    return GestureDetector(
      onTap: isDisabled ? null : _pickImage,
      child: Container(
        height: 110,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: (_webImageBytes != null || _existingImageUrl != null)
                  ? PColors.primaryColor
                  : const Color(0xFFE4E7EB),
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_webImageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    _webImageBytes!,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
              else if (_existingImageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _existingImageUrl!,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Icon(
                  Icons.upload_file,
                  size: 30,
                  color: const Color(0xFF67728D),
                ),
              const SizedBox(height: 8),
              Text(
                _imageName ??
                    (_existingImageUrl != null
                        ? 'Current Image'
                        : 'Select or Drop File'),
                style: TextStyle(
                  color: (_webImageBytes != null || _existingImageUrl != null)
                      ? PColors.primaryColor
                      : const Color(0xFF67728D),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangePicker(AddNotificationProvider provider) {
    final isDisabled = provider.isCreating || provider.isUpdating;

    return GestureDetector(
      onTap: isDisabled ? null : _selectDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE4E7EB)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDateRange != null
                  ? '${DateFormat('dd MMM yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd MMM yyyy').format(_selectedDateRange!.end)}'
                  : 'Select date range',
              style: TextStyle(
                color: _selectedDateRange != null
                    ? const Color(0xFF091128)
                    : const Color(0xFF67728D),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            const Icon(
              Icons.calendar_today,
              size: 16,
              color: Color(0xFF67728D),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(AddNotificationProvider provider) {
    final isDisabled = provider.isCreating || provider.isUpdating;

    return GestureDetector(
      onTap: isDisabled ? null : _selectTime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE4E7EB)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedTime != null
                  ? _formatTime(_selectedTime!)
                  : 'Select time',
              style: TextStyle(
                color: _selectedTime != null
                    ? const Color(0xFF091128)
                    : const Color(0xFF67728D),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            const Icon(Icons.access_time, size: 16, color: Color(0xFF67728D)),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: PColors.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  // Widget _buildPauseToggle(AddNotificationProvider provider) {
  //   final isDisabled = provider.isCreating || provider.isUpdating;

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           _buildToggleSwitch(_isPaused, isDisabled),
  //           const SizedBox(width: 15),
  //           const Text(
  //             'Pause Notification',
  //             style: TextStyle(
  //               color: Color(0xFF091128),
  //               fontSize: 14,
  //               fontFamily: 'Roboto',
  //               fontWeight: FontWeight.w400,
  //               height: 1.50,
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 5),
  //       const Padding(
  //         padding: EdgeInsets.only(left: 73),
  //         child: Text(
  //           'This Will Be Default Inactive',
  //           style: TextStyle(
  //             color: Color(0xFF67728D),
  //             fontSize: 12,
  //             fontFamily: 'Roboto',
  //             fontWeight: FontWeight.w400,
  //             height: 1.60,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildCheckboxOption({required String value, required String label}) {
    final isSelected = _selectedTargetUser == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTargetUser = value;
        });
      },
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: ShapeDecoration(
              color: isSelected ? PColors.primaryColor : Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: isSelected
                      ? PColors.primaryColor
                      : const Color(0xFF67728D),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF091128),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AddNotificationProvider provider) {
    final isDisabled =
        provider.isCreating || provider.isUpdating || provider.isDeleting;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.isEditMode) ...[
          GestureDetector(
            onTap: isDisabled ? null : _showDeleteConfirmation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: isDisabled ? Colors.grey : const Color(0xFFDC3545),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: isDisabled ? Colors.grey : const Color(0xFFDC3545),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        // GestureDetector(
        //   onTap: isDisabled
        //       ? null
        //       : () {
        //           // context.read<WrapperViewModel>().updatePageIndex(
        //           //   GetWrapperPageViewStatus.notifications,
        //           // );
        //         },
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        //     decoration: ShapeDecoration(
        //       shape: RoundedRectangleBorder(
        //         side: BorderSide(
        //           width: 1,
        //           color: isDisabled ? Colors.grey : const Color(0xFF5B5126),
        //         ),
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //     ),
        //     child: Text(
        //       'Cancel',
        //       style: TextStyle(
        //         color: isDisabled ? Colors.grey : const Color(0xFF5B5126),
        //         fontSize: 14,
        //         fontFamily: 'Roboto',
        //         fontWeight: FontWeight.w400,
        //         height: 1.50,
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(width: 16),
        GestureDetector(
          onTap: isDisabled
              ? null
              : (widget.isEditMode
                  ? _handleUpdateNotification
                  : _handleCreateNotification),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            decoration: ShapeDecoration(
              color: isDisabled ? Colors.grey : PColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: provider.isCreating || provider.isUpdating
                ? const SizedBox(
                    width: 60,
                    height: 21,
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : Text(
                    widget.isEditMode ? 'Update' : 'Create',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text(
            'Delete Notification',
            style: TextStyle(
              color: Color(0xFF091128),
              fontSize: 17,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this notification? This action cannot be undone.',
            style: TextStyle(
              color: Color(0xFF67728D),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF67728D),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handleDeleteNotification();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFDC3545),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleCreateNotification() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date range'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = context.read<AddNotificationProvider>();

    String? imageUrl;
    Uint8List? imageBytes;
    String? imageName;

    if (_webImageBytes != null) {
      imageBytes = _webImageBytes;
      imageName = _webImageName ?? 'notification_image.jpg';
    } else if (_existingImageUrl != null && _existingImageUrl!.isNotEmpty) {
      imageUrl = _existingImageUrl;
    }

    final success = await provider.createNotification(
      title: _titleController.text.trim(),
      notificationType: _formatNotificationType(_selectedType),
      description: _descriptionController.text.trim(),
      link: _urlController.text.trim().isNotEmpty
          ? _urlController.text.trim()
          : null,
      imageUrl: imageUrl,
      imageBytes: imageBytes,
      imageName: imageName,
      recipients: [_selectedTargetUser], // ✅ Fixed: Use selected target user
      fromDate: _formatStartDateForApi(_selectedDateRange!.start),
      toDate: _formatEndDateForApi(_selectedDateRange!.end),
      interval: _selectedInterval,
      time: _formatApiTime(_selectedTime!),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification created successfully!'),
          backgroundColor: Color(0xFF28A745),
        ),
      );
      Provider.of<WrapperViewModel>(
        context,
        listen: false,
      ).updatePageIndex(GetWrapperPageViewStatus.notification);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to create notification'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? _webImageName;

  /// Platform-agnostic image picker: XFile bytes work on web and mobile.
  Future<void> _pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _webImageName = image.name;
          _imageName = image.name;
          _existingImageUrl = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ============================================
  // UPDATE NOTIFICATION HANDLER
  // ============================================
  /// Capitalize first letter of notification type
  String _formatNotificationType(String type) {
    if (type.isEmpty) return type;
    return type[0].toUpperCase() + type.substring(1).toLowerCase();
  }

  Future<void> _handleUpdateNotification() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date range'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = context.read<AddNotificationProvider>();

    String? imageUrl;
    Uint8List? imageBytes;
    String? imageName;

    if (_webImageBytes != null) {
      imageBytes = _webImageBytes;
      imageName = _webImageName ?? 'notification_image.jpg';
    } else if (_existingImageUrl != null && _existingImageUrl!.isNotEmpty) {
      imageUrl = _existingImageUrl;
    }

    final success = await provider.updateNotification(
      notificationId: widget.notificationToEdit!.id,
      title: _titleController.text.trim(),
      notificationType: _formatNotificationType(_selectedType),
      description: _descriptionController.text.trim(),
      link: _urlController.text.trim().isNotEmpty
          ? _urlController.text.trim()
          : null,
      imageUrl: imageUrl,
      imageBytes: imageBytes,
      imageName: imageName,
      recipients: [_selectedTargetUser], // ✅ Fixed: Use selected target user
      fromDate: _formatStartDateForApi(_selectedDateRange!.start),
      toDate: _formatEndDateForApi(_selectedDateRange!.end),
      interval: _selectedInterval,
      time: _formatApiTime(_selectedTime!),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification updated successfully!'),
          backgroundColor: Color(0xFF28A745),
        ),
      );
      Provider.of<WrapperViewModel>(
        context,
        listen: false,
      ).updatePageIndex(GetWrapperPageViewStatus.notification);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to update notification'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleDeleteNotification() async {
    final provider = context.read<AddNotificationProvider>();

    final success = await provider.deleteNotification(
      widget.notificationToEdit!.id,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification deleted successfully!'),
          backgroundColor: Color(0xFFDC3545),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back after showing snackbar
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Provider.of<WrapperViewModel>(
        context,
        listen: false,
      ).updatePageIndex(GetWrapperPageViewStatus.notification);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to delete notification'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
