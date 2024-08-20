import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tvst/consts/consts_shelf.dart';
import 'package:tvst/models/user.dart';

class SearchScreenController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);
  final RxBool _isLoading = false.obs;
  final RxBool _hasSearched = false.obs;

  List<User> get searchedUsers => _searchedUsers.value;
  bool get isLoading => _isLoading.value;
  bool get hasSearched => _hasSearched.value;

  searchUser(String typedUser) async {
    _isLoading.value = true;
    _hasSearched.value = true;

    if (typedUser.isEmpty) {
      _searchedUsers.value = [];
      _isLoading.value = false;
      return;
    }

    _searchedUsers.bindStream(firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: typedUser)
        .snapshots()
        .map((QuerySnapshot query) {
      List<User> retVal = [];
      for (var elem in query.docs) {
        retVal.add(User.fromSnap(elem));
      }
      _isLoading.value = false;
      return retVal;
    }));
  }

  Future<void> followUser(String uid) async {
    try {
      String myUid = authController.user!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      if ((userDoc.data()! as dynamic)['followers'].contains(myUid)) {
        await firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayRemove([myUid])
        });
        await firestore.collection('users').doc(myUid).update({
          'following': FieldValue.arrayRemove([uid])
        });
      } else {
        await firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayUnion([myUid])
        });
        await firestore.collection('users').doc(myUid).update({
          'following': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      Get.snackbar('Error Following User', e.toString());
    }
  }
}
