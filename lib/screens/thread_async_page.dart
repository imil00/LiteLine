import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart'; 
import 'package:liteline/utils/helpers.dart'; 

class ThreadAsyncPage extends StatefulWidget {
  const ThreadAsyncPage({super.key});

  @override
  State<ThreadAsyncPage> createState() => _ThreadAsyncPageState();
}

class _ThreadAsyncPageState extends State<ThreadAsyncPage> {
  String _asyncResult = 'No async task run yet.';
  bool _isLoading = false;

  Future<String> _simulateHeavyComputation(int iterations) async {
    int result = 0;
    for (int i = 0; i < iterations; i++) {
      result += i;
    }
    return 'Computation finished with result: $result';
  }

  Future<void> _runAsyncTask() async {
    setState(() {
      _isLoading = true;
      _asyncResult = 'Running async task...';
    });

    try {
      await Future.delayed(const Duration(seconds: 3));
      _asyncResult = 'Async task completed after 3 seconds!';
      showToast(context, 'Async task done!');
    } catch (e) {
      _asyncResult = 'Async task failed: $e';
      showToast(context, 'Async task failed!', backgroundColor: Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _runHeavyTaskOnIsolate() async {
    setState(() {
      _isLoading = true;
      _asyncResult = 'Running heavy computation on isolate...';
    });

    try {
      final result = await compute(_simulateHeavyComputation, 1000000000); 
      _asyncResult = result;
      showToast(context, 'Heavy computation done!');
    } catch (e) {
      _asyncResult = 'Heavy computation failed: $e';
      showToast(context, 'Heavy computation failed!', backgroundColor: Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Threads & Async Tasks'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _asyncResult,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator(color: Colors.blueAccent)
                : Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _runAsyncTask,
                        icon: const Icon(Icons.timer),
                        label: const Text('Run Simple Async Task'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _runHeavyTaskOnIsolate,
                        icon: const Icon(Icons.calculate),
                        label: const Text('Run Heavy Computation (Isolate)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}