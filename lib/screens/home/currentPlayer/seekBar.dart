
import 'dart:math';

import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
          trackHeight: 1,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Slider(
          min: 0.0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
              widget.duration.inMilliseconds.toDouble()),
          onChanged: (value) {
            setState(() {
              _dragValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd(Duration(milliseconds: value.round()));
            }
            _dragValue = null;
          },
        ),
      ),
    );
  }
}

// class UpdatedSeekbar extends StatefulWidget {
//   UpdatedSeekbar({Key key}) : super(key: key);

//   @override
//   _UpdatedSeekbarState createState() => _UpdatedSeekbarState();
// }

// class _UpdatedSeekbarState extends State<UpdatedSeekbar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: child,
//     );
//   }
// }

// class SeekBar extends StatefulWidget {
//   final Duration duration;
//   final Duration position;
//   final ValueChanged<Duration> onChanged;
//   final ValueChanged<Duration> onChangeEnd;

//   SeekBar({
//     @required this.duration,
//     @required this.position,
//     this.onChanged,
//     this.onChangeEnd,
//   });

//   @override
//   _SeekBarState createState() => _SeekBarState();
// }

// class _SeekBarState extends State<SeekBar> {
//   double _dragValue;

//   @override
//   Widget build(BuildContext context) {
//     return SliderTheme(
//       data: SliderThemeData(
//           trackHeight: 1,
//           thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7)),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         child: Slider(
//           min: 0.0,
//           max: widget.duration.inMilliseconds.toDouble(),
//           value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
//               widget.duration.inMilliseconds.toDouble()),
//           onChanged: (value) {
//             setState(() {
//               _dragValue = value;
//             });
//             if (widget.onChanged != null) {
//               widget.onChanged(Duration(milliseconds: value.round()));
//             }
//           },
//           onChangeEnd: (value) {
//             if (widget.onChangeEnd != null) {
//               widget.onChangeEnd(Duration(milliseconds: value.round()));
//             }
//             _dragValue = null;
//           },
//         ),
//       ),
//     );
//   }
// }
