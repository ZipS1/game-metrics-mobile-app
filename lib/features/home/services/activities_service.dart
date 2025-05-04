import 'dart:convert';

import 'package:game_metrics_mobile_app/common/global/client_service.dart';
import 'package:game_metrics_mobile_app/common/models/activity.dart' as model;
import 'package:game_metrics_mobile_app/config/environment.dart';

Future<List<model.Activity>> getActivities() async {
  const String url = "$baseApiUrl/api/activities";
  var response = await ClientService().get(url);
  List<dynamic> data = json.decode(response.body);

  List<model.Activity> activities =
      data.map((json) => model.Activity.fromJson(json)).toList();
  return activities;
}
