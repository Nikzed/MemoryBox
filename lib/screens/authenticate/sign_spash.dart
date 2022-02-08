import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignSplash extends StatelessWidget {
  const SignSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xFFF1B488),
            Color(0xFF8077E4),
          ],
          stops: [0.1, 0.7],
        ),
        // gradient: LinearGradient(
        //   begin: Alignment.bottomRight,
        //   end: Alignment.topLeft,
        //   colors: [
        //     Color(0xFFF1B488),
        //     Constants.purpleColor,
        //   ],
        //   stops: [0.1, 0.7],
        // ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'MemoryBox',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 15),
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: Colors.white),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/Voice.svg',
                    height: 20,
                    width: 16,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
