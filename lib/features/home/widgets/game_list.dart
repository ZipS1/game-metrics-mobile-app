import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/models/game.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/features/home/services/game_service.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/error_box.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/game_info_row.dart';

class GameList extends StatelessWidget {
  final int? selectedActivityId;
  final Function onTap;

  const GameList(
      {super.key, required this.selectedActivityId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (selectedActivityId == null) {
      return Center(
          child: Text(
        "Не выбрано активности",
        style: gmRegularTextStyle(),
      ));
    }

    return FutureBuilder<List<Game>>(
      future: getGames(selectedActivityId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorBox(
              message: 'Error: ${snapshot.error}',
              productionMessage: 'Не удалось загрузить игры');
        } else if (snapshot.data == null) {
          return const ErrorBox(message: 'Не удалось загрузить игры');
        }

        final games = snapshot.data!;
        if (games.isEmpty) {
          return Center(child: Text('Нет игр'));
        }
        return ListView.separated(
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return InkWell(
              onTap: () => onTap(game.id),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: gameInfoRow(game.startTime, game.duration),
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey,
            thickness: 1,
            height: 16,
          ),
        );
      },
    );
  }
}
