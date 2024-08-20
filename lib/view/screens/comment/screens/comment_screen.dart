import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tvst/consts/consts_shelf.dart';
import 'package:tvst/view/screens/comment/comment_controller.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends GetView<CommentController> {
  final String id;
  CommentScreen({super.key, required this.id});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.updatePostId(id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Comments',
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 20.sp)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.comments.length,
                itemBuilder: (context, index) {
                  final comment = controller.comments[index];
                  return _buildCommentTile(comment, context);
                },
              );
            }),
          ),
          _buildCommentInput(context),
        ],
      ),
    );
  }

  Widget _buildCommentTile(dynamic comment, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundImage: NetworkImage(comment.profilePhoto),
        radius: 20.r,
      ),
      title: Wrap(
        children: [
          Text(
            "${comment.username}  ",
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            comment.comment,
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Row(
          children: [
            Text(
              tago.format(comment.datePublished.toDate()),
              style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '${comment.likes.length} likes',
              style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            )
          ],
        ),
      ),
      trailing: IconButton(
        onPressed: () => controller.likeComment(comment.id),
        icon: Icon(
          Icons.favorite,
          size: 25.sp,
          color: comment.likes.contains(authController.user!.uid)
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color),
                border: InputBorder.none,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                controller.postComment(_controller.text);
                _controller.clear();
              }
            },
            child: Text(
              'Post',
              style: TextStyle(
                fontSize: 16.sp,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
