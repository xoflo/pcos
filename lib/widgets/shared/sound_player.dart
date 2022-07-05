import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';

class SoundPlayer extends StatefulWidget {
  const SoundPlayer({Key? key, required this.link}) : super(key: key);

  final String link;

  @override
  State<SoundPlayer> createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer> {
  AudioPlayer audioPlayer = AudioPlayer();

  String durationLabel = '00:00';
  int duration = 0;
  String currentPositionLabel = '00:00';
  int currentPosition = 0;

  bool isPlaying = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    audioPlayer.onDurationChanged.listen((dur) {
      setState(() {
        isLoading = false;
        durationLabel = convertToHmsLabel(dur);
        duration = dur.inSeconds;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((pos) {
      setState(() {
        if (pos.inSeconds == duration) {
          isPlaying = false;
          currentPosition = 0;
          currentPositionLabel = convertToHmsLabel(Duration(seconds: 0));
        } else {
          currentPosition = pos.inSeconds;
          currentPositionLabel = convertToHmsLabel(pos);
        }
      });
    });
  }

  String convertToHmsLabel(Duration pos) {
    final hours = pos.inHours;
    final minutes = pos.inMinutes;
    final seconds = pos.inSeconds % 60;

    String label = '';
    if (hours > 0) {
      label += '${hours.toString().padLeft(2, '0')}:';
    } else {
      label +=
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return label;
  }

  Future setDetails(String link) async {
    final result = await audioPlayer.setUrl(link);
    if (result != 1) {
      showFlushBar(
        context,
        "Error",
        "Something went wrong with your audio. Please try again",
        backgroundColor: primaryColor,
        borderColor: backgroundColor,
        primaryColor: backgroundColor,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setDetails(widget.link);

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: primaryColorLight,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              InkWell(
                onTap: isLoading
                    ? null
                    : () async {
                        if (!isPlaying) {
                          int results = await audioPlayer.resume();
                          if (results == 1) {
                            setState(() => isPlaying = true);
                          } else {
                            showFlushBar(
                              context,
                              "Error",
                              "Something went wrong with your audio. Please try again",
                              backgroundColor: primaryColor,
                              borderColor: backgroundColor,
                              primaryColor: backgroundColor,
                            );
                          }
                        } else {
                          int results = await audioPlayer.pause();
                          if (results == 1) {
                            setState(() => isPlaying = false);
                          } else {
                            showFlushBar(
                              context,
                              "Error",
                              "Something went wrong with your audio. Please try again",
                              backgroundColor: primaryColor,
                              borderColor: backgroundColor,
                              primaryColor: backgroundColor,
                            );
                          }
                        }
                      },
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: isLoading
                      ? Container(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                            backgroundColor: backgroundColor,
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        )
                      : Icon(
                          !isPlaying ? Icons.play_arrow : Icons.pause,
                          size: 18,
                        ),
                ),
              ),
              Expanded(
                child: SliderTheme(
                  child: Slider(
                    value: currentPosition.toDouble(),
                    max: duration.toDouble(),
                    min: 0,
                    onChanged: (double value) async {
                      final seekValue = value.round();
                      final positionDuration = Duration(seconds: seekValue);
                      final result = await audioPlayer.seek(positionDuration);
                      if (result == 1) {
                        setState(() {
                          currentPosition = seekValue;
                          currentPositionLabel =
                              convertToHmsLabel(positionDuration);
                        });
                      } else {
                        showFlushBar(
                          context,
                          "Error",
                          "Something went wrong with your audio. Please try again",
                          backgroundColor: primaryColor,
                          borderColor: backgroundColor,
                          primaryColor: backgroundColor,
                        );
                      }
                    },
                  ),
                  data: SliderTheme.of(context).copyWith(
                      activeTrackColor: backgroundColor,
                      inactiveTrackColor: textColor.withOpacity(0.2),
                      trackHeight: 10,
                      trackShape: SoundPlayerTrackShape(),
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                      thumbColor: backgroundColor),
                ),
              )
            ],
          ),
          Positioned(
            top: 32.5,
            right: 20,
            child: Text(
              '$currentPositionLabel / $durationLabel',
              style: TextStyle(
                fontSize: 12,
                color: textColor.withOpacity(0.5),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SoundPlayerTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 0;
    final double trackLeft = offset.dx + 20;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 40;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required TextDirection textDirection,
      required Offset thumbCenter,
      bool isDiscrete = false,
      bool isEnabled = false,
      double additionalActiveTrackHeight = 2}) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: 0,
    );
  }
}
