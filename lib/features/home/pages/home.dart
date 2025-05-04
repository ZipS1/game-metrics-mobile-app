import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/models/activity.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/common/widgets/app_bar.dart';
import 'package:game_metrics_mobile_app/common/widgets/box_decoration.dart';
import 'package:game_metrics_mobile_app/features/home/services/activities_service.dart';
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
  late int selectedActivityId;

  final players = [
    {"name": "Игрок 1", "score": 100},
    {"name": "Игрок 2", "score": -100},
    {"name": "Игрок 3", "score": 0},
  ];

  final games = [
    {
      "date": DateTime(2025, 5, 1, 8, 30),
      "duration": Duration(hours: 2, minutes: 30)
    },
    {"date": DateTime(2025, 5, 2, 21, 55), "duration": Duration(minutes: 45)},
    {"date": DateTime(2024, 5, 2, 23, 52), "duration": Duration(seconds: 0)},
  ];

  @override
  void initState() {
    super.initState();
    selectedActivityId = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        backgroundColor: gmPrimaryBackgroundColor,
        body: FutureBuilder<List<Activity>>(
            future: getActivities(),
            builder: (context, activitiesSnapshot) {
              if (activitiesSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (activitiesSnapshot.hasError ||
                  activitiesSnapshot.data == null) {
                return Center(child: Text('Failed to load activities'));
              }

              final activities = activitiesSnapshot.data!;
              if (selectedActivityId == -1) {
                selectedActivityId = activities.first.id;
              }

              return Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    ActivityDropdown(
                      selectedActivityId: selectedActivityId,
                      activities: activities,
                      onChanged: (value) {
                        setState(() {
                          selectedActivityId = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 30,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 20,
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
                              Container(
                                  width: double.infinity,
                                  height: 300,
                                  padding: EdgeInsets.all(20),
                                  decoration: gmBoxDecoration(),
                                  child: ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: players.length,
                                    itemBuilder: (context, index) {
                                      final player = players[index];
                                      return playerScoreRow(
                                          player["name"] as String,
                                          player["score"] as int);
                                    },
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                      height: 16,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 20,
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
                              Container(
                                  width: double.infinity,
                                  height: 300,
                                  padding: EdgeInsets.all(20),
                                  decoration: gmBoxDecoration(),
                                  child: ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: games.length,
                                    itemBuilder: (context, index) {
                                      final game = games[index];
                                      return gameInfoRow(
                                          game["date"] as DateTime,
                                          game["duration"] as Duration);
                                    },
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                      height: 16,
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}
