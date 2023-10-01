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

const String string = 'CLICK HERE FOR THE SURPRISES * ';
List<String> characters = string.split('');

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _animationController1;
  late Animation<double> buttonScale;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 7))
          ..repeat();
    _animationController1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    buttonScale = Tween<double>(begin: 0.9, end: 1).animate(CurvedAnimation(
        parent: _animationController1, curve: Curves.easeInOut));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              RotationTransition(
                turns: _animationController,
                child: Stack(
                  children: [
                    for (int i = 0; i < characters.length; i++)
                      buildPie(context: context, index: i)
                  ],
                ),
              ),
              ScaleTransition(
                scale: buttonScale,
                child: Container(
                  height: 140,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black, width: 8),
                  ),
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                  ),
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
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800),
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
