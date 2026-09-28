import 'package:flutter/material.dart';
import 'package:flutter_website/ui/showcase/phone_frame.dart';
import 'package:video_player/video_player.dart';

/// Opens a dialog playing the screen recording [asset] (an MP4 under
/// `assets/videos/`) in a phone frame. The video is only downloaded when
/// the dialog opens, so recordings cost nothing on page load.
Future<void> showScreenRecording(
  BuildContext context, {
  required String asset,
  TargetPlatform platform = TargetPlatform.iOS,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      final height =
          (MediaQuery.sizeOf(context).height - 120).clamp(320.0, 700.0);
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              ),
            ),
            ScreenRecording(asset: asset, platform: platform, height: height),
          ],
        ),
      );
    },
  );
}

/// A muted, looping screen recording playing inside a [PhoneFrame]. Record
/// at the phone's aspect ratio (e.g. 1080×2304, or any 9:19.5 capture);
/// other ratios are cropped to fill the screen.
class ScreenRecording extends StatefulWidget {
  const ScreenRecording({
    super.key,
    required this.asset,
    this.platform = TargetPlatform.iOS,
    this.height = 560,
  });

  final String asset;
  final TargetPlatform platform;
  final double height;

  @override
  State<ScreenRecording> createState() => _ScreenRecordingState();
}

class _ScreenRecordingState extends State<ScreenRecording> {
  late final VideoPlayerController _controller = VideoPlayerController.asset(
      widget.asset,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    // Muted so browsers allow autoplay.
    _controller
      ..setVolume(0)
      ..setLooping(true)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller.play();
      }, onError: (Object _) {
        if (mounted) setState(() => _failed = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = _controller.value;
    final Widget screen;
    if (_failed) {
      screen = const Center(child: Icon(Icons.videocam_off, size: 40));
    } else if (!value.isInitialized) {
      screen = const Center(child: CircularProgressIndicator());
    } else {
      screen = GestureDetector(
        // Tap to pause / resume.
        onTap: () => setState(
            () => value.isPlaying ? _controller.pause() : _controller.play()),
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox.fromSize(
            size: value.size,
            child: VideoPlayer(_controller),
          ),
        ),
      );
    }
    return PhoneFrame(
      platform: widget.platform,
      height: widget.height,
      systemBars: false,
      screen: screen,
    );
  }
}
