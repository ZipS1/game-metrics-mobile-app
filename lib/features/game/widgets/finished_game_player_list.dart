import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/models/game_player.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/features/game/widgets/finished_game_player_row.dart';

class FinishedGamePlayerList extends StatelessWidget {
  final List<GamePlayer> players;

  const FinishedGamePlayerList({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return FinishedGamePlayerRow(player: player);
          },
          separatorBuilder: (context, index) => const Divider(
            color: Colors.grey,
            thickness: 1,
            height: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Имя', style: gmHeaderTextStyle()),
          ),
          Expanded(
            flex: 2,
            child: Text('Вход+',
                style: gmHeaderTextStyle(), textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 2,
            child: Text('Выход',
                style: gmHeaderTextStyle(), textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 2,
            child: Text('Дельта',
                style: gmHeaderTextStyle(), textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
