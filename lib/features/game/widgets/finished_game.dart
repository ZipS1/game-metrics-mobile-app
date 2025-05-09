import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/models/game.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/common/styles/widget_styles.dart';
import 'package:game_metrics_mobile_app/features/game/widgets/finished_game_player_list.dart';

Widget finishedGame(Game game, Function onPlayerClick,
    VoidCallback onFinishGameClick, String durationString) {
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
            child: FinishedGamePlayerList(
              players: game.players,
            ),
          ),
          Text(
            "Игра окончена!\nДлительность: $durationString",
            style: gmTitleTextStyle(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
