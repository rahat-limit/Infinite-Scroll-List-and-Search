import 'dart:math';

import 'package:dio/dio.dart';
import 'package:riverpod_practive/modes/post_model.dart';

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
