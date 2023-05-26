import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practive/modes/post_model.dart';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_practive/services/api_service.dart';

part 'post_provider.freezed.dart';

@freezed
abstract class PostState with _$PostState {
  const factory PostState({
    @Default(1) int page,
    @Default([]) List<Post> posts,
    @Default([]) List<Post> search,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadMoreError,
    @Default(false) bool isLoadMoreDone,
  }) = _PostState;

  const PostState._();
}

final postsProvider = StateNotifierProvider<PostNotifier, PostState>((ref) {
  return PostNotifier();
});

class PostNotifier extends StateNotifier<PostState> {
  PostNotifier() : super(PostState()) {
    initPosts(1);
  }
  initPosts(initPage, [safe = false]) async {
    final page = initPage ?? state.page;
    final posts = await ApiService().init(page);

    if (posts == null) {
      state = state.copyWith(page: page, isLoading: false);
      return;
    }

    print('get post is ${posts.length}');
    state = state.copyWith(
        page: page,
        isLoading: false,
        posts: safe ? posts : [...state.posts, ...posts]);
    print(state.isLoading);
  }

  searchPosts(String key) {
    final List<Post> posts = state.posts
        .where((element) => element.firstName.contains(key))
        .toList();
    if (posts.isEmpty) {
      return;
    } else {
      state =
          state.copyWith(isLoadMoreDone: true, isLoading: false, search: posts);
      return;
    }
  }

  Future refresh() async {
    initPosts(1, true);
  }

  loadMorePost() async {
    state = state.copyWith(
        isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);

    final posts = await ApiService().init(state.page + 1);

    // ------------------------------ No element Left
    if (posts == 1) {
      state = state.copyWith(isLoading: false, isLoadMoreError: false);
      return;
    }

    // ------------------------------ Error appeard
    if (posts == null) {
      state = state.copyWith(isLoadMoreError: true, isLoading: false);
      return;
    }
    // ------------------------------ Succeded
    if (posts is List<Post>) {
      state = state.copyWith(
          page: state.page + 1,
          isLoading: false,
          isLoadMoreDone: posts.isEmpty,
          posts: [...state.posts, ...posts]);
    }
  }
}
