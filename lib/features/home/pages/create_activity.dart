import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/global/snackbar_service.dart';
import 'package:game_metrics_mobile_app/common/styles/widget_styles.dart';
import 'package:game_metrics_mobile_app/common/widgets/app_bar.dart';
import 'package:game_metrics_mobile_app/features/home/services/activities_service.dart';

class CreateActivityPage extends StatefulWidget {
  const CreateActivityPage({super.key});

  @override
  State<CreateActivityPage> createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: gmPrimaryBackgroundColor,
      body: Center(
        child: Container(
            width: 300,
            padding: const EdgeInsets.all(20.0),
            decoration: gmBoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Имя активности',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Поле не может быть пустым";
                        } else if (value.length < 3) {
                          return "Длина не менее 3 символов";
                        }
                        return null;
                      },
                    )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String? message;
                      try {
                        message =
                            await createActivity(_nameController.text.trim());
                        SnackbarService.showSuccess(message);
                      } catch (e) {
                        SnackbarService.showFail(
                            e.toString().replaceFirst("Exception: ", ""));
                      }

                      if (!mounted) return;

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, 'success');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gmAccentColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Text(
                    'Создать активность',
                    style: TextStyle(
                      color: gmTextColorAlternative,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
