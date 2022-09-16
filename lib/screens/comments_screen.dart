import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/resources/firestore_method.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widgets/comment_card.dart';
import 'package:instagramclone/widgets/textfield_comment.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
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
    final User user = Provider.of<UserProvider>(context).getUser;

    return GestureDetector(
      onTap: () => unFocusView(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text('Comments'),
          centerTitle: false,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              cacheExtent: 9999,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => CommentCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(
              left: 16,
              right: 8,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.photoUrl
                  ),
                  radius: 18,
                ),
                TextFieldComment(
                  snap: widget.snap,
                  user: user,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
