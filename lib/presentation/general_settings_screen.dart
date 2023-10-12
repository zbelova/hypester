import 'package:flutter/material.dart';
import 'package:hypester/data/user_preferences.dart';
import 'package:hypester/presentation/privacy_policy_webview.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  bool _isNSFWActive = UserPreferences().getNSFWActive();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Show NSFW content'),
              activeColor: Colors.deepOrange,
              value: _isNSFWActive,
              onChanged: (value) {
                if (value == true) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning'),
                        content: const Text('This content may be inappropriate for some users. By proceeding, you are confirming that you are 18 or older.'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _isNSFWActive = false;
                                });
                                UserPreferences().setNSFWActive(false);
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel')),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isNSFWActive = value;
                              });
                              UserPreferences().setNSFWActive(value);
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
                setState(() {
                  _isNSFWActive = value;
                });
                UserPreferences().setNSFWActive(value);
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PrivacyPolicyWebView()));
                  },
                  child: Text('Privacy policy', style: TextStyle(fontSize: 16),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
