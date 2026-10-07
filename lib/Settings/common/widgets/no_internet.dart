import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_url.dart';
import 'flutter_toast.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                color: Colors.red.withValues(alpha: .9),
                size: 70,
                semanticLabel: 'No internet connection',
              ),
              const SizedBox(height: 10),
              const Text(
                'Check your internet connection',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              IconButton(
                tooltip: 'Retry connection',
                onPressed: () async {
                  final connected = await InternetChecker.isConnected();
                  if (!context.mounted) return;
                  if (connected) {
                    Navigator.of(context).pop();
                  } else {
                    FlutterToastClass.toast('No internet connection');
                  }
                },
                icon: const Icon(Icons.refresh, size: 30, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InternetChecker {
  InternetChecker._();

  static Future<bool> isConnected() async {
    try {
      final response = await http
          .head(Uri.parse(AppUrl.baseurl))
          .timeout(const Duration(seconds: 5));
      return response.statusCode < 500;
    } catch (_) {
      return false;
    }
  }
}
