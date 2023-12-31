import 'package:flify/components/player/volume_slider.dart';
import 'package:flify/providers/current_info.dart';
import 'package:flify/providers/self_volume.dart';
import 'package:flify/providers/socket.dart';
import 'package:flify/types/current_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volume_controller/volume_controller.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  final String hostName;
  final String ip;

  const MusicPlayer({super.key, required this.hostName, required this.ip});

  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends ConsumerState<MusicPlayer> {
  late int localHostVolume;
  late bool hostIsMuted;
  late int localDeviceVolume = 0;

  @override
  void initState() {
    super.initState();

    localHostVolume = ref.read(currentInfoProvider).volume?.volume ?? 0;
    hostIsMuted = ref.read(currentInfoProvider).volume?.isMuted ?? false;

    ref.read(selfVolumeProvider).listen((vol) {
      if (mounted) {
        setState(() {
          localDeviceVolume = vol;
        });
      }
    });
  }

  void onHostVolumeChange(int newVolume) {
    ref
        .read(socketProvider)!
        .emit("change_host_volume", VolumeState(newVolume, hostIsMuted));
  }

  void onHostMuteChange(bool isMuted) {
    ref
        .read(socketProvider)!
        .emit("change_host_volume", VolumeState(localHostVolume, isMuted));
  }

  void onDeviceVolumeChange(int newVolume) {
    VolumeController().setVolume(newVolume / 100.0);
  }

  void playbackPrevious() {
    ref.read(socketProvider)!.emit("playback_previous");
  }

  void playbackToggle() {
    ref.read(socketProvider)!.emit("playback_toggle");
  }

  void playbackNext() {
    ref.read(socketProvider)!.emit("playback_next");
  }

  @override
  Widget build(BuildContext context) {
    CurrentInfo info = ref.watch(currentInfoProvider);

    ref.listen(currentInfoProvider, (previous, next) {
      setState(() {
        localHostVolume = next.volume?.volume ?? 0;
        hostIsMuted = next.volume?.isMuted ?? false;
      });
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Text(widget.hostName,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center),
        Text(
          widget.ip,
          style: TextStyle(fontSize: 14, color: Colors.grey[200]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          info.audioDeviceName ?? "Audio",
          style: const TextStyle(fontSize: 18),
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        VolumeSlider(
          title: "Host volume",
          volume: localHostVolume,
          isMuted: hostIsMuted,
          onVolumeChange: onHostVolumeChange,
          onMuteChange: onHostMuteChange,
        ),
        VolumeSlider(
            title: "Local volume",
            volume: localDeviceVolume,
            onVolumeChange: onDeviceVolumeChange),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.skip_previous,
                color: Theme.of(context).colorScheme.primary,
              ),
              iconSize: 60,
              onPressed: playbackPrevious,
            ),
            IconButton(
              icon: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.6),
                        offset: Offset(0, 7),
                        blurRadius: 34,
                        spreadRadius: -10,
                      )
                    ]),
                child: Stack(children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.all(
                          20), // Modify this till it fills the color properly
                      color: Colors.white, // Color
                    ),
                  ),
                  Icon(
                    Icons.not_started,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ]),
              ),
              iconSize: 90,
              onPressed: playbackToggle,
            ),
            IconButton(
              icon: Icon(
                Icons.skip_next,
                color: Theme.of(context).colorScheme.primary,
              ),
              iconSize: 60,
              onPressed: playbackNext,
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
