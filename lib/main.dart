import 'dart:math';

import 'package:chuong3/components/body_item.dart';
import 'package:chuong3/components/cover_item.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define3 the default brightness and colors.
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
            color: Colors.black54,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            )),
      ),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> listData = [1, 1, 1, 1, 1, 1];
  final ScrollController _controller = ScrollController();
  bool _loading = false;

  @override
  void initState() {
    _controller.addListener(_onScroll);
  }

  void loadMore() async {
    Future.delayed(const Duration(seconds: 1), () {
      List<int> list = listData;
      list.addAll([Random().nextInt(4), Random().nextInt(4)]);
      setState(() {
        listData = list;
        _loading = false;
      });
    });
  }

  Future<void> _onScroll() async {
    if (!_controller.hasClients || _loading) return;
    final thresholdReached =
        _controller.position.pixels - _controller.position.maxScrollExtent >
            100;
    if (thresholdReached) {
      // Load more!
      setState(() {
        _loading = true;
      });
      loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Salad',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        leading: const Icon(
          Icons.arrow_back_sharp,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.search,
            ),
          )
        ],
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox.expand(
        child: RefreshIndicator(
          onRefresh: () async {
            List<int> list = [];
            list.addAll([
              Random().nextInt(5),
              Random().nextInt(5),
              Random().nextInt(5),
              Random().nextInt(5),
              Random().nextInt(5),
              Random().nextInt(5)
            ]);
            setState(() {
              listData = list;
            });
            return;
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20),
            controller: _controller,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return const CoverItem();
                    },
                    itemCount: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sort by',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Row(
                        children: const [
                          Text(
                            'Most popular',
                            style: TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.sort,
                            color: Colors.pink,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listData.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2 / 3,
                    ),
                    itemBuilder: (context, index) {
                      return BodyItem(index: listData[index]);
                    }),
                _loading
                    ? Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
