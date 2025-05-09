import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/models/game.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/common/styles/widget_styles.dart';
import 'package:game_metrics_mobile_app/features/game/widgets/in_game_player_list.dart';

Widget gameInProgress(Game game, Function onPlayerClick,
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
            child: InGamePlayerList(
              players: game.players,
              onTap: onPlayerClick,
            ),
          ),
          Text(
            durationString,
            style: gmTitleTextStyle(),
          ),
          ElevatedButton(
            onPressed: onFinishGameClick,
            style: ElevatedButton.styleFrom(
              backgroundColor: gmAccentColor,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
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
}
