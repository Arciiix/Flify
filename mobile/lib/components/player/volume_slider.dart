import "dart:async";

import "package:flutter/material.dart";

class VolumeSlider extends StatefulWidget {
  int volume;
  String? title;
  bool? isMuted;
  void Function(
    int newVolume,
  ) onVolumeChange;
  void Function(bool muted)? onMuteChange;

  VolumeSlider(
      {super.key,
      required this.volume,
      this.title,
      this.isMuted,
      required this.onVolumeChange,
      this.onMuteChange});

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  late int localVolume;
  Timer? debounce;

  void handleChange(num newValue) {
    setState(() {
      localVolume = newValue.floor();
    });

    debounce?.cancel();
    // Add debounce to update the parent component
    debounce = Timer(const Duration(milliseconds: 300),
        () => widget.onVolumeChange(localVolume));
  }

  IconData getIconForVolume() {
    if (localVolume == 0 || widget.isMuted == true) {
      return Icons.volume_mute;
    } else if (localVolume < 50) {
      return Icons.volume_down;
    } else if (localVolume == 100) {
      return Icons.volume_up;
    } else {
      return Icons.volume_up;
    }
  }

  @override
  void initState() {
    super.initState();
    localVolume = widget.volume;
  }

  @override
  void didUpdateWidget(old) {
    super.didUpdateWidget(old);
    setState(() {
      localVolume = widget.volume;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Text(widget.title ?? "Volume"),
        Row(
          children: [
            IconButton(
              icon: Icon(getIconForVolume(), size: 24, color: Colors.white),
              onPressed: widget.onMuteChange != null
                  ? () => widget.onMuteChange!(!(widget.isMuted ?? false))
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Slider(
                        min: 0,
                        max: 100,
                        thumbColor: Theme.of(context).colorScheme.primary,
                        activeColor: Theme.of(context).colorScheme.primary,
                        inactiveColor: Colors.white70,
                        value: localVolume.toDouble(),
                        onChanged: handleChange,
                        label: "$localVolume%"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: SizedBox(
                            child: Text("0%"),
                            width: 50,
                          ),
                        ),
                        Text("$localVolume%",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: SizedBox(
                            child: Text(
                              "100%",
                              textAlign: TextAlign.end,
                            ),
                            width: 50,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  @override
  void dispose() {
    debounce?.cancel();

    super.dispose();
  }
}
