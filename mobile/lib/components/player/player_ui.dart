import 'package:flify/components/player/volume_slider.dart';
import 'package:flify/providers/current_info.dart';
import 'package:flify/providers/self_volume.dart';
import 'package:flify/providers/socket.dart';
import 'package:flify/types/current_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volume_controller/volume_controller.dart';

class MusicPlayer extends ConsumerStatefulWidget {
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
      setState(() {
        localDeviceVolume = vol;
      });
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

  @override
  Widget build(BuildContext context) {
    ref.listen(currentInfoProvider, (previous, next) {
      setState(() {
        localHostVolume = next.volume?.volume ?? 0;
        hostIsMuted = next.volume?.isMuted ?? false;
      });
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        Text(
          'Device name',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text('IP address', style: TextStyle(fontSize: 18)),
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
              onPressed: () {},
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
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.skip_next,
                color: Theme.of(context).colorScheme.primary,
              ),
              iconSize: 60,
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
