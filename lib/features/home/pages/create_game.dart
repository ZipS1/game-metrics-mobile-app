import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/global/snackbar_service.dart';
import 'package:game_metrics_mobile_app/common/models/player.dart';
import 'package:game_metrics_mobile_app/common/styles/widget_styles.dart';
import 'package:game_metrics_mobile_app/common/widgets/app_bar.dart';
import 'package:game_metrics_mobile_app/features/home/services/game_service.dart';
import 'package:game_metrics_mobile_app/features/home/services/players_service.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/error_box.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/player_score_tap_list.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/title_box.dart';

class CreateGamePage extends StatefulWidget {
  final int activityId;

  const CreateGamePage({super.key, required this.activityId});

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  late final Future<List<Player>> _playersFuture;
  late List<Player> availablePlayers;
  late List<Player> choosenPlayers;
  bool _isDataLoaded = false;

  final TextEditingController _pointsController = TextEditingController();
  String? _pointsError;

  @override
  void initState() {
    super.initState();
    availablePlayers = [];
    choosenPlayers = [];
    _playersFuture = getPlayers(widget.activityId);
  }

  void onAvailablePlayerTap(int playerId) {
    setState(() {
      final player = availablePlayers.firstWhere((p) => p.id == playerId);
      availablePlayers.remove(player);
      choosenPlayers.add(player);
    });
  }

  void onChoosenPlayerTap(int playerId) {
    setState(() {
      final player = choosenPlayers.firstWhere((p) => p.id == playerId);
      choosenPlayers.remove(player);
      availablePlayers.add(player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: gmPrimaryBackgroundColor,
      body: FutureBuilder(
        future: _playersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorBox(
              message: 'Error: ${snapshot.error}',
              productionMessage: 'Не удалось загрузить игроков',
            );
          } else if (snapshot.data == null) {
            return const ErrorBox(message: 'Не удалось загрузить игроков');
          }

          if (snapshot.hasData && !_isDataLoaded) {
            availablePlayers = snapshot.data!.toList();
            _isDataLoaded = true;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 30,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 20,
                        children: [
                          TitleBox(
                            title: "Доступно",
                          ),
                          Container(
                              width: double.infinity,
                              height: 300,
                              decoration: gmBoxDecoration(),
                              padding: EdgeInsets.all(20),
                              child: PlayerTapList(
                                  players: availablePlayers,
                                  onTap: onAvailablePlayerTap)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 20,
                        children: [
                          TitleBox(title: "В игре"),
                          Container(
                              width: double.infinity,
                              height: 300,
                              decoration: gmBoxDecoration(),
                              padding: EdgeInsets.all(20),
                              child: PlayerTapList(
                                  players: choosenPlayers,
                                  onTap: onChoosenPlayerTap)),
                        ],
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _pointsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Начальные очки',
                    errorText: _pointsError,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      final points = int.tryParse(value);
                      _pointsError = (points == null || points < 0)
                          ? 'Введите неотрицательное число'
                          : null;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    final points = int.tryParse(_pointsController.text);
                    setState(() {
                      if (points == null || points < 0) {
                        _pointsError = 'Введите неотрицательное число';
                        return;
                      }
                    });

                    if (choosenPlayers.isEmpty) {
                      SnackbarService.showFail(
                          'Выберите хотя бы одного игрока');
                      return;
                    }

                    String? message;
                    try {
                      message = await createGame(
                          widget.activityId, choosenPlayers, points!);
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
                  child: const Text(
                    'Начать игру',
                    style: TextStyle(
                      color: gmTextColorAlternative,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
