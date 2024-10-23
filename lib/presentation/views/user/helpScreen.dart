import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inco/core/constent/colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        backgroundColor: appThemeColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: const Text(
          "Help",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50), // Space below the AppBar
              Row(
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Aligning avatar and text in the same vertical line
                children: [
                  Image.asset(
                    'assets/images/indu logo.png',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: SvgPicture.asset(
                          'assets/images/inco.svg',
                          color:
                              appThemeColor, // Path to your SVG file in assets
                        ),
                      ),
                      // Text(
                      //   'INDU COMPONENTS',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 24,
                      //   ),
                      // ),
                      const SizedBox(height: 3),
                      const Text(
                        "Plot No:20, SIDCO Industrial Park,\nMuchikunnu, Koyilandi, Kerala -\n673307",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                  "You can keep in touch with us through the below\ncontacts. Our team will reach out to you at the earliest.",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 80),
              const Padding(
                padding: EdgeInsets.only(
                  left: 25,
                ),
                child: Row(
                  children: [
                    Icon(Icons.phone_in_talk_outlined),
                    SizedBox(width: 50),
                    Text('+91 9207193005, \n+91 9656193005',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Icon(Icons.phone),
                    SizedBox(width: 50),
                    Text('0496 2690033',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Icon(Icons.email),
                    SizedBox(width: 50),
                    Expanded(
                      child: Text('inducomponentsinco@gmail.com',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
