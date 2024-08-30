import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tvst/view/comments/comments_controller.dart';

class CommentsScreen extends GetView<CommentsController> {
  final String videoID;

  CommentsScreen({Key? key, required this.videoID}) : super(key: key);

  final TextEditingController _commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.updateCurrentVideoID(videoID);

    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: Column(
        children: [
          Expanded(child: _buildCommentsList()),
          _buildCommentBox(),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.listOfComments.isEmpty) {
        return const Center(child: Text('No comments yet'));
      }
      return ListView.builder(
        itemCount: controller.listOfComments.length,
        itemBuilder: (context, index) {
          final comment = controller.listOfComments[index];
          return _buildCommentCard(comment);
        },
      );
    });
  }

  Widget _buildCommentCard(dynamic comment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(comment.userProfileImage ?? ''),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.userName ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(comment.commentText ?? ''),
          ],
        ),
        subtitle: Row(
          children: [
            Text(timeago.format(comment.publishedDateTime ?? DateTime.now())),
            const SizedBox(width: 10),
            Text('${comment.commentLikesList?.length ?? 0} likes'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.favorite,
            color: _isCommentLiked(comment) ? Colors.red : Colors.grey,
          ),
          onPressed: () =>
              controller.likeUnlikeComment(comment.commentID ?? ''),
        ),
      ),
    );
  }

  bool _isCommentLiked(dynamic comment) {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    return currentUserID != null &&
        comment.commentLikesList != null &&
        comment.commentLikesList.contains(currentUserID);
  }

  Widget _buildCommentBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentTextController,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submitComment,
          ),
        ],
      ),
    );
  }

  void _submitComment() {
    final commentText = _commentTextController.text.trim();
    if (commentText.isNotEmpty) {
      controller.saveNewCommentToDatabase(commentText);
      _commentTextController.clear();
    }
  }
}
