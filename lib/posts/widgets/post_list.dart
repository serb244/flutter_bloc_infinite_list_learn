import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/post_bloc.dart';
import 'bottom_loader.dart';
import 'post_list_item.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            return const Center(child: Text('failed to fetch posts'));
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return const Center(child: Text('no posts'));
            }
            return Column(
              children: [
                Container(
                    alignment: Alignment.topCenter,
                    color: Colors.redAccent,
                    height: 200,
                    child: TextButton(
                        onPressed: () {
                          // _scrollController.jumpTo(0);
                          // _scrollController.animateTo(1500,
                          //     duration: const Duration(milliseconds: 300),
                          //     curve: Curves.bounceInOut);
                        },
                        child: const Text('sss'))),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return index >= state.posts.length
                          ? const BottomLoader()
                          : PostListItem(post: state.posts[index]);
                    },
                    itemCount: state.hasReachedMax
                        ? state.posts.length
                        : state.posts.length + 1,
                    controller: _scrollController,
                  ),
                ),
                state.hasReachedMax
                    ? SizedBox(
                        height: 10,
                        child: Text('That all'),
                      )
                    : SizedBox()
              ],
            );
          case PostStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    print('maxScroll = $maxScroll');
    print('currentScroll = $currentScroll');
    return currentScroll >= (maxScroll * 0.9);
  }
}
