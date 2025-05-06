import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/global/snackbar_service.dart';
import 'package:game_metrics_mobile_app/common/models/activity.dart';
import 'package:game_metrics_mobile_app/common/widgets/app_bar.dart';
import 'package:game_metrics_mobile_app/common/styles/widget_styles.dart';
import 'package:game_metrics_mobile_app/features/home/pages/create_game.dart';
import 'package:game_metrics_mobile_app/features/home/pages/create_player.dart';
import 'package:game_metrics_mobile_app/features/home/services/activities_service.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/activity_dropdown.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/error_box.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/game_list.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/menu_button.dart';
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
      selectedActivityId = null;
      getActivitiesFuture = getActivities();
    });
  }

  void onActivityChanged(int activityId) {
    setState(() {
      selectedActivityId = activityId;
    });
  }

  void onNewGameClick() async {
    if (selectedActivityId == null) {
      SnackbarService.showFail('Сначала выберите активность');
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateGamePage(
          activityId: selectedActivityId!,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result == 'success') {
      setState(() {
        getActivitiesFuture = getActivities();
      });
    }
  }

  void onAddPlayerClick() async {
    if (selectedActivityId == null) {
      SnackbarService.showFail('Сначала выберите активность');
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePlayerPage(
          activityId: selectedActivityId!,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result == 'success') {
      setState(() {
        getActivitiesFuture = getActivities();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: gmPrimaryBackgroundColor,
      floatingActionButton: MenuButton(
        onAddPlayer: onAddPlayerClick,
        onNewGame: onNewGameClick,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder<List<Activity>>(
          future: getActivitiesFuture,
          builder: (context, activitiesSnapshot) {
            if (activitiesSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (activitiesSnapshot.hasError) {
              return ErrorBox(
                message: 'Error: ${activitiesSnapshot.error}',
                productionMessage: 'Не удалось загрузить активности',
              );
            } else if (activitiesSnapshot.data == null) {
              return ErrorBox(message: 'Не удалось загрузить активности');
            }

            activities = activitiesSnapshot.data!;
            if (activities.isNotEmpty) {
              selectedActivityId ??= activities.first.id;
            }

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    ActivityDropdown(
                      selectedActivityId: selectedActivityId,
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
                                      selectedActivityId: selectedActivityId)),
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
                                      selectedActivityId: selectedActivityId)),
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
