import 'package:flutter/material.dart';
import 'posts/view/posts.dart';

// class App extends MaterialApp {
//   const App({super.key}) : super(home: const PostsPage());
// }
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PostsPage(),
    );
  }
}
