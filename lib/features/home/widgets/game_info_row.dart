import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:intl/intl.dart';

Widget gameInfoRow(DateTime date, Duration duration) {
  date = date.toLocal();
  final formattedDate = DateFormat('dd.MM.yyyy').format(date);
  final formattedTime = DateFormat('HH:mm').format(date);
  final formattedDuration =
      duration.inSeconds == 0 ? '-' : _formatDuration(duration);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: gmRegularTextStyle(),
            ),
            Text(
              formattedTime,
              style: gmRegularTextStyle(),
            ),
          ],
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formattedDuration,
            style: gmMainPageDurationTextStyle(),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    ],
  );
}

String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (hours > 0) {
    return '$hours:$minutes:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}
