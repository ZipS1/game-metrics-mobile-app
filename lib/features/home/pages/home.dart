import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/models/activity.dart';
import 'package:game_metrics_mobile_app/common/styles/title_text_style.dart';
import 'package:game_metrics_mobile_app/common/widgets/app_bar.dart';
import 'package:game_metrics_mobile_app/common/widgets/box_decoration.dart';
import 'package:game_metrics_mobile_app/features/home/services/activities_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Activity> activities;
  late int selectedActivityId;

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
              int selectedActivityId = activities.first.id;

              return Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    DropdownButton<int>(
                      padding: EdgeInsets.only(left: 10),
                      value: selectedActivityId,
                      items: activities
                          .map((activity) => DropdownMenuItem(
                                value: activity.id,
                                child: Text(activity.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedActivityId = value!;
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
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: gmBoxDecoration(),
                                child: Text(
                                  "Игроки",
                                  style: gmTitleTextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: gmBoxDecoration(),
                                child: Text(
                                  "Игры",
                                  style: gmTitleTextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              )
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
