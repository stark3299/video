import 'package:volume/volume.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  double _sliderValue = 0.0;
  int maxVol, currentVol;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Volume.controlVolume(AudioManager
        .STREAM_MUSIC); // you can change which volume you want to change.
  }

  updateVolumes() async {
    maxVol = await Volume.getMaxVol;
    currentVol = await Volume.getVol;
    setState(() {});
  }

  setVol(int i) async {
    await Volume.setVol(i);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 320.0),
        child: Slider(
          activeColor: Colors.indigoAccent,
          min: 0.0,
          max: 15.0,
          onChanged: (newRating) async {
            setState(() {
              _sliderValue = newRating;
            });
            await setVol(newRating.toInt());
            await updateVolumes();
          },
          value: _sliderValue,
        ),
      ),
    );
  }
}
