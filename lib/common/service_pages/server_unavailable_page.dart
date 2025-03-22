import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/styles/title_text_style.dart';
import 'package:game_metrics_mobile_app/features/auth/services/client_service.dart';

class ServerUnavailablePage extends StatefulWidget {
  const ServerUnavailablePage({super.key});

  @override
  State<ServerUnavailablePage> createState() => _ServerUnavailablePageState();
}

class _ServerUnavailablePageState extends State<ServerUnavailablePage> {
  bool isCheckingConnection = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Сервер недоступен",
              style: gmTitleTextStyle(),
            ),
            isCheckingConnection
                ? const CircularProgressIndicator()
                : IconButton(
                    icon: const Icon(
                      Icons.restart_alt_outlined,
                      size: 50,
                    ),
                    onPressed: () async {
                      setState(() {
                        isCheckingConnection = true;
                      });
                      final connectionOk = await ClientService().ensureAuth();
                      if (!context.mounted) return;
                      if (connectionOk) {
                        Navigator.pop(context);
                      }
                      setState(() {
                        isCheckingConnection = false;
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
