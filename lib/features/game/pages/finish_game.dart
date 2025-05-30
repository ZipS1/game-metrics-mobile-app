import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/global/snackbar_service.dart';
import 'package:game_metrics_mobile_app/common/models/game_player.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/common/styles/widget_styles.dart';
import 'package:game_metrics_mobile_app/common/widgets/app_bar.dart';
import 'package:game_metrics_mobile_app/features/game/services/game_service.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/title_box.dart';

class FinishGamePage extends StatefulWidget {
  final int gameId;
  final List<GamePlayer> players;

  const FinishGamePage({
    super.key,
    required this.gameId,
    required this.players,
  });

  @override
  State<FinishGamePage> createState() => _FinishGamePageState();
}

class _FinishGamePageState extends State<FinishGamePage> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.players.map((p) {
      final controller = TextEditingController(text: p.endPoints.toString());
      controller.addListener(() {
        setState(() {});
      });
      return controller;
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  int get _expectedTotal => widget.players
      .fold(0, (sum, p) => sum + p.entryPoints + p.additionalPoints);

  int get _enteredTotal {
    int sum = 0;
    for (final c in _controllers) {
      final v = int.tryParse(c.text);
      if (v != null) sum += v;
    }
    return sum;
  }

  bool _validateAllFields() {
    bool valid = true;
    for (final c in _controllers) {
      final v = int.tryParse(c.text);
      if (v == null || v < 0) {
        valid = false;
        break;
      }
    }
    return valid && (_enteredTotal == _expectedTotal);
  }

  Future<void> _onSubmit() async {
    bool formValid = _formKey.currentState!.validate();
    bool totalsValid = _validateAllFields();

    if (!formValid || !totalsValid) {
      SnackbarService.showFail(
          "Сумма итоговых очков ($_enteredTotal) ≠ ожидаемой ($_expectedTotal)");
      return;
    }

    final updatedPlayers = <GamePlayer>[];
    for (int i = 0; i < widget.players.length; i++) {
      updatedPlayers.add(GamePlayer(
        playerId: widget.players[i].playerId,
        entryPoints: widget.players[i].entryPoints,
        additionalPoints: widget.players[i].additionalPoints,
        endPoints: int.parse(_controllers[i].text),
        gameId: widget.players[i].gameId,
      ));
    }

    String? message;
    try {
      message = await finishGame(widget.gameId, updatedPlayers);
      SnackbarService.showSuccess(message);
      if (mounted) Navigator.pop(context, 'success');
    } catch (e) {
      SnackbarService.showFail(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: gmPrimaryBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                TitleBox(title: "Завершение игры"),
                Container(
                    padding: EdgeInsets.all(16),
                    decoration: gmBoxDecoration(),
                    child: _buildPlayerList()),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: gmBoxDecoration(),
                  child: Text(
                    "Ожидаемая сумма: $_expectedTotal\nВведено: $_enteredTotal",
                    style: gmRegularTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gmAccentColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Text(
                    "Подтвердить завершение",
                    style: TextStyle(
                      color: gmTextColorAlternative,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerList() {
    return Column(
      children: [
        _buildHeader(),
        ...List.generate(widget.players.length, (index) {
          final player = widget.players[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(player.name ?? '', style: gmRegularTextStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('${player.entryPoints}',
                      style: gmRegularTextStyle(), textAlign: TextAlign.right),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text('${player.additionalPoints}',
                        style: gmRegularTextStyle(),
                        textAlign: TextAlign.right),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Итог',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите итог';
                      }
                      final v = int.tryParse(value);
                      if (v == null || v < 0) {
                        return 'Неотрицательное число';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Имя', style: gmTitleTextStyle())),
          Expanded(
              flex: 2,
              child: Text('Вход',
                  style: gmTitleTextStyle(), textAlign: TextAlign.right)),
          Expanded(
              flex: 2,
              child: Text('Доп.',
                  style: gmTitleTextStyle(), textAlign: TextAlign.right)),
          Expanded(
              flex: 2,
              child: Text('Итог',
                  style: gmTitleTextStyle(), textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}
