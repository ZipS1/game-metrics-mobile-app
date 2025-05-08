import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/models/game.dart';
import 'package:game_metrics_mobile_app/common/models/game_player.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/common/styles/widget_styles.dart';
import 'package:game_metrics_mobile_app/common/widgets/app_bar.dart';
import 'package:game_metrics_mobile_app/features/game/pages/add_points.dart';
import 'package:game_metrics_mobile_app/features/game/pages/finish_game.dart';
import 'package:game_metrics_mobile_app/features/game/services/game_service.dart';
import 'package:game_metrics_mobile_app/features/game/widgets/in_game_player_list.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/error_box.dart';

class GamePage extends StatefulWidget {
  final int gameId;

  const GamePage({super.key, required this.gameId});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Future<Game> getGameFuture;
  late Game game;
  late Duration _displayedDuration;
  Timer? _timer;

  bool _isGameLoaded = false;

  @override
  void initState() {
    super.initState();
    getGameFuture = getGame(widget.gameId);
  }

  @override
  void dispose() {
    _stopDurationTimer();
    super.dispose();
  }

  void _startDurationTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _displayedDuration = DateTime.now().difference(game.startTime);
      });
    });
  }

  void _stopDurationTimer() {
    _timer?.cancel();
  }

  Future<void> onRefresh() async {
    setState(() {
      _isGameLoaded = false;
      getGameFuture = getGame(widget.gameId);
    });
  }

  onPlayerClick(GamePlayer player) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddPointsPage(gameId: widget.gameId, player: player),
        fullscreenDialog: true,
      ),
    );

    if (result == 'success') {
      setState(() {
        _isGameLoaded = false;
        getGameFuture = getGame(widget.gameId);
      });
    }
  }

  onFinishGameClick() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinishGamePage(
          gameId: game.id,
          players: game.players,
        ),
        fullscreenDialog: true,
      ),
    );
    if (result == 'success') {
      setState(() {
        _isGameLoaded = false;
        getGameFuture = getGame(widget.gameId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: gmPrimaryBackgroundColor,
      body: RefreshIndicator(
          onRefresh: onRefresh,
          child: FutureBuilder<Game>(
              future: getGameFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return ErrorBox(
                    message: 'Error: ${snapshot.error}',
                    productionMessage: 'Не удалось загрузить игру',
                  );
                } else if (snapshot.data == null) {
                  return ErrorBox(message: 'Не удалось загрузить игру');
                }

                if (!_isGameLoaded) {
                  game = snapshot.data!;
                  _isGameLoaded = true;
                  if (game.duration.inSeconds == 0) {
                    _displayedDuration =
                        DateTime.now().difference(game.startTime);
                    _startDurationTimer();
                  } else {
                    _displayedDuration = game.duration;
                    _stopDurationTimer();
                  }
                }

                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 30,
                      children: [
                        Container(
                          height: 400,
                          padding: EdgeInsets.all(20),
                          decoration: gmBoxDecoration(),
                          child: InGamePlayerList(
                            players: game.players,
                            onTap: onPlayerClick,
                          ),
                        ),
                        Text(
                          _formatDuration(_displayedDuration),
                          style: gmTitleTextStyle(),
                        ),
                        ElevatedButton(
                          onPressed: onFinishGameClick,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gmAccentColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          child: const Text(
                            'Завершить игру',
                            style: TextStyle(
                              color: gmTextColorAlternative,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}

String _formatDuration(Duration duration) {
  final hours = duration.inHours.toString().padLeft(2, '0');
  final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}
