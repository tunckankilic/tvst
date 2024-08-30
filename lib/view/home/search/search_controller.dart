import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tvst/models/user.dart';

class SearchController extends GetxController {
  final Rx<List<User>> _usersSearchedList = Rx<List<User>>([]);
  List<User> get usersSearchedList => _usersSearchedList.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const int _searchLimit = 20;
  static const int _minSearchLength = 3;

  Future<void> searchForUser(String textInput) async {
    if (textInput.length < _minSearchLength) {
      _usersSearchedList.value = [];
      return;
    }

    _isLoading.value = true;

    try {
      final sanitizedInput = sanitizeInput(textInput);
      final searchQuery = _firestore
          .collection("users")
          .where("name", isGreaterThanOrEqualTo: sanitizedInput)
          .where("name", isLessThan: sanitizedInput + 'z')
          .limit(_searchLimit);

      final searchStream = searchQuery.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) => User.fromSnap(doc)).toList();
      });

      _usersSearchedList.bindStream(searchStream);
    } catch (error) {
      print("Error searching for users: $error");
      _usersSearchedList.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  String sanitizeInput(String input) {
    // Remove any special characters that could be used for injection
    return input.replaceAll(RegExp(r'[^\w\s]+'), '');
  }

  @override
  void onClose() {
    _usersSearchedList.close();
    super.onClose();
  }
}
