import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/models/player.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/features/home/services/players_service.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/player_score_row.dart';

class PlayerList extends StatelessWidget {
  final int? selectedActivityId;

  const PlayerList({
    super.key,
    required this.selectedActivityId,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedActivityId == null) {
      return Center(
          child: Text(
        "Не выбрано активности",
        style: gmRegularTextStyle(),
      ));
    }

    return FutureBuilder<List<Player>>(
      future: getPlayers(selectedActivityId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('Не удалось загрузить игроков'));
        }

        final players = snapshot.data!;
        if (players.isEmpty) {
          return const Center(child: Text('Нет игроков'));
        }

        return ListView.separated(
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return playerScoreRow(player.name, player.score);
          },
          separatorBuilder: (context, index) => const Divider(
            color: Colors.grey,
            thickness: 1,
            height: 16,
          ),
        );
      },
    );
  }
}
