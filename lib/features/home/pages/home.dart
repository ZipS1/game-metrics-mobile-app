import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/models/activity.dart';
import 'package:game_metrics_mobile_app/common/models/game.dart';
import 'package:game_metrics_mobile_app/common/models/player.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/common/widgets/app_bar.dart';
import 'package:game_metrics_mobile_app/common/widgets/box_decoration.dart';
import 'package:game_metrics_mobile_app/features/home/services/activities_service.dart';
import 'package:game_metrics_mobile_app/features/home/services/game_service.dart';
import 'package:game_metrics_mobile_app/features/home/services/players_service.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/activity_dropdown.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/game_info_row.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/player_score_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Activity> activities;
  int? selectedActivityId;

  @override
  void initState() {
    super.initState();
    selectedActivityId = null;
  }

  void _onActivityChanged(int activityId) {
    setState(() {
      selectedActivityId = activityId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: gmPrimaryBackgroundColor,
      body: FutureBuilder<List<Activity>>(
        future: getActivities(),
        builder: (context, activitiesSnapshot) {
          if (activitiesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (activitiesSnapshot.hasError || activitiesSnapshot.data == null) {
            return Center(child: Text('Failed to load activities'));
          }

          activities = activitiesSnapshot.data!;
          selectedActivityId ??= activities.first.id;

          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActivityDropdown(
                  selectedActivityId: selectedActivityId!,
                  activities: activities,
                  onChanged: _onActivityChanged,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Row(
                    children: [
                      // Players Column
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: gmBoxDecoration(),
                              child: Text(
                                "Игроки",
                                style: gmTitleTextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: FutureBuilder<List<Player>>(
                                future: getPlayers(selectedActivityId!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasError ||
                                      snapshot.data == null) {
                                    return Center(
                                        child: Text(
                                            'Не удалось загрузить игроков'));
                                  }
                                  final players = snapshot.data!;
                                  if (players.isEmpty) {
                                    return Center(child: Text('Нет игроков'));
                                  }
                                  return ListView.separated(
                                    itemCount: players.length,
                                    itemBuilder: (context, index) {
                                      final player = players[index];
                                      return playerScoreRow(
                                          player.name, player.score);
                                    },
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                      height: 16,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      // Games Column
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: gmBoxDecoration(),
                              child: Text(
                                "Игры",
                                style: gmTitleTextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: FutureBuilder<List<Game>>(
                                future: getGames(selectedActivityId!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasError ||
                                      snapshot.data == null) {
                                    return Center(
                                        child:
                                            Text('Не удалось загрузить игры'));
                                  }
                                  final games = snapshot.data!;
                                  if (games.isEmpty) {
                                    return Center(child: Text('Нет игр'));
                                  }
                                  return ListView.separated(
                                    itemCount: games.length,
                                    itemBuilder: (context, index) {
                                      final game = games[index];
                                      return gameInfoRow(
                                          game.startTime, game.duration);
                                    },
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                      height: 16,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
