import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';

class MenuButton extends StatefulWidget {
  final void Function()? onCreateActivity;
  final void Function()? onAddPlayer;
  final void Function()? onNewGame;

  const MenuButton(
      {required this.onCreateActivity,
      required this.onAddPlayer,
      required this.onNewGame,
      super.key});

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (_open)
          Padding(
            padding: const EdgeInsets.only(bottom: 70, right: 0),
            child: Material(
              elevation: 4,
              textStyle: gmRegularTextStyle(),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: gmSecondaryBackgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() => _open = false);
                        widget.onCreateActivity?.call();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Создать активность'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() => _open = false);
                        widget.onAddPlayer?.call();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Добавить игрока'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() => _open = false);
                        widget.onNewGame?.call();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Начать новую игру'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        FloatingActionButton(
          backgroundColor: gmSecondaryBackgroundColor,
          elevation: 3,
          onPressed: () => setState(() => _open = !_open),
          child: Icon(
            _open ? Icons.close : Icons.add,
            color: gmAccentColor,
            size: 36,
          ),
        ),
      ],
    );
  }
}
