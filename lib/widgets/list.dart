import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practive/provider/post_provider.dart';
import 'package:synchronized/synchronized.dart';

class List extends ConsumerStatefulWidget {
  const List({super.key});

  @override
  ConsumerState<List> createState() => _ListState();
}

class _ListState extends ConsumerState<List> {
  final ScrollController _controller = ScrollController();
  var lock = Lock();

  bool status = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = ref.read(postsProvider.notifier);

    _controller.addListener(() async {
      await lock.synchronized(() async {
        if (_controller.position.pixels >
            _controller.position.maxScrollExtent) {
          await Future.delayed(const Duration(seconds: 2), () {
            provider.loadMorePost();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            await ref.read(postsProvider.notifier).refresh();
          },
          child: SizedBox(
            height: 300,
            child: Consumer(builder: (context, ref, child) {
              bool isLoading = ref.watch(postsProvider).isLoading;
              final bool isError = ref.watch(postsProvider).isLoadMoreError;
              final posts = ref.watch(postsProvider).posts;
              final searchPosts = ref.watch(postsProvider).search;
              if (searchPosts.isNotEmpty) {
                return ListView.builder(
                  controller: _controller,
                  itemCount: searchPosts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == searchPosts.length) {
                      if (isError) {
                        return const Center(
                            child: Text('Oops, we have some problems:('));
                      }
                      if (isLoading) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }
                    return ListTile(
                      title: Text(searchPosts[index].firstName),
                      subtitle: Text(searchPosts[index].email),
                      trailing: Text(searchPosts[index].id.toString()),
                    );
                  },
                );
              }
              return ListView.builder(
                controller: _controller,
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    if (isError) {
                      return const Center(
                          child: Text('Oops, we have some problems:('));
                    }
                    if (isLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }
                  return ListTile(
                    title: Text(posts[index].firstName),
                    subtitle: Text(posts[index].email),
                    trailing: Text(posts[index].id.toString()),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
    // },
    // );
  }
}
