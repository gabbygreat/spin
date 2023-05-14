import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Playground'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    animation = Tween<double>(begin: (0).toDegree(), end: 90.toDegree())
        .animate(animationController);

    // animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 300,
              width: 300,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: SpinPainter(),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, -0.2),
                    child: SizedBox(
                      height: 100,
                      width: 150,
                      child: CustomPaint(
                        painter: PinPainter(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    var paint = Paint()..color = Colors.red;

    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2 - 10, size.height - 10);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width / 2 + 10,
      size.height - 10,
    );

    canvas.drawPath(path, paint);
    canvas.drawCircle(
      Offset(size.width / 2, size.height - 15),
      5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SpinPainter extends CustomPainter {
  List<int> percebt = [0, 72, 54, 36, 18, 0];

  List<Color> getRandomColors() {
    List<Color> colors = [];
    math.Random random = math.Random();

    for (int i = 0; i < 6; i++) {
      int r = random.nextInt(255);
      int g = random.nextInt(255);
      int b = random.nextInt(255);
      colors.add(Color.fromRGBO(r, g, b, 1.0));
    }
    return colors;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var thickness = 40.0;
    var backgroundPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 5; i++) {
      backgroundPaint.color = getRandomColors()[i];

      var sum = percebt.sublist(0, i).reduce(
            (value, element) => value + element,
          );

      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2 - thickness / 2,
        ),
        (180 + sum).toDegree(),
        (percebt[i]).toDegree(),
        false,
        backgroundPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension RadianToDegree on num {
  double toDegree() {
    return this * math.pi / 180;
  }
}
