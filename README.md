# Infinite Scroll List and Search
<p align="center">
<img src="https://riverpod.dev/ru/img/cover.png" with=500>
</p>

<p align="center">
  <img src = "https://github.com/rahat-limit/Infinite-Scroll-List-and-Search/blob/master/assets/simulator_screenshot_71614016-C698-4EC7-A612-AAEE2357B95B.png" width=200>
   <img src = "https://github.com/rahat-limit/Infinite-Scroll-List-and-Search/blob/master/assets/simulator_screenshot_4EE87418-7023-4CE9-9D17-63B3E280C39E.png" width=200>
</p>

#Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.3.6
  cupertino_icons: ^1.0.2
  dio: ^5.1.2
  freezed_annotation: ^2.2.0
  synchronized: ^3.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  freezed: ^2.3.4
  build_runner: ^2.4.4
```

## How to integrate
### API Calls
```dart
const sourcePath = 'https://dummyjson.com/users';

class ApiService {
  final dio = Dio();
  Future init([page = 0, perpage = 5]) async {
    final List<Post> data = [];
    final int pages = page * perpage;
    final response = await dio.get(sourcePath);
    if (response.statusCode == 200) {
      if (pages > response.data['users'].length) {
        print('no elements');
        return 1; //No elements left
      } else if (page == 0) {
        for (var elem in response.data['users']) {
          final post = Post.fromJsonMap(elem as Map<String, dynamic>);
          data.add(post);
        }
        return data;
      } else {
        List<dynamic> elements = response.data['users'];
        for (var elem
            in elements.sublist(max(perpage * (page - 1), 0), pages)) {
          final post = Post.fromJsonMap(elem as Map<String, dynamic>);
          data.add(post);
        }
        return data;
      }
    } else {
      return null;
    }
  }
}
```
### State for All Posts 
```dart

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
    // ------------------------------ Go through all posts to find item by key
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
    // ------------------------------ Load init page
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
```
### Post Model
```dart
class Post {
  final int id;
  final String firstName;
  final String email;

  Post.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        firstName = map["firstName"],
        email = map["email"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['firstName'] = firstName;
    data['email'] = email;
    return data;
  }
}
```
