import 'package:flify/components/player/volume_slider.dart';
import 'package:flify/providers/self_volume.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volume_controller/volume_controller.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends ConsumerState<MusicPlayer> {
  late int localHostVolume;
  int localDeviceVolume = 0;

  @override
  void initState() {
    super.initState();

    // TODO
    localHostVolume = 0;

    ref.read(selfVolumeProvider).listen((vol) {
      setState(() {
        localDeviceVolume = vol;
      });
    });
  }

  void onHostVolumeChange(int newVolume) {
    print("host vol to $newVolume");
  }

  void onDeviceVolumeChange(int newVolume) {
    VolumeController().setVolume(newVolume / 100.0);
  }

  @override
  Widget build(BuildContext context) {
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
            onVolumeChange: onHostVolumeChange),
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
