import 'dart:io';
import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../widgets/custom_banner_ad.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _launchInBrowser(BuildContext context, Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Dialogs.showErrorSnackBar(context, 'Could not launch $url');
    }
  }

  // Future<String> _saveScreenshot(Uint8List bytes) async {
  //   final dir = await getTemporaryDirectory(); // path_provider package
  //   final file = File('${dir.path}/feedback.png');
  //   await file.writeAsBytes(bytes);
  //   return file.path;
  // }

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
              'Version: 1.0.1',
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
                      // _customListTile(
                      //   onTap: () {},
                      //   icon: CupertinoIcons.gear,
                      //   title: 'Settings',
                      //   context: context,
                      //   isFirst: true,
                      // ),
                      // _customListTile(
                      //   onTap: () {
                      //     BetterFeedback.of(context)
                      //         .show((UserFeedback feedback) async {
                      //       final path =
                      //           await _saveScreenshot(feedback.screenshot);
                      //       final email = Email(
                      //         attachmentPaths: [path],
                      //         body: feedback.text,
                      //         subject: 'App Feedback',
                      //         recipients: ['harryandpotter19@gmail.com'],
                      //       );
                      //       await FlutterEmailSender.send(email);
                      //     });
                      //   },
                      //   icon: CupertinoIcons.pencil_ellipsis_rectangle,
                      //   title: 'Suggestions / Bug reports',
                      //   context: context,
                      // ),
                      _customListTile(
                        onTap: () async {
                          const url =
                              'https://play.google.com/store/apps/developer?id=SIRMAUR';
                          _launchInBrowser(context, Uri.parse(url));
                        },
                        icon: CupertinoIcons.app_badge,
                        title: 'More Apps',
                        isFirst: true,
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
                        title: 'Copyright',
                        context: context,
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _customListTile(
                    onTap: () async {
                      const url =
                          'https://play.google.com/store/apps/details?id=com.sirmaur.attendance_tracker';
                      _launchInBrowser(context, Uri.parse(url));
                    },
                    tileColor: Colors.blue,
                    imageUrl:
                        'https://play-lh.googleusercontent.com/yM6xx4rQUYU583yQxBh8uze0nipScuPbRDMMC53Z_O-iw2D-Whq7pCW3DHRZGDlXbDo=w480-h960-rw',
                    title: 'Attendance Tracker',
                    subtitle: 'Easily track your college attendance',
                    context: context,
                    isFirst: true,
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
                    Icons.broken_image_rounded,
                    size: 45,
                    color: Colors.white,
                  );
                },
              ))
          : Icon(icon),
      title: Text(
        title,
        style: subtitle != null
            ? const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )
            : null,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(color: Colors.white),
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
