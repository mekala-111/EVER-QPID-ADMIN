import 'dart:typed_data';
import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Features/hostmanagement/model/hostmodel.dart';
import 'package:everqpidadmin/Features/hostmanagement/repo/repo.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/common/widgets/error_msg.dart';
import 'package:everqpidadmin/Settings/utils/date_formatter.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/model/employeesmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostmanagementViewmodel extends ChangeNotifier {
  // -------------------- STATE --------------------
  bool loading = false;
  String? error;

  int _currentPage = 1;
  int get currentPage => _currentPage;
  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  int totalPages = 0;

  // -------------------- DATA --------------------
  List<Host> hostList = [];

  int totalHosts = 0;
  int activeHosts = 0;
  int inactiveHosts = 0;

  // -------------------- EDIT MODE --------------------
  Host? editingHost;
  bool isEditMode = false;
  bool _isInitialized = false;

  // -------------------- FILTERS --------------------
  String? searchKeyword;
  String? status;

  DateTime? fromDate;
  DateTime? toDate;

  final TextEditingController searchTextController = TextEditingController();
  final TextEditingController fromTextController = TextEditingController();
  final TextEditingController toTextController = TextEditingController();

  // -------------------- MULTIPLE IMAGE MANAGEMENT --------------------
  // Store up to 4 images
  final List<Uint8List?> selectedImageBytesList = [null, null, null, null];
  final List<String?> selectedImageNamesList = [null, null, null, null];
  final List<String> uploadedImageUrls = ['', '', '', ''];

  int? uploadingImageIndex; // Track which image is currently uploading

  void setImageAt(int index, Uint8List bytes, String name) {
    if (index >= 0 && index < 4) {
      selectedImageBytesList[index] = bytes;
      selectedImageNamesList[index] = name;
      uploadedImageUrls[index] =
          ''; // Clear uploaded URL when selecting new image
      notifyListeners();
    }
  }

  void setUploadedImageUrlAt(int index, String url) {
    if (index >= 0 && index < 4) {
      uploadedImageUrls[index] = url;
      notifyListeners();
    }
  }

  void removeImageAt(int index) {
    if (index >= 0 && index < 4) {
      selectedImageBytesList[index] = null;
      selectedImageNamesList[index] = null;
      uploadedImageUrls[index] = '';
      notifyListeners();
    }
  }

  void clearAllImages() {
    for (int i = 0; i < 4; i++) {
      selectedImageBytesList[i] = null;
      selectedImageNamesList[i] = null;
      uploadedImageUrls[i] = '';
    }
    uploadingImageIndex = null;
    notifyListeners();
  }

  List<String> getUploadedImageUrlsList() {
    return uploadedImageUrls.where((url) => url.isNotEmpty).toList();
  }

  // -------------------- LANGUAGE MANAGEMENT --------------------
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

  List<String> selectedLanguages = [];

  void toggleLanguage(String language) {
    if (selectedLanguages.contains(language)) {
      selectedLanguages.remove(language);
    } else {
      selectedLanguages.add(language);
    }
    notifyListeners();
  }

  void setLanguages(List<String> languages) {
    selectedLanguages = List.from(languages);
    notifyListeners();
  }

  void clearLanguages() {
    selectedLanguages.clear();
    notifyListeners();
  }

  // -------------------- INTEREST MANAGEMENT --------------------
  final List<String> availableInterests = [
    "Poetry",
    "Sneakers",
    "Freelancing",
    "Photography",
    "Choir",
    "Cosplay",
    "Content Creation",
    "Vintage fashion",
    "Investing",
    "Singing",
    "Language Exchange",
    "Writing",
    "Literature",
    "NFTs",
    "Tattoos",
    "Painting",
    "Upcycling",
    "Entrepreneurship",
    "Acapella",
    "Musical Instrument",
    "Musical Writing",
    "Dancing",
    "Exchange Program",
    "Art",
    "Real Estate",
    "Drawing",
    "Blogging",
    "Fashion",
    "DIY",
    "90s Kid",
    "Comic-con",
    "Harry Potter",
    "NBA",
    "MLB",
    "Dungeons & Dragons",
    "Manga",
    "Marvel",
    "Disney",
    "Maggi",
    "Biryani",
    "Sushi",
    "Foodie",
    "Food tours",
    "Mocktails",
    "Sweet treats",
    "Brunch",
    "Açaí",
    "Street Food",
    "Plant-based",
    "Boba tea",
    "Cocktails",
    "Ice Cream",
    "Coffee",
    "Pho",
    "Wine",
    "Ramen",
    "Korean Food",
    "BBQ",
    "Craft Beer",
    "Tea",
    "Ludo",
    "PlayStation",
    "E-Sports",
    "Fortnite",
    "Xbox",
    "League of Legends",
    "Nintendo",
    "Among Us",
    "Atari",
    "Roblox",
    "Festivals",
    "Stand up Comedy",
    "Escape Rooms",
    "Bars",
    "Thrifting",
    "Museums",
    "Paragliding",
    "Sailing",
    "Hiking",
    "Mountains",
    "Backpacking",
    "Rock Climbing",
    "Fishing",
    "Camping",
    "Outdoors",
    "Picnicking",
    "Instagram",
    "X",
    "SoundCloud",
    "Pinterest",
    "Spotify",
    "Social Media",
    "Vlogging",
    "YouTube",
    "Virtual Reality",
    "Memes",
    "Metaverse",
    "Podcasts",
    "TikTok",
    "Twitch",
    "Netflix",
    "Freeletics",
    "Cricket",
    "Ice Hockey",
    "Sports Shooting",
    "Athletics",
    "Sports",
    "Walking",
    "Beach sports",
    "Fitness classes",
    "Skating",
    "Rugby",
    "Boxing",
    "Badminton",
    "Pilates",
    "Cheerleading",
    "Pole Dancing",
    "Car Racing",
    "Motor Sports",
    "Jogging",
    "Football",
    "Tennis",
    "Skateboarding",
    "Gymnastics",
    "Hockey",
    "Basketball",
    "Running",
    "Gym",
    "Weightlifting",
    "Wrestling",
    "Marathon",
    "Martial Arts",
    "Volleyball",
    "Padel",
    "Equestrian",
    "Soccer",
    "Baseball",
    "Archery",
    "Crossfit",
    "Climbing",
    "Cycling",
    "Swimming",
    "Table Tennis",
    "Working out",
    "Reading",
    "Binge-Watching TV shows",
    "Home Workout",
    "Trivia",
    "Cooking",
    "Online Games",
    "Online Shopping",
    "Animated movies",
    "Crime shows",
    "Drama shows",
    "Fantasy movies",
    "Documentaries",
    "Indie films",
    "Reality TV",
    "Rom-coms",
    "Sports shows",
    "Thriller films",
    "K-drama shows",
    "Horror Movies",
    "Bollywood",
    "Movies",
    "Sci-Fi",
    "Anime",
    "Comedy",
    "Activism",
    "Mental Health Awareness",
    "Voter Rights",
    "Climate Change",
    "LGBTQIA+ Rights",
    "Feminism",
    "Black Lives Matter",
    "Inclusivity",
    "Human Rights",
    "Social Development",
    "Volunteering",
    "Environmentalism",
    "World Peace",
    "Pride",
    "Youth Empowerment",
    "Equality",
    "Politics",
    "Disability Rights",
    "Self Love",
    "Trying New Things",
    "Tarot",
    "Spa",
    "Self Care",
    "Self Development",
    "Meditation",
    "Skincare",
    "Makeup",
    "Astrology",
    "Mindfulness",
    "Sauna",
    "Active Lifestyle",
    "Yoga",
    "Raves",
    "Drive-in Cinema",
    "Musical theater",
    "Cafe hopping",
    "Aquarium",
    "Clubbing",
    "Exhibition",
    "Shopping",
    "Cars",
    "Pub Quiz",
    "Happy hour",
    "Karaoke",
    "House Parties",
    "Theater",
    "Shisha",
    "Rollerskating",
    "Live Music",
    "Bar Hopping",
    "Bowling",
    "Motorcycles",
    "Parties",
    "Nightlife",
    "Art galleries",
    "Film Festival",
    "Pubs",
    "Concerts",
    "Town Festivities",
    "Bhangra",
    "K-Pop",
    "Gospel music",
    "Music bands",
    "Rock music",
    "Soul music",
    "Pop music",
    "Punk rock",
    "Rap music",
    "Folk music",
    "Latin music",
    "Alternative music",
    "Techno",
    "Jazz",
    "House music",
    "EDM",
    "R&B",
    "Indie music",
    "Opera",
    "Heavy Metal",
    "Funk music",
    "Reggaeton",
    "Country Music",
    "Hip Hop",
    "J-Pop",
    "Electronic Music",
    "Grime",
    "90s Britpop",
    "Trap Music",
    "Music",
    "Road Trips",
    "Rowing",
    "Diving",
    "Jetskiing",
    "Walking tours",
    "Nature",
    "Hot Springs",
    "Walking My Dog",
    "Skiing",
    "Canoeing",
    "Snowboarding",
    "Couchsurfing",
    "Free Diving",
    "Travel",
    "Paddle Boarding",
    "Surfing",
    "Beach Bars",
  ];

  List<String> selectedInterests = [];

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
    notifyListeners();
  }

  void setInterests(List<String> interests) {
    selectedInterests = List.from(interests);
    notifyListeners();
  }

  void clearInterests() {
    selectedInterests.clear();
    notifyListeners();
  }

  // -------------------- REPO --------------------
  final HostManagementRepository repo =
      HostManagementRepository(NetworkApiServiceV2());

  // -------------------- API CALL --------------------
  Future<void> getAllHostsFn(BuildContext context) async {
    if (!context.mounted) return;

    try {
      loading = true;
      error = null;
      notifyListeners();

      const int pageSize = 10;

      final result = await repo.getAllHosts(
        pageNumber: currentPage.toString(),
        pageSize: pageSize.toString(),
        searchTag: searchKeyword ?? "",
        fromDate: fromDate != null
            ? formatDateFromDate(dateTime: fromDate!, format: 'yyyy-MM-dd')
            : "",
        toDate: toDate != null
            ? formatDateFromDate(dateTime: toDate!, format: 'yyyy-MM-dd')
            : "",
        status: status ?? "",
      );

      if (result['status'] == true && result['statusCode'] == 200) {
        final data = result['data'];

        if (data != null && data['hosts'] != null) {
          final hosts = data['hosts'] as List;

          // Pagination
          totalPages = data['totalCount'] != null
              ? ((data['totalCount'] / pageSize) as double).ceil()
              : 1;

          // Stats
          totalHosts = data['totalCount'] ?? 0;
          activeHosts = data['activeCount'] ?? 0;
          inactiveHosts = data['inactiveCount'] ?? 0;

          hostList = hosts.map((e) => Host.fromJson(e)).toList();
        } else {
          hostList = [];
          error = 'No hosts found';
        }
      } else {
        hostList = [];
        error = result['message'] ?? 'Failed to fetch hosts';
      }
    } catch (e) {
      hostList = [];
      error = e.toString();
    } finally {
      loading = false;

      if (context.mounted) {
        notifyListeners();
        if (error != null) {
          ErrorMsg.showSnakError(context, error!);
        }
      }
    }
  }

  // -------------------- PAGINATION --------------------
  void nextPage(BuildContext context) {
    if (currentPage < totalPages) {
      currentPage++;
      getAllHostsFn(context);
    }
  }

  void prevPage(BuildContext context) {
    if (currentPage > 1) {
      currentPage--;
      getAllHostsFn(context);
    }
  }

  // -------------------- CLEAR FILTERS --------------------
  void clearFilters(BuildContext context) {
    currentPage = 1;
    searchKeyword = null;
    fromDate = null;
    toDate = null;

    searchTextController.clear();
    fromTextController.clear();
    toTextController.clear();

    notifyListeners();
  }

  // -------------------- INITIALIZE FOR PAGE --------------------
  void initializeForPage(BuildContext context, String? pageStatus) {
    currentPage = 1;
    searchKeyword = null;
    status = pageStatus;
    fromDate = null;
    toDate = null;

    searchTextController.clear();
    fromTextController.clear();
    toTextController.clear();

    getAllHostsFn(context);
  }

  // -------------------- INITIALIZE FOR EDIT --------------------
  void initializeForEdit(Host host) {
    editingHost = host;
    isEditMode = true;
    _isInitialized = true;

    // Set image URLs (handle both single profileImageUrl and array profilePhotos)
    clearAllImages();

    // If host has profilePhotos array
    if (host.profilePhotos.isNotEmpty) {
      for (int i = 0; i < host.profilePhotos.length && i < 4; i++) {
        uploadedImageUrls[i] = host.profilePhotos[i];
      }
    }
    // Fallback to single profileImageUrl if exists
    else if (host.profileImageUrl.isNotEmpty) {
      uploadedImageUrls[0] = host.profileImageUrl;
    }

    // Set languages
    selectedLanguages = List.from(host.otherLanguages);

    // Set interests
    selectedInterests = List.from(host.interests);

    notifyListeners();
  }

  // -------------------- CLEAR EDIT MODE --------------------
  void clearEditMode() {
    editingHost = null;
    isEditMode = false;
    _isInitialized = false;

    // Clear images
    clearAllImages();

    // Clear languages
    clearLanguages();

    // Clear interests
    clearInterests();

    notifyListeners();
  }

  bool get isInitialized => _isInitialized;

  // -------------------- CREATE HOST --------------------
  bool creatingHost = false;

  Future<bool> createHostFn(
    BuildContext context,
    Map<String, dynamic> hostData,
  ) async {
    if (!context.mounted) return false;

    try {
      creatingHost = true;
      error = null;
      notifyListeners();

      // Add languages and interests to host data
      hostData['otherLanguages'] = selectedLanguages;
      hostData['interests'] = selectedInterests;

      // Add profile photos array (only non-empty URLs)
      final photoUrls = getUploadedImageUrlsList();
      if (photoUrls.isNotEmpty) {
        hostData['profilePhotos'] = photoUrls;
        // Set profileImageUrl to the first image
        hostData['profileImageUrl'] = photoUrls[0];
      }

      final result = await repo.createHost(hostData: hostData);

      if (result['status'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Host created successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          clearEditMode();
          context
              .read<WrapperViewModel>()
              .updatePageIndex(GetWrapperPageViewStatus.allhost);
          currentPage = 1;
          await getAllHostsFn(context);
        }

        return true;
      } else {
        error = result['message'] ?? 'Failed to create host';
        if (context.mounted) {
          ErrorMsg.showSnakError(context, error!);
        }
        return false;
      }
    } catch (e) {
      error = e.toString();

      if (context.mounted) {
        ErrorMsg.showSnakError(context, 'Error: ${e.toString()}');
      }
      return false;
    } finally {
      creatingHost = false;
      notifyListeners();
    }
  }

  // -------------------- UPDATE HOST --------------------
  bool updatingHost = false;

  Future<bool> updateHostFn(
    BuildContext context,
    String hostId,
    Map<String, dynamic> hostData,
  ) async {
    if (!context.mounted) return false;

    try {
      updatingHost = true;
      error = null;
      notifyListeners();

      // Add languages and interests to host data
      hostData['otherLanguages'] = selectedLanguages;
      hostData['interests'] = selectedInterests;

      // Add profile photos array (only non-empty URLs)
      final photoUrls = getUploadedImageUrlsList();
      if (photoUrls.isNotEmpty) {
        hostData['profilePhotos'] = photoUrls;
        // Set profileImageUrl to the first image
        hostData['profileImageUrl'] = photoUrls[0];
      }

      final result = await repo.updateHost(
        hostId: hostId,
        hostData: hostData,
      );

      if (result['status'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Host updated successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          clearEditMode();
          context
              .read<WrapperViewModel>()
              .updatePageIndex(GetWrapperPageViewStatus.allhost);
          await getAllHostsFn(context);
        }
        return true;
      } else {
        error = result['message'] ?? 'Failed to update host';
        if (context.mounted) {
          ErrorMsg.showSnakError(context, error!);
        }
        return false;
      }
    } catch (e) {
      error = e.toString();

      if (context.mounted) {
        ErrorMsg.showSnakError(context, 'Error: ${e.toString()}');
      }
      return false;
    } finally {
      updatingHost = false;
      notifyListeners();
    }
  }

  // -------------------- DELETE HOST --------------------
  bool deletingHost = false;

  Future<bool> deleteHostFn(
    BuildContext context,
    String hostId,
  ) async {
    if (!context.mounted) return false;

    try {
      deletingHost = true;
      error = null;
      notifyListeners();

      final result = await repo.deleteHost(hostId: hostId);

      if (result['status'] == true && result['statusCode'] == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Host deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );

          if (hostList.length == 1 && currentPage > 1) {
            currentPage--;
          }
          await getAllHostsFn(context);
        }

        return true;
      } else {
        error = result['message'] ?? 'Failed to delete host';
        if (context.mounted) {
          ErrorMsg.showSnakError(context, error!);
        }
        return false;
      }
    } catch (e) {
      error = e.toString();

      if (context.mounted) {
        ErrorMsg.showSnakError(context, error!);
      }
      return false;
    } finally {
      deletingHost = false;
      notifyListeners();
    }
  }

  // -------------------- IMAGE UPLOAD FOR SPECIFIC INDEX --------------------
  Future<bool> uploadProfileImageAt(BuildContext context, int index) async {
    if (!context.mounted) return false;

    if (index < 0 || index >= 4) {
      return false;
    }

    if (selectedImageBytesList[index] == null ||
        selectedImageNamesList[index] == null) {
      if (context.mounted) {
        ErrorMsg.showSnakError(context, 'No image selected at index $index');
      }
      return false;
    }

    try {
      uploadingImageIndex = index;
      notifyListeners();

      // Determine content type
      String contentType = 'image/jpeg';
      final fileName = selectedImageNamesList[index]!;
      if (fileName.toLowerCase().endsWith('.png')) {
        contentType = 'image/png';
      } else if (fileName.toLowerCase().endsWith('.gif')) {
        contentType = 'image/gif';
      }

      // Get signed URL
      final signedUrl = await repo.profileSignedUrl(
        fileName: fileName,
        fieldName: 'profileImage$index',
      );

      // Upload to S3
      await repo.uploadToSignedUrl(
        signedUrl: signedUrl,
        bytes: selectedImageBytesList[index]!,
        contentType: contentType,
      );

      // Extract the actual file URL (without query parameters)
      uploadedImageUrls[index] = signedUrl.split('?').first;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image ${index + 1} uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      return true;
    } catch (e) {
      if (context.mounted) {
        ErrorMsg.showSnakError(
            context, 'Failed to upload image ${index + 1}: ${e.toString()}');
      }
      return false;
    } finally {
      uploadingImageIndex = null;
      notifyListeners();
    }
  }

  // -------------------- EMPLOYEE MANAGEMENT --------------------
  bool _isEmployeesLoading = false;
  bool get isEmployeesLoading => _isEmployeesLoading;

  List<Employee> employees = [];

  Future<void> getChatEmployees() async {
    try {
      _isEmployeesLoading = true;
      notifyListeners();

      final result = await repo.getchatEmployees();

      if (result['statusCode'] == 200 && result['data'] != null) {
        final EmployeeResponse response = EmployeeResponse.fromJson(result);

        employees = response.data?.employees ?? [];
      } else {
        employees.clear();
      }
    } catch (e) {
      employees.clear();
    } finally {
      _isEmployeesLoading = false;
      notifyListeners();
    }
  }

  Employee? _selectedEmployee;
  Employee? get selectedEmployee => _selectedEmployee;

  String? get selectedEmployeeId => _selectedEmployee?.id;

  void setSelectedEmployee(Employee? employee) {
    _selectedEmployee = employee;
    notifyListeners();
  }

  void clearSelectedEmployee() {
    _selectedEmployee = null;
    notifyListeners();
  }

  // Initialize employee in edit mode
  // Initialize employee in edit mode
  void initializeEmployeeForEdit(String? employeeId) {
    if (employeeId == null || employeeId.isEmpty) {
      _selectedEmployee = null;
      notifyListeners();
      return;
    }

    // ✅ CHECK if employees list is populated
    if (employees.isEmpty) {
      _selectedEmployee = null;
      notifyListeners();
      return;
    }

    try {
      // Find the employee with matching ID from the loaded list
      final employee = employees.firstWhere(
        (emp) => emp.id == employeeId,
        orElse: () => throw Exception('Employee not found'),
      );

      _selectedEmployee = employee;
      notifyListeners();
    } catch (e) {
      _selectedEmployee = null;
      notifyListeners();
    }
  }
}
