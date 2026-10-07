import 'package:everqpidadmin/Features/hostmanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/model/employeesmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class CreateHostForm extends StatefulWidget {
  const CreateHostForm({super.key});

  @override
  State<CreateHostForm> createState() => _CreateHostFormState();
}

class _CreateHostFormState extends State<CreateHostForm> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final aboutController = TextEditingController();
  final companyController = TextEditingController();
  final universityController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final professionController = TextEditingController();
  final educationController = TextEditingController();

  // Dropdown Values
  String? selectedGender;
  String? selectedProfileType;
  String? selectedMaritalStatus;
  String? selectedHeight;
  String? selectedState;
  String? selectedCity;
  String? selectedProfession;
  String? selectedEducation;
  String? selectedYear;
  String? selectedReligion;

  bool _isInitialized = false;
  String? selectedEducationDegree;

  final List<String> educationDegrees = [
    'B.Tech',
    'B.E',
    'M.Tech',
    'MBA',
    'BBA',
    'BCA',
    'MCA',
    'BSc',
    'MSc',
    'BA',
    'MA',
    'PhD',
    'Diploma',
    'Other',
  ];

  String? selectedProfessionDegree;

  final List<String> professionList = [
    'Software Developer',
    'Designer',
    'Manager',
    'Engineer',
    'Consultant',
    'Analyst',
    'Teacher',
    'Doctor',
    'Lawyer',
    'Accountant',
    'Marketing',
    'Sales',
    'HR',
    'Other',
  ];
  // Add these new controllers in the class
  final roleInCompanyController = TextEditingController();
  final currentLocationController = TextEditingController();
  final homeLocationController = TextEditingController();

// Add these new dropdown/selection values
  String? selectedZodiacSign;
  String? selectedAlcoholConsumption;
  String? selectedSmokingHabit;
  String? selectedWorkoutFrequency;
  String? selectedEmploymentType;
  bool isCurrentLocationAndHomeSame = true;
  bool currentlyStudying = false;
  List<String> selectedRelationshipGoals = [];

// Available options for new dropdowns
  final List<String> zodiacSigns = [
    "Capricorn",
    "Aquarius",
    "Pisces",
    "Aries",
    "Taurus",
    "Gemini",
    "Cancer",
    "Leo",
    "Virgo",
    "Libra",
    "Scorpio",
    "Sagittarius",
  ];

  final List<String> alcoholOptions = [
    "Not for me",
    "Sober",
    "Sober curious",
    "On special occasions",
    "Socially on weekends",
    "Most Nights",
  ];
  final List<String> smokingOptions = [
    "Social smoker",
    "Smoker when drinking",
    "Non-smoker",
    "Smoker",
    "Trying to quit",
  ];
  final List<String> workoutOptions = [
    'Never',
    'Sometimes',
    'Often',
    'Everyday'
  ];
  final List<String> employmentTypes = [
    'Permanent',
    'Contract',
    'Freelance',
    'Internship',
    'Self-employed',
  ];
  final List<String> relationshipGoalOptions = [
    'Looking for a partner',
    'Friendship',
    'Marriage',
    'Long-term Relationship',
    'Long-term, open to short',
    'Short-term, open to long',
    'Short-term, fun',
    'New friends',
    'Casual dating',
    'Still figuring it out',
  ];
  List<String> selectedLanguages = [];
  List<String> selectedInterests = [];

// ADD THESE OPTION LISTS
  final List<String> availableLanguages = [
    'Hindi',
    'English',
    'Bengali',
    'Telugu',
    'Marathi',
    'Tamil',
    'Gujarati',
    'Urdu',
    'Kannada',
    'Odia',
    'Malayalam',
    'Punjabi',
    'Assamese',
    'Maithili',
    'Sanskrit',
    'Konkani',
    'Nepali',
    'Sindhi',
    'Dogri',
    'Kashmiri',
    'Manipuri',
    'Bodo',
    'Santali',
  ];

  final List<String> availableInterests = [
    'Travelling',
    'Reading',
    'Music',
    'Movies',
    'Photography',
    'Cooking',
    'Fitness',
    'Gaming',
    'Art',
    'Dancing',
    'Sports',
    'Yoga',
    'Writing',
    'Meditation',
    'Technology',
    'Fashion',
    'Food',
    'Nature',
    'Pets',
    'Volunteering'
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Add this to your _initializeData() method after existing field population:

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized && mounted) {
        final viewModel = context.read<HostmanagementViewmodel>();

        // ✅ Load employees first and WAIT for completion
        viewModel.getChatEmployees().then((_) {
          if (!mounted) return;

          // ✅ Add another small delay to ensure notifyListeners completes
          Future.delayed(const Duration(milliseconds: 50), () {
            if (!mounted) return;

            if (viewModel.isEditMode && viewModel.editingHost != null) {
              final host = viewModel.editingHost!;

              // Set all text fields
              nameController.text = host.fullName;
              dobController.text = _formatDateForDisplay(host.dateOfBirth);
              aboutController.text = host.aboutMe;
              companyController.text = host.companyName;
              universityController.text = host.collegeName;
              emailController.text = host.email;
              mobileController.text = host.mobileNumber;

              // Set dropdowns
              selectedGender = host.gender;
              selectedProfileType = host.isVerified ? 'Verified' : 'Unverified';
              selectedMaritalStatus = host.relationshipStatus;
              selectedHeight = convertHeightToCm(host.height.toString());
              selectedProfessionDegree =
                  professionList.contains(host.currentProfession)
                      ? host.currentProfession
                      : 'Other';
              selectedEducationDegree =
                  educationDegrees.contains(host.education)
                      ? host.education
                      : 'Other';
              selectedYear = host.graduationYear.toString();
              selectedReligion = host.religion;

              // NEW FIELDS
              selectedZodiacSign = host.zodiacSign;
              selectedAlcoholConsumption = host.alcoholConsumption;
              selectedSmokingHabit = host.smokingHabit;
              selectedWorkoutFrequency = host.workoutFrequency;
              selectedEmploymentType = host.employmentType;
              roleInCompanyController.text = host.roleInCompany;
              currentLocationController.text = host.locationString.toString();
              homeLocationController.text = host.locationString;
              currentlyStudying = host.currentlyStudying;
              selectedRelationshipGoals =
                  List<String>.from(host.relationshipGoals);
              selectedLanguages = List<String>.from(host.otherLanguages);
              selectedInterests = List<String>.from(host.interests);

              // ✅ NOW initialize employee - employees list should be ready

              viewModel.initializeEmployeeForEdit(host.assignedEmployeeId);

              _isInitialized = true;
              setState(() {});
            }
          });
        });
      }
    });
  }

  String _formatDateForDisplay(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  @override
  void dispose() {
    // Existing controllers...
    nameController.dispose();
    dobController.dispose();
    aboutController.dispose();
    companyController.dispose();
    universityController.dispose();
    emailController.dispose();
    mobileController.dispose();

    // ✅ NEW - Add these
    roleInCompanyController.dispose();
    currentLocationController.dispose();
    homeLocationController.dispose();

    super.dispose();
  }

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Phone number validation
  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }

    // Remove any spaces or special characters
    final cleanedNumber = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it's a valid 10-digit Indian mobile number
    if (cleanedNumber.length != 10) {
      return 'Mobile number must be 10 digits';
    }

    // Indian mobile numbers start with 6, 7, 8, or 9
    if (!['6', '7', '8', '9'].contains(cleanedNumber[0])) {
      return 'Invalid mobile number';
    }

    return null;
  }

  Map<String, dynamic> _buildHostData() {
    final viewModel = context.read<HostmanagementViewmodel>();
    final photoUrls = viewModel.getUploadedImageUrlsList();

    final data = {
      // Existing fields
      'fullName': nameController.text.trim(),
      'email': emailController.text.trim(),
      'mobileNumber': mobileController.text.trim(),
      'countryCode': '+91',
      'gender': selectedGender ?? '',
      'dateOfBirth': dobController.text.trim(),
      'aboutMe': aboutController.text.trim(),
      'relationshipStatus': selectedMaritalStatus ?? '',
      'height': extractHeightNumber(selectedHeight) ?? '',
      'currentProfession': selectedProfessionDegree ?? '',
      'companyName': companyController.text.trim(),
      'education': selectedEducationDegree ?? '',
      'collegeName': universityController.text.trim(),
      'graduationYear': int.tryParse(selectedYear ?? '0') ?? 0,
      'isVerified': selectedProfileType == 'Verified',
      'religion': selectedReligion ?? '',
      'assignedEmployeeId': viewModel.selectedEmployeeId,

      // ✅ FIX: Add both profileImageUrl AND profilePhotos array
      'profileImageUrl': photoUrls.isNotEmpty ? photoUrls[0] : '',
      'profilePhotos': photoUrls, // ✅ ADDED

      // Lifestyle fields
      'zodiacSign': selectedZodiacSign ?? '',
      'alcoholConsumption': selectedAlcoholConsumption ?? '',
      'smokingHabit': selectedSmokingHabit ?? '',
      'workoutFrequency': selectedWorkoutFrequency ?? '',
      'roleInCompany': roleInCompanyController.text.trim(),
      'employmentType': selectedEmploymentType ?? '',
      'currentlyStudying': currentlyStudying,
      'relationshipGoals': selectedRelationshipGoals,

      // ✅ ADD MISSING FIELDS
      'otherLanguages': selectedLanguages,
      'interests': selectedInterests,

      // Location fields
      'isCurrentLocationAndHomeSame': isCurrentLocationAndHomeSame,
      'currentLocationString': currentLocationController.text.trim(),
      'locationString': isCurrentLocationAndHomeSame
          ? currentLocationController.text.trim()
          : homeLocationController.text.trim(),
      'currentLat': 0.0,
      'currentLng': 0.0,
      'lat': 0.0,
      'lng': 0.0,
    };

    data.removeWhere((key, value) =>
        value is String && value.isEmpty || value is List && value.isEmpty);

    return data;
  }

  // Convert "5ft 3in" to "160 cm" for display in dropdown
  String? convertHeightToCm(String? height) {
    if (height == null || height.isEmpty) return null;

    // If it's already a number, just add cm
    if (RegExp(r'^\d+$').hasMatch(height)) {
      return "$height cm";
    }

    final reg = RegExp(r'(\d+)ft\s*(\d+)in');
    final match = reg.firstMatch(height);

    if (match != null) {
      final feet = int.parse(match.group(1)!);
      final inches = int.parse(match.group(2)!);
      final cm = ((feet * 12 + inches) * 2.54).round();
      return "$cm cm";
    }
    return null;
  }

  // Extract just the number from "160 cm" format
  String? extractHeightNumber(String? height) {
    if (height == null || height.isEmpty) return null;

    final reg = RegExp(r'(\d+)');
    final match = reg.firstMatch(height);

    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  Future<bool> _showConfirmationDialog(String action) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm $action'),
              content: Text('Are you sure you want to $action this host?'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B5DE5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    action,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final viewModel = context.read<HostmanagementViewmodel>();
    final action = viewModel.isEditMode ? 'Update' : 'Create';

    // Show confirmation dialog
    final confirmed = await _showConfirmationDialog(action);
    if (!confirmed || !mounted) return;

    final hostData = _buildHostData();

    bool success = false;

    if (viewModel.isEditMode && viewModel.editingHost != null) {
      success = await viewModel.updateHostFn(
        context,
        viewModel.editingHost!.id,
        hostData,
      );
    } else {
      success = await viewModel.createHostFn(context, hostData);
    }

    if (success && mounted) {
      _clearForm();
      _isInitialized = false;
    }
  }

  void _clearForm() {
    // Existing controllers
    nameController.clear();
    dobController.clear();
    aboutController.clear();
    companyController.clear();
    universityController.clear();
    emailController.clear();
    mobileController.clear();

    // ✅ NEW - Clear new controllers
    roleInCompanyController.clear();
    currentLocationController.clear();
    homeLocationController.clear();

    setState(() {
      // Existing fields
      selectedGender = null;
      selectedProfileType = null;
      selectedMaritalStatus = null;
      selectedHeight = null;
      selectedState = null;
      selectedCity = null;
      selectedProfession = null;
      selectedEducation = null;
      selectedYear = null;
      selectedReligion = null;
      selectedEducationDegree = null;
      selectedProfessionDegree = null;
      // ✅ NEW - Clear new fields
      selectedZodiacSign = null;
      selectedAlcoholConsumption = null;
      selectedSmokingHabit = null;
      selectedWorkoutFrequency = null;
      selectedEmploymentType = null;
      isCurrentLocationAndHomeSame = true;
      currentlyStudying = false;
      selectedRelationshipGoals = [];
      selectedLanguages = [];
      selectedInterests = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HostmanagementViewmodel>();
    final isLoading = viewModel.creatingHost || viewModel.updatingHost;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.isEditMode ? "Edit Host" : "Create Host",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _formRow(
              label: "Host Name*",
              field:
                  _textField("Enter full name", nameController, required: true),
            ),
            _formRow(
              label: "Email*",
              field: _emailField(),
            ),
            _formRow(
              label: "Mobile Number*",
              field: _phoneField(),
            ),
            _formRow(
              label: "Date of Birth*",
              field: _dateField(dobController),
            ),
            _formRow(
              label: "Gender*",
              field: _dropdown(
                value: selectedGender,
                items: ["Women"],
                onChanged: (val) => setState(() => selectedGender = val),
                required: true,
              ),
            ),
            buildEmployeeDropdown(viewModel),
            const SizedBox(height: 16),

            // Profile Photos Section
            _buildProfilePhotosSection(viewModel),
            const SizedBox(height: 16),

            _formRow(
              label: "Profile Type",
              field: _dropdown(
                value: selectedProfileType,
                items: ["Verified", "Unverified"],
                onChanged: (val) => setState(() => selectedProfileType = val),
              ),
            ),
            _formRow(
              label: "About Host",
              field: _aboutHost(aboutController),
            ),
            _formRow(
              label: "Marital Status",
              field: _dropdown(
                value: selectedMaritalStatus,
                items: ["Single", "Married", "Divorced", "Widowed"],
                onChanged: (val) => setState(() => selectedMaritalStatus = val),
              ),
            ),
            _formRow(
              label: "Height",
              field: _dropdown(
                value: selectedHeight,
                items: List.generate(61, (i) => "${140 + i} cm"),
                onChanged: (val) => setState(() => selectedHeight = val),
              ),
            ),
            _formRow(
              label: "Religion",
              field: _dropdown(
                value: selectedReligion,
                items: [
                  'Hindu',
                  'Muslim',
                  'Christian',
                  'Sikh',
                  'Buddhist',
                  'Jain',
                  'Other',
                  'Prefer not to say',
                ],
                onChanged: (val) => setState(() => selectedReligion = val),
              ),
            ),
            _formRow(
              label: "Profession",
              field: _dropdown(
                value: selectedProfessionDegree,
                items: professionList,
                onChanged: (val) =>
                    setState(() => selectedProfessionDegree = val),
              ),
            ),
            _formRow(
              label: "Company",
              field: _textField("Company name", companyController),
            ),
            const SizedBox(height: 24),

// Professional Section (add after existing profession field)
            _formRow(
              label: "Role in Company",
              field: _textField("Enter role/position", roleInCompanyController),
            ),

            _formRow(
              label: "Employment Type",
              field: _dropdown(
                value: selectedEmploymentType,
                items: employmentTypes,
                onChanged: (val) =>
                    setState(() => selectedEmploymentType = val),
              ),
            ),

            _formRow(
              label: "Education",
              field: _dropdown(
                value: selectedEducationDegree,
                items: educationDegrees,
                onChanged: (val) =>
                    setState(() => selectedEducationDegree = val),
              ),
            ),
            _formRow(
              label: "University",
              field: _textField("University name", universityController),
            ),
            _formRow(
              label: "Currently Studying?",
              field: CheckboxListTile(
                value: currentlyStudying,
                onChanged: (val) =>
                    setState(() => currentlyStudying = val ?? false),
                title: const Text("Currently pursuing education"),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            // _formRow(
            //   label: "Graduation Year",
            //   field: _dropdown(
            //     value: selectedYear,
            //     items: List.generate(30, (i) => (2025 - i).toString()),
            //     onChanged: (val) => setState(() => selectedYear = val),
            //   ),
            // ),
            const SizedBox(height: 24),
            // Add these fields in your build() method after existing fields:

// After the "About Host" field, add these new sections:

// Lifestyle Section
            Text(
              "Lifestyle Information",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9B5DE5),
              ),
            ),
            const SizedBox(height: 16),

            _formRow(
              label: "Zodiac Sign",
              field: _dropdown(
                value: selectedZodiacSign,
                items: zodiacSigns,
                onChanged: (val) => setState(() => selectedZodiacSign = val),
              ),
            ),

            _formRow(
              label: "Alcohol Consumption",
              field: _dropdown(
                value: selectedAlcoholConsumption,
                items: alcoholOptions,
                onChanged: (val) =>
                    setState(() => selectedAlcoholConsumption = val),
              ),
            ),

            _formRow(
              label: "Smoking Habit",
              field: _dropdown(
                value: selectedSmokingHabit,
                items: smokingOptions,
                onChanged: (val) => setState(() => selectedSmokingHabit = val),
              ),
            ),

            _formRow(
              label: "Workout Frequency",
              field: _dropdown(
                value: selectedWorkoutFrequency,
                items: workoutOptions,
                onChanged: (val) =>
                    setState(() => selectedWorkoutFrequency = val),
              ),
            ),

            const SizedBox(height: 24),

// Relationship Goals Section
            Text(
              "Relationship Goals",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9B5DE5),
              ),
            ),
            const SizedBox(height: 8),
            _buildRelationshipGoalsSelector(),
            const SizedBox(height: 24),

// // Languages Section
//             Text(
//               "Languages",
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF9B5DE5),
//               ),
//             ),
//             const SizedBox(height: 8),
//             _buildLanguagesSelector(),
//             const SizedBox(height: 16),

// Interests Section
            // Text(
            //   "Interests & Hobbies",
            //   style: const TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: Color(0xFF9B5DE5),
            //   ),
            // ),
            // const SizedBox(height: 8),
            // _buildInterestsSelector(),
            // const SizedBox(height: 16),
// Location Section
            Text(
              "Location Information",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9B5DE5),
              ),
            ),
            const SizedBox(height: 16),

            _formRow(
              label: "Current Location",
              field: _textField(
                  "Enter current location", currentLocationController),
            ),

            _formRow(
              label: "Same as Home?",
              field: CheckboxListTile(
                value: isCurrentLocationAndHomeSame,
                onChanged: (val) =>
                    setState(() => isCurrentLocationAndHomeSame = val ?? true),
                title: const Text("Current location is same as home location"),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            if (!isCurrentLocationAndHomeSame)
              _formRow(
                label: "Home Location",
                field:
                    _textField("Enter home location", homeLocationController),
              ),

            _buildButtons(isLoading, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhotosSection(HostmanagementViewmodel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Photos',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Grid of 4 image upload slots
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final hasImage = index < viewModel.uploadedImageUrls.length &&
                viewModel.uploadedImageUrls[index].isNotEmpty;
            final isUploading = viewModel.uploadingImageIndex == index;

            return _buildImageUploadSlot(
              context,
              viewModel,
              index,
              hasImage,
              isUploading,
            );
          },
        ),
      ],
    );
  }
// Add this widget method in your _CreateHostFormState class:

  Widget _buildRelationshipGoalsSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 160,
            child: Text(
              'Relationship Goals',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: relationshipGoalOptions.map((goal) {
                final isSelected = selectedRelationshipGoals.contains(goal);
                return FilterChip(
                  label: Text(goal),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedRelationshipGoals.add(goal);
                      } else {
                        selectedRelationshipGoals.remove(goal);
                      }
                    });
                  },
                  selectedColor: const Color(0xFF9B5DE5).withValues(alpha: 0.2),
                  checkmarkColor: const Color(0xFF9B5DE5),
                  backgroundColor: Colors.grey.shade100,
                  labelStyle: TextStyle(
                    color:
                        isSelected ? const Color(0xFF9B5DE5) : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSlot(
    BuildContext context,
    HostmanagementViewmodel viewModel,
    int index,
    bool hasImage,
    bool isUploading,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Image preview or placeholder
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: hasImage
                  ? Image.network(
                      viewModel.uploadedImageUrls[index],
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    )
                  : Container(
                      color: Colors.grey.shade100,
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.grey.shade400,
                        size: 40,
                      ),
                    ),
            ),
          ),

          // Action button
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              height: 36,
              child: isUploading
                  ? const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : hasImage
                      ? OutlinedButton(
                          onPressed: () {
                            viewModel.removeImageAt(index);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Remove',
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            await _pickAndUploadImage(
                                context, viewModel, index);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xFF9B5DE5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Upload',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage(
    BuildContext context,
    HostmanagementViewmodel viewModel,
    int index,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (file.bytes != null) {
          viewModel.setImageAt(index, file.bytes!, file.name);

          if (!context.mounted) return;
          final success = await viewModel.uploadProfileImageAt(context, index);

          if (!success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to upload image'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _formRow({required String label, required Widget field}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(child: field),
        ],
      ),
    );
  }

  Widget _textField(
    String hint,
    TextEditingController controller, {
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(hint),
      validator: required
          ? (val) => val == null || val.trim().isEmpty ? 'Required' : null
          : null,
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: emailController,
      decoration: _inputDecoration("Enter email address"),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: _validateEmail,
    );
  }

  Widget buildEmployeeDropdown(HostmanagementViewmodel provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              'Assigned Employee*',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                provider.isEmployeesLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : provider.employees.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'No employees available',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : DropdownButtonFormField<Employee>(
                            initialValue: provider.selectedEmployee,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Color(0xFF9B5DE5), width: 2),
                              ),
                              hintText: 'Select an employee',
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: provider.employees.map((Employee employee) {
                              return DropdownMenuItem<Employee>(
                                value: employee,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      employee.name ?? 'Unknown',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // if (employee.email != null)
                                    //   Text(
                                    //     employee.email!,
                                    //     style: TextStyle(
                                    //       fontSize: 11,
                                    //       color: Colors.grey.shade600,
                                    //     ),
                                    //     overflow: TextOverflow.ellipsis,
                                    //   ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (Employee? newValue) {
                              provider.setSelectedEmployee(newValue);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an employee';
                              }
                              return null;
                            },
                          ),

                // Display selected employee details
                // if (provider.selectedEmployee != null)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 8),
                //     child: Container(
                //       padding: const EdgeInsets.all(8),
                //       decoration: BoxDecoration(
                //         color: Colors.blue.shade50,
                //         borderRadius: BorderRadius.circular(6),
                //       ),
                //       child: Row(
                //         children: [
                //           Icon(Icons.check_circle,
                //               color: Colors.blue.shade700, size: 16),
                //           const SizedBox(width: 8),
                //           Expanded(
                //             child: Text(
                //               'Selected: ${provider.selectedEmployee!.name} (ID: ${provider.selectedEmployeeId})',
                //               style: TextStyle(
                //                 fontSize: 12,
                //                 color: Colors.blue.shade700,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _phoneField() {
    return TextFormField(
      controller: mobileController,
      decoration: _inputDecoration("Enter 10-digit mobile number"),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: _validatePhone,
    );
  }

  Widget _dateField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration("YYYY-MM-DD"),
      readOnly: true,
      onTap: () async {
        final lastAllowedDate = DateTime(
          DateTime.now().year - 18,
          DateTime.now().month,
          DateTime.now().day,
        );

        final date = await showDatePicker(
          context: context,
          initialDate: lastAllowedDate, // ✅ start at max allowed date
          firstDate: DateTime(1950),
          lastDate: lastAllowedDate,
        );
        if (date != null) {
          controller.text = date.toString().split(' ')[0];
        }
      },
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
    );
  }

  Widget _dropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    bool required = false,
  }) {
    // ✅ Convert empty strings to null
    final effectiveValue = (value == null || value.isEmpty) ? null : value;

    // ✅ Validate that value exists in items
    final validatedValue =
        (effectiveValue != null && items.contains(effectiveValue))
            ? effectiveValue
            : null;

    return DropdownButtonFormField<String>(
      initialValue: validatedValue,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      decoration: _inputDecoration("Select"),
      validator: required
          ? (val) => val == null || val.isEmpty ? 'Required' : null
          : null,
    );
  }

  Widget _aboutHost(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          maxLines: 4,
          maxLength: 500,
          decoration: _inputDecoration("Add a short description"),
        ),
      ],
    );
  }

  Widget _buildButtons(bool isLoading, HostmanagementViewmodel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: isLoading
              ? null
              : () {
                  _clearForm();
                  _isInitialized = false;
                  viewModel.clearEditMode();
                  context
                      .read<WrapperViewModel>()
                      .updatePageIndex(GetWrapperPageViewStatus.allhost);
                },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Cancel"),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: isLoading ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9B5DE5),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  viewModel.isEditMode ? "Update" : "Create",
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
    );
  }
}
