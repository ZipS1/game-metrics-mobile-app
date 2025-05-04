import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/models/activity.dart';

typedef OnActivitySelected = void Function(int activityId);

class ActivityDropdown extends StatelessWidget {
  final int selectedActivityId;
  final List<Activity> activities;
  final OnActivitySelected onChanged;

  const ActivityDropdown({
    super.key,
    required this.selectedActivityId,
    required this.activities,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      padding: const EdgeInsets.only(left: 10),
      value: selectedActivityId,
      items: activities
          .map((activity) => DropdownMenuItem(
                value: activity.id,
                child: Text(activity.name),
              ))
          .toList(),
      onChanged: (value) => onChanged(value!),
    );
  }
}
