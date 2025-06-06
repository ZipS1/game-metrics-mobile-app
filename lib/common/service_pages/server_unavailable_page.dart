import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/global/snackbar_service.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/common/global/client_service.dart';

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
                      final (connectionOk, message) =
                          await ClientService().ensureAuth();
                      if (!context.mounted) return;
                      if (connectionOk) {
                        Navigator.pop(context);
                      } else {
                        SnackbarService.showFail(message);
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
