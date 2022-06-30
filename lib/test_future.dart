import 'dart:developer';

import 'package:flutter/material.dart';

class TestFuture extends StatefulWidget {
  const TestFuture({Key key}) : super(key: key);

  @override
  _TestFutureState createState() => _TestFutureState();
}

class _TestFutureState extends State<TestFuture> {
  String name;
  @override
  void initState() {
    log('initState ===> ');
    getName();
    super.initState();
  }

  Future<void> getName() async {
    try {
      log('GetName');
      await Future.delayed(Duration(seconds: 5), () {
        name = 'Text keldi';
      });
      setState(() {});
    } catch (problemanyBer) {
      throw Exception(problemanyBer);
    }
  }

  @override
  Widget build(BuildContext context) {
    log('Build==>');
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(name ?? 'bushbai tur '),
        ),
      ),
    );
  }
}
