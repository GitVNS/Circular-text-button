import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

const String string = 'CLICK HERE FOR SURPRISES * ';
List<String> characters = string.split('');

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (int i = 0; i < characters.length; i++)
                buildPie(context: context, index: i),
              Container(
                height: 140,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white, width: 6),
                ),
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 22),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildPie({required BuildContext context, required int index}) {
    Size size = MediaQuery.of(context).size;
    var rotate = (index / characters.length) * 2 * pi;
    var angle = 2 * pi / characters.length;

    return Transform.rotate(
      angle: rotate,
      child: ClipPath(
        clipper: PiePath(angle),
        child: Container(
          height: size.width,
          width: size.width,
          alignment: Alignment.topCenter,
          child: Text(
            characters[index],
            style: GoogleFonts.montserrat(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class PiePath extends CustomClipper<Path> {
  final double angle;

  PiePath(this.angle);

  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect rect = Rect.fromCircle(center: center, radius: size.width / 2);
    path.moveTo(center.dx, center.dy);
    path.arcTo(rect, -pi / 2 - angle / 2, angle, false);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(PiePath oldClipper) {
    return angle != oldClipper.angle;
  }
}
