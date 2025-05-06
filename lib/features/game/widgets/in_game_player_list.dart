import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/models/game_player.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/features/game/widgets/in_game_player_row.dart';

class InGamePlayerList extends StatelessWidget {
  final List<GamePlayer> players;
  final Function onTap;

  const InGamePlayerList(
      {super.key, required this.players, required this.onTap});

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
            return InkWell(
              onTap: () => onTap(player.playerId),
              child: InGamePlayerRow(player: player),
            );
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
      padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Имя', style: gmTitleTextStyle()),
          ),
          Expanded(
            flex: 2,
            child: Text('Вход',
                style: gmTitleTextStyle(), textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 2,
            child: Text('Доп.',
                style: gmTitleTextStyle(), textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
