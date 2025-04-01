import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/colors.dart';
import '/screens/bottom_nav_bar.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor2,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/shiba.svg',
              width: 150,
              height: 150,
            ),
            SvgPicture.asset(
              'assets/images/petsmart.svg',
              width: 100,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 300),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const BottomNavBar()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                fixedSize: const Size(295, 54),
              ),
              child: const Text(
                'Join',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'BlackHanSans',
                  color: secondaryColor2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}