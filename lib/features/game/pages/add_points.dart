import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/global/snackbar_service.dart';
import 'package:game_metrics_mobile_app/common/models/game_player.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/common/styles/widget_styles.dart';
import 'package:game_metrics_mobile_app/common/widgets/app_bar.dart';
import 'package:game_metrics_mobile_app/features/game/services/game_service.dart';

class AddPointsPage extends StatefulWidget {
  final int gameId;
  final GamePlayer player;

  const AddPointsPage({super.key, required this.gameId, required this.player});

  @override
  State<AddPointsPage> createState() => _AddPointsPageState();
}

class _AddPointsPageState extends State<AddPointsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pointsController = TextEditingController();

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: gmPrimaryBackgroundColor,
      body: Center(
        child: Container(
            width: 300,
            padding: const EdgeInsets.all(20.0),
            decoration: gmBoxDecoration(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Добавить очки игроку ${widget.player.name ?? ""}".trim(),
                    style: gmTitleTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _pointsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        labelText: 'Дополнительные очки',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Введите положительное число';
                      }
                      final points = int.tryParse(value!);
                      return (points == null || points <= 0)
                          ? 'Введите положительное число'
                          : null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      try {
                        int points = int.parse(_pointsController.text);

                        String? message;
                        message = await addPointsToPlayer(
                            widget.gameId, widget.player.playerId, points);
                        SnackbarService.showSuccess(message);
                      } catch (e) {
                        SnackbarService.showFail(
                            e.toString().replaceFirst("Exception: ", ""));
                      }

                      if (!mounted) return;

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, 'success');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gmAccentColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Text(
                      "Добавить очки",
                      style: TextStyle(
                        color: gmTextColorAlternative,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
