import 'package:flutter/material.dart';
import 'package:instagramclone/screens/add_post_screen.dart';
import 'package:instagramclone/screens/feed_screen.dart';

const webScreenSize = 600;

const homeScreenItem = [
  FeedScreen(),
  Text('search'),
  AddPostScreen(),
  Text('noti'),
  Text('profile'),
];