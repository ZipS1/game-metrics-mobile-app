import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/models/game_player.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';

class FinishedGamePlayerRow extends StatelessWidget {
  final GamePlayer player;

  const FinishedGamePlayerRow({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    var endPointsColor = player.endPoints > 0
        ? gmPositiveAccentColor
        : player.endPoints == 0
            ? gmTextColor
            : gmNegativeAccentColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              player.name ?? "Имя не загружено",
              style: gmRegularTextStyle(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              player.entryPoints.toString(),
              style: gmPointsTextStyle(),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              player.additionalPoints.toString(),
              style: gmPointsTextStyle(),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              player.endPoints.toString(),
              style: gmScoreTextStyle(endPointsColor),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
