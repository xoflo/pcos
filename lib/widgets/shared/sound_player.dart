import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:audioplayers/audioplayers.dart';

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

    configureAudioVolume();
    setAudioPlayerDetails(widget.link);
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

  // For the sounds to properly work in Android and iOS, they must be run
  // by default through the speaker
  void configureAudioVolume() {
    final AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        defaultToSpeaker: true,
        category: AVAudioSessionCategory.playback,
        options: [
          AVAudioSessionOptions.defaultToSpeaker,
          AVAudioSessionOptions.allowBluetooth,
        ],
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.speech,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gain,
      ),
    );
    AudioPlayer.global.setGlobalAudioContext(audioContext);
  }

  void setAudioPlayerDetails(String link) {
    // Filter out extra spaces that may be parsed from the backend (just so that
    // we can be sure)
    audioPlayer.setSource(UrlSource(widget.link.trim()));

    // We need to pause here because in iOS, there is a tendency
    // to autoplay the video
    audioPlayer.pause();

    audioPlayer.setReleaseMode(ReleaseMode.stop);

    audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = false;
          currentPosition = 0;
          currentPositionLabel = convertToHmsLabel(Duration(seconds: 0));
        });
      }
    });

    audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) {
        setState(() {
          isLoading = false;
          durationLabel = convertToHmsLabel(dur);
          duration = dur.inSeconds;
          currentPosition = 0;
        });
      }
    });

    audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) {
        setState(() {
          if (isPlaying) {
            currentPosition = pos.inSeconds;
            currentPositionLabel = convertToHmsLabel(pos);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop();
    audioPlayer.release();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
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
                            await audioPlayer.resume();
                          } else {
                            await audioPlayer.pause();
                          }

                          setState(() => isPlaying =
                              audioPlayer.state == PlayerState.playing);
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
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  primaryColor),
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
                        await audioPlayer.seek(positionDuration);

                        setState(() {
                          currentPosition = seekValue;
                          currentPositionLabel =
                              convertToHmsLabel(positionDuration);
                        });
                      },
                    ),
                    data: SliderTheme.of(context).copyWith(
                        activeTrackColor: backgroundColor,
                        inactiveTrackColor: textColor.withOpacity(0.2),
                        trackHeight: 10,
                        trackShape: SoundPlayerTrackShape(),
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 5),
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
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(color: textColor.withOpacity(0.8)),
              ),
            )
          ],
        ),
      );
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
