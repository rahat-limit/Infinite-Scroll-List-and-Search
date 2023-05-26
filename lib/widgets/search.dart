import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practive/provider/post_provider.dart';

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({super.key});

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: _controller,
      placeholder: 'Search',
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      style: const TextStyle(fontSize: 19),
      onChanged: (text) {
        ref.read(postsProvider.notifier).searchPosts(text);
      },
      // onSubmitted: (value) {
      //   ref.read(postsProvider.notifier).searchPosts(value);
      // },
    );
  }
}
