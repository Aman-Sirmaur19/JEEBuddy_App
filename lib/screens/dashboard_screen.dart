import 'dart:io';
import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../widgets/custom_banner_ad.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _launchInBrowser(BuildContext context, Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Dialogs.showErrorSnackBar(context, 'Could not launch $url');
    }
  }

  Future<String> _saveScreenshot(Uint8List bytes) async {
    final dir = await getTemporaryDirectory(); // path_provider package
    final file = File('${dir.path}/feedback.png');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Back',
            icon: const Icon(CupertinoIcons.chevron_back),
          ),
          centerTitle: true,
          title: Text(
            'Dashboard',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        bottomNavigationBar: const CustomBannerAd(),
        body: Column(
          children: [
            const Text(
              'Version: 1.0.4',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 1.5,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                physics: const BouncingScrollPhysics(),
                children: [
                  ListTile(
                    tileColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Coming soon...',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Spacer(),
                              Text('🔔'),
                            ],
                          ),
                          // backgroundColor: Colors.black87,
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    leading: const Icon(Icons.star_rate_rounded,
                        color: Colors.amber),
                    title: RichText(
                        text: TextSpan(
                      text: 'JEE',
                      style: const TextStyle(
                        fontSize: 18,
                        letterSpacing: 1,
                        color: Colors.orange,
                        fontFamily: 'Fredoka',
                        fontWeight: FontWeight.w900,
                      ),
                      children: [
                        TextSpan(
                          text: 'Buddy',
                          style: TextStyle(
                            fontSize: 18,
                            letterSpacing: 0,
                            fontFamily: 'Fredoka',
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          children: const [
                            TextSpan(
                              text: ' Pro',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.amber,
                                fontFamily: 'Fredoka',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                    trailing: const Icon(
                      CupertinoIcons.chevron_forward,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      _customListTile(
                        onTap: () {
                          BetterFeedback.of(context)
                              .show((UserFeedback feedback) async {
                            final path =
                                await _saveScreenshot(feedback.screenshot);
                            try {
                              final email = Email(
                                body: feedback.text,
                                subject: 'App Feedback',
                                recipients: ['harryandpotter19@gmail.com'],
                                attachmentPaths: [path], // optional
                              );
                              await FlutterEmailSender.send(email);
                            } catch (e) {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'harryandpotter19@gmail.com',
                                queryParameters: {
                                  'subject': 'App Feedback',
                                  'body': feedback.text,
                                },
                              );
                              await launchUrl(emailLaunchUri);
                            }
                          });
                        },
                        icon: CupertinoIcons.pencil_ellipsis_rectangle,
                        title: 'Suggestions / Bug reports',
                        context: context,
                        isFirst: true,
                      ),
                      _customListTile(
                        onTap: () async {
                          const String appUrl =
                              'https://play.google.com/store/apps/details?id=com.sirmaur.jeebuddy';
                          SharePlus.instance.share(ShareParams(
                            title: 'Check out this awesome JEEBuddy app',
                            uri: Uri.parse(appUrl),
                          ));
                        },
                        icon: CupertinoIcons.share,
                        title: 'Share with friends',
                        context: context,
                        // isFirst: true,
                      ),
                      _customListTile(
                        onTap: () async {
                          const url =
                              'https://play.google.com/store/apps/details?id=com.sirmaur.jeebuddy';
                          _launchInBrowser(context, Uri.parse(url));
                        },
                        icon: CupertinoIcons.star,
                        title: 'Rate us 5 ⭐',
                        context: context,
                      ),
                      _customListTile(
                        onTap: () async {
                          const url =
                              'https://play.google.com/store/apps/developer?id=SIRMAUR';
                          _launchInBrowser(context, Uri.parse(url));
                        },
                        icon: CupertinoIcons.app_badge,
                        title: 'More Apps',
                        context: context,
                      ),
                      _customListTile(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.blue.shade200,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        'assets/images/avatar.png',
                                        width: 100,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Aman Sirmaur',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'MECHANICAL ENGINEERING',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'NIT AGARTALA',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      child: Image.asset(
                                          'assets/images/youtube.png',
                                          width: 30),
                                      onTap: () async {
                                        const url =
                                            'https://www.youtube.com/@AmanSirmaur';
                                        _launchInBrowser(
                                            context, Uri.parse(url));
                                      },
                                    ),
                                    InkWell(
                                      child: Image.asset(
                                          'assets/images/twitter.png',
                                          width: 30),
                                      onTap: () async {
                                        const url =
                                            'https://x.com/AmanSirmaur?t=2QWiqzkaEgpBFNmLI38sbA&s=09';
                                        _launchInBrowser(
                                            context, Uri.parse(url));
                                      },
                                    ),
                                    InkWell(
                                      child: Image.asset(
                                          'assets/images/instagram.png',
                                          width: 30),
                                      onTap: () async {
                                        const url =
                                            'https://www.instagram.com/aman_sirmaur19/';
                                        _launchInBrowser(
                                            context, Uri.parse(url));
                                      },
                                    ),
                                    InkWell(
                                      child: Image.asset(
                                          'assets/images/github.png',
                                          width: 30),
                                      onTap: () async {
                                        const url =
                                            'https://github.com/Aman-Sirmaur19';
                                        _launchInBrowser(
                                            context, Uri.parse(url));
                                      },
                                    ),
                                    InkWell(
                                      child: Image.asset(
                                          'assets/images/linkedin.png',
                                          width: 30),
                                      onTap: () async {
                                        const url =
                                            'https://www.linkedin.com/in/aman-kumar-257613257/';
                                        _launchInBrowser(
                                            context, Uri.parse(url));
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                        icon: Icons.copyright_rounded,
                        title: 'Developer',
                        context: context,
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RichText(
                      text: TextSpan(
                          text: 'Explore our other apps ',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Fredoka',
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          children: const [
                        TextSpan(
                          text: '(Sponsored)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ])),
                  const SizedBox(height: 10),
                  _customListTile(
                    onTap: () async {
                      const url =
                          'https://play.google.com/store/apps/details?id=com.sirmaur.attendance_tracker';
                      _launchInBrowser(context, Uri.parse(url));
                    },
                    tileColor: Colors.blue,
                    imageUrl:
                        'https://play-lh.googleusercontent.com/mndUutt6VGHFYUjC_z5jvQdi8EjTQOmsXtjbZ4bLWjAMp5-252JuNw5w-4A_2pHC_RI=w480-h960-rw',
                    title: 'College Attendance Tracker',
                    subtitle: 'Track your college attendance with ease.',
                    context: context,
                    isFirst: true,
                  ),
                  _customListTile(
                    onTap: () async {
                      const url =
                          'https://play.google.com/store/apps/details?id=com.sirmaur.shreemad_bhagavad_geeta';
                      _launchInBrowser(context, Uri.parse(url));
                    },
                    tileColor: Colors.amber,
                    imageUrl:
                        'https://play-lh.googleusercontent.com/L4FMm88yMoWIKhUX3U1XJTmvd8_MkoQUX4IfN61QBSq51GWpnMPvs4Dz7gpmlmXspA=w480-h960-rw',
                    title: 'Shreemad Bhagavad Geeta',
                    subtitle:
                        'The Divine Song of God\nAvailable in 100+ global languages',
                    context: context,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const Text(
              'MADE WITH ❤️ IN 🇮🇳',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 1.5,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customListTile({
    required void Function() onTap,
    required String title,
    required BuildContext context,
    Color? tileColor,
    IconData? icon,
    String? imageUrl,
    String? subtitle,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return ListTile(
      tileColor: tileColor ?? Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: isFirst ? const Radius.circular(20) : Radius.zero,
        topRight: isFirst ? const Radius.circular(20) : Radius.zero,
        bottomLeft: isLast ? const Radius.circular(20) : Radius.zero,
        bottomRight: isLast ? const Radius.circular(20) : Radius.zero,
      )),
      onTap: onTap,
      leading: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                width: 45,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.android_rounded,
                    size: 45,
                    color: Colors.lightGreen,
                  );
                },
              ))
          : Icon(icon),
      title: Text(
        title,
        style: subtitle != null
            ? TextStyle(
                color: title.contains('Geeta') ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              )
            : null,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                  color: title.contains('Geeta') ? Colors.black : Colors.white),
            )
          : null,
      trailing: subtitle == null
          ? const Icon(
              CupertinoIcons.chevron_forward,
              color: Colors.grey,
            )
          : null,
    );
  }
}
