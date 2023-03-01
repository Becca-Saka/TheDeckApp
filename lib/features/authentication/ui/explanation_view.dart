import 'package:flutter/material.dart';
import 'package:thedeck/app/locator.dart';
import 'package:thedeck/shared/const_size.dart';
import 'package:thedeck/shared/const_widget.dart';

import '../controller/authentication_controller.dart';

class ExplanationView extends StatelessWidget {
  const ExplanationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MySize.init(context);
    bool isSmall = MySize.isSmall;
    bool isMedium = MySize.isMedium;
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        heightOne(),
                        appHeader(
                            isSmall
                                ? 23
                                : isMedium
                                    ? 46
                                    : 62,
                            isSmall
                                ? 4
                                : isMedium
                                    ? 10
                                    : 15),
                        heightMin(size: 4),
                        Text(
                          ''' A full deck is 6 matches. Receive a new match every 8 hours. They fill a space in your deck & you fill a space in theirs.'''
                          '''\n\nHold your finger over a match to discard them from your deck. Doing so also discards you from theirs.'''
                          '''\n\nTry to collect and keep 6 people in your deck. Do this by engaging in chat and creating great profile pics. Otherwise, you may be discarded...''',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              fontFamily: 'Poppins',
                              fontSize: isSmall
                                  ? 13
                                  : isMedium
                                      ? 17
                                      : 24),
                          textAlign: TextAlign.center,
                        ),
                        heightMin(),
                        SizedBox(
                          height: MySize.yMargin(19),
                          child: Image.asset('assets/images/Rocket.png'),
                        ),
                      ],
                    ),
                  ),
                ),
                heightOne(),
                authButton(
                  'Begin',
                  isButtonEnabled: true,
                  onTap: () {
                    final auth = locator<AuthenticationController>();
                    auth.updateUserlocation();
                  },
                ),
                heightOne(),
              ],
            )),
      ),
    );
  }
}
