import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmx_player/screen/navigation_screen.dart';
import 'package:tmx_player/widgets/colors.dart';
import 'package:tmx_player/widgets/privacy_policy.dart';
import 'package:tmx_player/widgets/terms_and_condition.dart';

import '../functions/alert_function.dart';

// ignore: constant_identifier_names
const String NOTIFICATION = 'NOTIFICATION';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  void initState() {
    super.initState();
  }

  Future<void> setNotification(bool newValue) async {
    setState(() {
      SWITCHVALUE = newValue;
      SWITCHVALUE!
          ? audioPlayer.showNotification = true
          : audioPlayer.showNotification = false;
    });
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool(NOTIFICATION, SWITCHVALUE!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      " Settings",
                      style: GoogleFonts.ubuntu(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: tmxWhite),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "asset/images/IMG_8227.PNG",
                      height: 70,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Text(
                        "About me",
                        style:
                            GoogleFonts.ubuntu(fontSize: 19, color: tmxWhite),
                      ),
                      onTap: () {
                        showAboutDailoge(context);
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                        child: Text(
                          "Share",
                          style:
                              GoogleFonts.ubuntu(fontSize: 19, color: tmxWhite),
                        ),
                        onTap: () async {
                          await Share.share(
                            'Download TMX Music from Playstore For Free \nDownload Now On Playstore',
                          );
                        }),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Notifications",
                          style:
                              GoogleFonts.ubuntu(fontSize: 19, color: tmxWhite),
                        ),
                        Switch(
                          value: SWITCHVALUE!,
                          onChanged: (newValue) async {
                            setNotification(newValue);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      child: Text(
                        "Terms and Conditions",
                        style:
                            GoogleFonts.ubuntu(fontSize: 19, color: tmxWhite),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const TermsAndCondition();
                          }),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      child: Text(
                        "Privacy Policy",
                        style:
                            GoogleFonts.ubuntu(fontSize: 19, color: tmxWhite),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const PrivacyPolicy();
                          }),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Theme(
                                data: ThemeData(
                                  textTheme: const TextTheme(
                                    bodyText2: TextStyle(
                                      color: tmxWhite,
                                      fontFamily: 'Poppins',
                                    ),
                                    subtitle1: TextStyle(
                                      color: tmxWhite,
                                      fontFamily: 'Poppins',
                                    ),
                                    caption: TextStyle(
                                      color: tmxWhite,
                                      fontFamily: 'Poppins',
                                    ),
                                    headline6: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  cardColor: playlistColor,
                                  appBarTheme: AppBarTheme(
                                    backgroundColor: playlistColor,
                                    elevation: 0,
                                  ),
                                ),
                                child: const LicensePage(
                                  applicationName: 'TMX Music',
                                  applicationVersion: '1.0.1',
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        "License",
                        style:
                            GoogleFonts.ubuntu(fontSize: 19, color: tmxWhite),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(
              height: 80,
            ),
            Column(
              children: [
                Text(
                  'Version',
                  style: GoogleFonts.ubuntu(
                    color: homeRecentArtistC,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  '1.0.1',
                  style: GoogleFonts.ubuntu(
                    color: homeRecentArtistC,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
