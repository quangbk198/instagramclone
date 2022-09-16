import 'package:flutter/material.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/resources/firestore_method.dart';
import 'package:instagramclone/utils/utils.dart';

class TextFieldComment extends StatefulWidget {
  final snap;
  final User user;
  const TextFieldComment({Key? key, required this.snap, required this.user}) : super(key: key);

  @override
  State<TextFieldComment> createState() => _TextFieldCommentState();
}

class _TextFieldCommentState extends State<TextFieldComment> {
  final TextEditingController _commentController = TextEditingController();
  bool isEmptyTextField = true;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_getComment);
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  void _getComment() {
    if (_commentController.text.trim().isEmpty) {
      setState(() {
        isEmptyTextField = true;
      });
    } else {
      setState(() {
        isEmptyTextField = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 8,
              ),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Comment as ${widget.user.username}',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (_commentController.text.isNotEmpty) {
                FirestoreMethod().postComment(
                  widget.snap['postId'],
                  _commentController.text,
                  widget.user.uid,
                  widget.user.username,
                  widget.user.photoUrl,
                );
                unFocusView();
                _commentController.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: isEmptyTextField
                  ? const Icon(
                      Icons.send,
                      color: Colors.grey,
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.blueAccent,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
