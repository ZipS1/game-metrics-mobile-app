import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/models/activity.dart';
import 'package:game_metrics_mobile_app/common/widgets/app_bar.dart';
import 'package:game_metrics_mobile_app/common/widgets/box_decoration.dart';
import 'package:game_metrics_mobile_app/features/home/services/activities_service.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/activity_dropdown.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/game_list.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/player_list.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/title_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Activity> activities;
  int? selectedActivityId;
  late Future<List<Activity>> getActivitiesFuture;

  @override
  void initState() {
    super.initState();
    selectedActivityId = null;
    getActivitiesFuture = getActivities();
  }

  Future<void> onRefresh() async {
    setState(() {
      getActivitiesFuture = getActivities();
    });
    await getActivitiesFuture;
  }

  void onActivityChanged(int activityId) {
    setState(() {
      selectedActivityId = activityId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: gmPrimaryBackgroundColor,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder<List<Activity>>(
          future: getActivitiesFuture,
          builder: (context, activitiesSnapshot) {
            if (activitiesSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (activitiesSnapshot.hasError ||
                activitiesSnapshot.data == null) {
              return Center(child: Text('Failed to load activities'));
            }

            activities = activitiesSnapshot.data!;
            selectedActivityId ??= activities.first.id;

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    ActivityDropdown(
                      selectedActivityId: selectedActivityId!,
                      activities: activities,
                      onChanged: onActivityChanged,
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
                              TitleBox(
                                title: "Игроки",
                              ),
                              Container(
                                  width: double.infinity,
                                  height: 300,
                                  decoration: gmBoxDecoration(),
                                  padding: EdgeInsets.all(20),
                                  child: PlayerList(
                                      selectedActivityId: selectedActivityId!)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 20,
                            children: [
                              TitleBox(title: "Игры"),
                              Container(
                                  width: double.infinity,
                                  height: 300,
                                  decoration: gmBoxDecoration(),
                                  padding: EdgeInsets.all(20),
                                  child: GameList(
                                      selectedActivityId: selectedActivityId!)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
