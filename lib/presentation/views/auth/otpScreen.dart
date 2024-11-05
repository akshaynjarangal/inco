import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/presentation/views/auth/passwordScreen.dart';
import 'package:inco/service/auth.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/services.dart'; // For clipboard
import 'package:telephony/telephony.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, this.regdata, required this.isReg, this.phone});
  final regdata;
  final bool isReg;
  final phone;

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final Telephony telephony = Telephony.instance;
  String? otptext;
  TextEditingController otpController = TextEditingController();
   var formkey = GlobalKey<FormState>();

  // Countdown timer duration (3 minutes)
  final int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 180;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _requestSmsPermission();
  }

  void _requestSmsPermission() async {
    final permissionGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionGranted!) {
      _startListeningForSms();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SMS permission is required for OTP autofill")),
      );
    }
  }

  void _startListeningForSms() {
  telephony.listenIncomingSms(
    onNewMessage: (SmsMessage message) {
      final otp = _extractOtpFromMessage(message.body!);
      if (otp != null) {
        setState(() {
          otpController.text = otp;
        });

        // Copy OTP to clipboard
        Clipboard.setData(ClipboardData(text: otp)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP copied to clipboard")),
          );
        });
      }
    },
    listenInBackground: false,
  );
}

 String? _extractOtpFromMessage(String message) {
  // This regex captures a 4-digit number at the start of the message.
  final otpRegex = RegExp(r'(\d{4}) is your mobile verification OTP code');
  final match = otpRegex.firstMatch(message);
  return match?.group(1);
}


  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaqry = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formkey,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enter OTP',
                    style: TextStyle(
                        color: appThemeColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text('Check your Inbox and enter the OTP below'),
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
                  // Pinput for autofill and manual entry
                  Pinput(
                    autofocus: true,
                    length: 4,
                    onChanged: (code) {
                      otptext = null;
                    },
                    onCompleted: (verificationCode) {
                      otptext = verificationCode;
                    },
                    controller: otpController, // Controller for manual input
                    defaultPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: appThemeColor,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: appThemeColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: appThemeColor,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: appThemeColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mediaqry.height * 0.05,
                  ),
                  ValueListenableBuilder(
                      valueListenable: isLoading,
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return isLoading.value
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  color: appThemeColor,
                                ),
                              )
                            : CustomeButton(
                                ontap: () async {
                                  AuthService auth = AuthService();
                                  if (formkey.currentState!.validate() &&
                                      otptext != null) {
                                    isLoading.value = true;
                                    if (widget.isReg) {
                                      await auth.register(
                                          context, widget.regdata, otptext);
                                    } else {
                                      bool isOtpVerified = await auth.verifyOtp(
                                          widget.phone, otptext!);
                                      if (isOtpVerified) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (ctxt) => PasswordScreen(
                                                phone: widget.phone),
                                          ),
                                        );
                                      }
                                    }
                                    isLoading.value = false;
                                  }
                                },
                                height: 43,
                                width: mediaqry.width / 2,
                                text: 'Verify',
                              );
                      }),
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
