// // import 'package:flutter/material.dart';
// // import 'package:hive/hive.dart';
// // import 'package:intl/intl.dart';
// //
// // import 'insights_screen.dart';
// //
// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});
// //
// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }
// //
// // class _HomeScreenState extends State<HomeScreen> {
// //   final _moodBox = Hive.box('moodBox');
// //   final _moodOptions = ['😊', '😌', '😢', '😠', '😰'];
// //   String _currentNote = ''; // Add this variable declaration
// //
// //   // Add this method to handle mood selection
// //   void _handleMoodSelection(String selectedMood) {
// //     _logMood(selectedMood, _currentNote);
// //     _currentNote = ''; // Reset note after logging
// //     Navigator.pop(context); // Close the dialog
// //     setState(() {}); // Refresh UI
// //   }
// //
// //   void _logMood(String mood, String note) {
// //     final dateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
// //     _moodBox.put(dateKey, {
// //       'mood': mood,
// //       'note': note,
// //       'date': dateKey,
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Daily Mood Tracker'),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.insights),
// //             onPressed: () => Navigator.push(
// //               context,
// //               MaterialPageRoute(builder: (context) => const InsightsScreen()),
// //             ),
// //           ),
// //         ],
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         child: const Icon(Icons.add),
// //         onPressed: () => _showMoodDialog(),
// //       ),
// //       body: _buildCalendarGrid(),
// //     );
// //   }
// //
// //   Widget _buildCalendarGrid() {
// //     // Implement 30-day scrollable grid
// //     return GridView.builder(
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: 7,
// //       ),
// //       itemCount: 30,
// //       itemBuilder: (context, index) {
// //         final date = DateTime.now().subtract(Duration(days: 30 - index));
// //         final data = _moodBox.get(DateFormat('yyyy-MM-dd').format(date));
// //         return Container(
// //           margin: const EdgeInsets.all(2),
// //           color: _getMoodColor(data?['mood']),
// //           child: Center(
// //             child: Text(data?['mood'] ?? '',
// //                 style: const TextStyle(fontSize: 24)),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   Color _getMoodColor(String? mood) {
// //     const colors = {
// //       '😊': Colors.yellow,
// //       '😌': Colors.green,
// //       '😢': Colors.blue,
// //       '😠': Colors.red,
// //       '😰': Colors.purple,
// //     };
// //     return colors[mood] ?? Colors.grey.shade200;
// //   }
// //
// //   void _showMoodDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('How are you feeling?'),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Wrap(
// //               children: _moodOptions.map((mood) => IconButton(
// //                 icon: Text(mood, style: const TextStyle(fontSize: 32)),
// //                 onPressed: () => _handleMoodSelection(mood),
// //               )).toList(),
// //             ),
// //             TextField(
// //               decoration: const InputDecoration(
// //                   hintText: 'Add a gratitude note...'),
// //               onChanged: (value) => _currentNote = value,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';
//
// import 'moodModel.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final _moodBox = Hive.box('moodBox');
//   final _moodOptions = ['😊', '😌', '😢', '😠', '😰'];
//   String _currentNote = ''; // Add this variable declaration
//
//   // Add this method to handle mood selection
//   void _handleMoodSelection(String selectedMood) {
//     _currentNote = ''; // Reset note after logging
//     Navigator.pop(context); // Close the dialog
//     setState(() {}); // Refresh UI
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.black,
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton: Material(
//           elevation: 6,
//           // Controls the shadow size
//           color: Colors.transparent,
//           shadowColor: Colors.white,
//           // Custom shadow color
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(180))),
//           child: FloatingActionButton(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(180))),
//             backgroundColor: Colors.white24,
//             foregroundColor: Colors.white70,
//             elevation: 10,
//             child: const Icon(Icons.add),
//             onPressed: () => _showMoodDialog(),
//           ),
//         ),
//         body: _buildBackground(child: _buildLogger()));
//   }
//
//   _buildBackground({required Widget child}) {
//     return BackgroundBuilder(passedChild: child);
//   }
//
//   _buildLogger() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           "How are we feeling today?",
//           style: GoogleFonts.montserrat(color: Colors.green),
//         ),
//
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             MoodButton(moods[MoodKey.happy]!.emoji),
//             MoodButton(moods[MoodKey.content]!.emoji),
//             MoodButton(moods[MoodKey.neutral]!.emoji),
//             MoodButton(moods[MoodKey.sad]!.emoji),
//             MoodButton(moods[MoodKey.anxious]!.emoji),
//           ],
//         ),
//
//       ],
//     );
//   }
//
//   Widget MoodButton(String moodIcon){
//     return Container(child:Text(moodIcon,style: TextStyle(fontSize: 50),));
//   }
//
//   Widget _buildCalendarGrid() {
//     // Implement 30-day scrollable grid
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 7,
//       ),
//       itemCount: 30,
//       itemBuilder: (context, index) {
//         final date = DateTime.now().subtract(Duration(days: 30 - index));
//         final data = _moodBox.get(DateFormat('yyyy-MM-dd').format(date));
//         return Container(
//           margin: const EdgeInsets.all(2),
//           color: _getMoodColor(data?['mood']),
//           child: Center(
//             child: Text(data?['mood'] ?? '', style: const TextStyle(fontSize: 24)),
//           ),
//         );
//       },
//     );
//   }
//
//   Color _getMoodColor(String? mood) {
//     const colors = {
//       '😊': Colors.yellow,
//       '😌': Colors.green,
//       '😢': Colors.blue,
//       '😠': Colors.red,
//       '😰': Colors.purple,
//     };
//     return colors[mood] ?? Colors.grey.shade200;
//   }
//
//   void _showMoodDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('How are you feeling?'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Wrap(
//               children: _moodOptions
//                   .map((mood) => IconButton(
//                         icon: Text(mood, style: const TextStyle(fontSize: 32)),
//                         onPressed: () => _handleMoodSelection(mood),
//                       ))
//                   .toList(),
//             ),
//             TextField(
//               decoration: const InputDecoration(hintText: 'Add a gratitude note...'),
//               onChanged: (value) => _currentNote = value,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class MoodBar extends StatefulWidget {
//   const MoodBar({super.key});
//
//   @override
//   State<MoodBar> createState() => _MoodBarState();
// }
//
// class _MoodBarState extends State<MoodBar> {
//   double _currentValue = 0.0; // Default to Neutral (index 2)
//
//   @override
//   Widget build(BuildContext context) {
//     return  // Mood slider
//       Slider(
//         value: _currentValue,
//         min: 0,
//         max: moods.length - 1,
//         divisions: moods.length - 1,
//         label: moods[_currentValue.round()]!.label,
//         onChanged: (value) {
//           setState(() {
//             _currentValue = value;
//           });
//         },
//       );
//   }
// }
//
//
//
// class BackgroundBuilder extends StatefulWidget {
//   BackgroundBuilder({super.key, required this.passedChild});
//
//   Widget passedChild;
//
//   @override
//   State<BackgroundBuilder> createState() => _BackgroundBuilderState();
// }
//
// class _BackgroundBuilderState extends State<BackgroundBuilder> with TickerProviderStateMixin {
//   late AnimationController _animationController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Animation for moving circles
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 32), // Full loop in 32 seconds
//     )..repeat(); // Loop continuously
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Moving circles behind the card
//         AnimatedBuilder(
//           animation: _animationController,
//           builder: (context, child) {
//             return Stack(
//               children: [
//                 _buildMovingCircle(600, 0.5, 3.0), // Small Circle (fast)
//                 _buildMovingCircle(700, 0.4, 2.0), // Medium Circle (medium)
//                 _buildMovingCircle(800, 0.3, 1.0), // Large Circle (slow)
//                 widget.passedChild
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   // Function to build moving circles with perfect loop
//   Widget _buildMovingCircle(double size, double opacity, double speedMultiplier) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         final double animationValue = _animationController.value;
//
//         // Movement follows a circular path
//         final double angle = animationValue * 2 * pi * speedMultiplier;
//         final double radius = 120;
//
//         // Position calculation for X and Y
//         final double x = 150 + radius * cos(angle); // Use the angle to move along a circular path
//         final double y = 150 + radius * sin(angle);
//
//         return Positioned(
//           left: x,
//           top: y,
//           child: Container(
//             width: size,
//             height: size,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: RadialGradient(
//                 colors: [
//                   Color(0xFF8bc34a).withOpacity(opacity),
//                   Color(0xff64c34a).withOpacity(opacity * 0.7),
//                   Colors.transparent,
//                 ],
//                 stops: [0.4, 0.7, 1],
//                 center: Alignment.center,
//                 radius: 1,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
//

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'historyScreen.dart';
import 'moodStorage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  double _sliderValue = 0.5; // Add this at top of your widget class

  String _getMoodText(double value) {
    if (value < 0.25)
      return 'I am very sad';
    else if (value < 0.5)
      return 'Could be better';
    else if (value < 0.75)
      return 'I am okay';
    else if (value < 0.9)
      return 'I am happy';
    else
      return 'Life is good.';
  }

  Color _getMoodColor(double value) {
    return Color.lerp(Colors.grey[900], Colors.deepPurple, value)!;
  }
  Future<void> _logMood() async {
    await MoodStorage.saveMood(_sliderValue);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mood logged successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showHistory() async {
    final logs = await MoodStorage.getLast30DaysMoods();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(logs: logs),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: Colors.grey[900],
    //   body: Center(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           boxShadow: [BoxShadow(color: Colors.white, offset: Offset(5, 5), blurRadius: 20)],
    //           borderRadius: BorderRadius.circular(18),
    //           color: Colors.grey[900]
    //         ),
    //         child: Padding(
    //           padding: const EdgeInsets.all(68.0),
    //           child: Text('I am happy', style: GoogleFonts.montserrat(color: Colors.white70),),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
          ),
          // Existing text container
          Padding(
            padding: const EdgeInsets.all(38.0),
            child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: Colors.grey[900], boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    offset: Offset(-5, -5),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(5, 5),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 200),
                        style: GoogleFonts.montserrat(
                          color: _getMoodColor(_sliderValue),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.white.withOpacity(0.8 - _sliderValue.clamp(0, 0.8)),
                              offset: Offset(-2, -2),
                              blurRadius: 10,
                            ),
                            Shadow(
                              color: Colors.black.withOpacity(0.8 - (1 - _sliderValue).clamp(0, 0.8)),
                              offset: Offset(2, 2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Text(
                          _getMoodText(_sliderValue),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )),
          ),

          // Neumorphic slider
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    offset: Offset(-4, -4),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(4, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 12,
                  activeTrackColor: Colors.grey[800],
                  inactiveTrackColor: Colors.grey[900],
                  thumbColor: Colors.grey[900],
                  overlayColor: Colors.transparent,
                  thumbShape: _NeuomorphicThumbShape(),
                  trackShape: _NeuomorphicTrackShape(),
                ),
                child: Slider(
                  value: _sliderValue,
                  min: 0,
                  max: 1,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                ),
              ),
            ),
          ),
          // Add this new Log button
          Padding(
            padding: EdgeInsets.all(20),
            child: GestureDetector(
              onTap: _logMood,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[900],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      offset: Offset(-4, -4),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(4, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Text(
                  'Log',
                  style: GoogleFonts.montserrat(
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: GestureDetector(
              onTap: _showHistory,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[900],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      offset: Offset(-4, -4),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(4, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Text(
                  'Visualize',
                  style: GoogleFonts.montserrat(
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Add these custom classes at the bottom of your file
class _NeuomorphicThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(24, 24);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;

    canvas.drawCircle(
      center,
      12,
      Paint()
        ..color = Colors.grey[900]!
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8),
    );

    canvas.drawCircle(
      center,
      10,
      Paint()
        ..color = Colors.grey[900]!
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.black.withOpacity(0.2),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: 10)),
    );
  }
}

class _NeuomorphicTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    required TextDirection textDirection,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
    Offset? secondaryOffset,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Gradient gradient = LinearGradient(
      colors: [
        Colors.grey[900]!,
        Colors.grey[850]!,
      ],
    );

    // Convert Rect to RRect with borderRadius
    final RRect trackRRect = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(trackRect.height / 2),
    );

    // Draw track background
    context.canvas.drawRRect(
      trackRRect,
      Paint()
        ..shader = gradient.createShader(trackRect)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Draw active track
    final activeTrackRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    final RRect activeRRect = RRect.fromRectAndRadius(
      activeTrackRect,
      Radius.circular(activeTrackRect.height / 2),
    );

    context.canvas.drawRRect(
      activeRRect,
      Paint()
        ..color = Colors.grey[800]!
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
    );
  }
}
