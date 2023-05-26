import 'package:flutter/material.dart';
import 'package:riverpod_practive/widgets/list.dart';
import 'package:riverpod_practive/widgets/search.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SearchWidget(), List()],
        ),
      )),
    );
  }
}
