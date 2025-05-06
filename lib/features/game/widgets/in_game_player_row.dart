import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/models/game_player.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';

class InGamePlayerRow extends StatelessWidget {
  final GamePlayer player;

  const InGamePlayerRow({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
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
        ],
      ),
    );
  }
}
