import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Counter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int opencounter = 0;
  int closecounter = 0;
  int backgroundcounter = 0;
  Timer? openTimer;
  Timer? backgroundTimer;
  Timer? closeTimer;

  @override
  void initState() {
    super.initState();

    // Start open timer
    openTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        opencounter++;
      });
    });

    // Add observer to listen for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Cancel any running timers
    openTimer?.cancel();
    backgroundTimer?.cancel();
    closeTimer?.cancel();

    // Remove observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Logger().i("Change");
    if (state == AppLifecycleState.paused) {
      Logger().i("paused");
      // App is in the background
      startBackgroundTimer();
    } else if (state == AppLifecycleState.resumed) {
      Logger().i("resumed");
      // App is back in the foreground
      stopBackgroundTimer();
    } else if (state == AppLifecycleState.detached) {
      Logger().i("detached");
      // App is closed
      startCloseTimer();
    }
  }

  void startBackgroundTimer() {
    backgroundTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        backgroundcounter++;
      });
    });
  }

  void stopBackgroundTimer() {
    backgroundTimer?.cancel();
  }

  void startCloseTimer() {
    closeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        closecounter++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            const Text(
              'Open Counter',
            ),
            Text(
              "$opencounter",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Spacer(),
            const Text(
              'Background Counter',
            ),
            Text(
              "$backgroundcounter",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Spacer(),
            const Text(
              'Close Counter',
            ),
            Text(
              "$closecounter",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          didChangeAppLifecycleState(AppLifecycleState.detached);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // T
    );
  }
}
