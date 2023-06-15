import 'dart:math';

import 'package:flutter/material.dart';

import 'package:native_tamplate/native_template.dart' as native_template;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int num = 0;
  int fib = 0;
  int fac = 0;

  Widget get space => const SizedBox(height: 16);

  @override
  void initState() {
    num = Random().nextInt(10);
    fib = native_template.fibonacci(num);
    fac = native_template.factorial(num);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Number: $num"),
            space,
            Text("Fibonacci: $fib"),
            space,
            Text("Factorial: $fac"),
            space,
            ElevatedButton(
              onPressed: () {
                setState(() {
                  num = Random().nextInt(10);
                  fib = native_template.fibonacci(num);
                  fac = native_template.factorial(num);
                });
              },
              child: const Text("Get Calculation"),
            )
          ],
        ),
      ),
    );
  }
}
