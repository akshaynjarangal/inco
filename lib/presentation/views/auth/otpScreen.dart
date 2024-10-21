import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/presentation/views/auth/passwordScreen.dart';
import 'package:inco/service/auth.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({super.key, this.regdata, required this.isReg, this.phone});
  final regdata;
  final bool isReg;
  final phone;

  String? otptext;
  var formkey = GlobalKey<FormState>();

  // Countdown timer duration (3 minutes)
  final int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 180;

  @override
  Widget build(BuildContext context) {
    var mediaqry = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formkey,
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter OTP',
                    style: TextStyle(
                        color: appThemeColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('Check your Inbox and enter the OTP below'),
                  SizedBox(
                    height: mediaqry.height * 0.08,
                  ),
                  // Countdown Timer Widget
                  CountdownTimer(
                    endTime: endTime,
                    widgetBuilder: (_, time) {
                      if (time == null) {
                        return Text(
                          "Time's up!",
                          style: TextStyle(
                            fontSize: mediaqry.height * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        );
                      } else {
                        return Text(
                          '${time.min ?? 0}:${(time.sec ?? 0).toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: mediaqry.height * 0.03,
                            fontWeight: FontWeight.bold,
                            color: appThemeColor,
                          ),
                        );
                      }
                    },
                  ),
                  OtpTextField(
                    autoFocus: true,
                    clearText: true,
                    fieldWidth: 50,
                    focusedBorderColor: appThemeColor,
                    numberOfFields: 4,
                    borderColor: appThemeColor,
                    showFieldAsBox: true,
                    onCodeChanged: (String code) {
                      otptext = null;
                    },
                    onSubmit: (String verificationCode) {
                      otptext = verificationCode;
                    },
                  ),
                  SizedBox(
                    height: mediaqry.height * 0.05,
                  ),
                  CustomeButton(
                    ontap: () async {
                      AuthService auth = AuthService();
                      if (formkey.currentState!.validate() && otptext != null) {
                        if (isReg) {
                          await auth.register(context, regdata, otptext);
                        } else {
                          bool isOtpVerified =
                              await auth.verifyOtp(phone, otptext!);
                          if (isOtpVerified) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctxt) => PasswordScreen(phone: phone),
                              ),
                            );
                          }
                        }
                      }
                    },
                    height: 43,
                    width: mediaqry.width / 2,
                    text: 'Verify',
                  ),
                  SizedBox(
                    height: mediaqry.height * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
