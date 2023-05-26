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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Infinite Scroll List and Search',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                SizedBox(width: 10),
                Image(
                  image: AssetImage('assets/searching.png'),
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            SearchWidget(),
            List()
          ],
        ),
      )),
    );
  }
}
