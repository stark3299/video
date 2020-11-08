import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'volume.dart';

List<CameraDescription> cameras;
CameraController _controller;

class Video extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool loop;
  Video({@required this.videoPlayerController, this.loop, Key key})
      : super(key: key);
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  ChewieController _chewieController;

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras[1], ResolutionPreset.medium);     // Specifying the camera (front or rear) and resolution
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }
  @override
  void initState() {
    super.initState();
    _initCamera();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        looping: widget.loop,
        allowFullScreen: true,
        fullScreenByDefault: true,
        autoPlay: true,
        overlay: App(),
        customControls: Player(),
        aspectRatio: 16 / 9,
        autoInitialize: true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}

class Videoplayer extends StatefulWidget {
  final String videoData =
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4';       // Sample Video
  Videoplayer({videoData});
  @override
  _VideoplayerState createState() => _VideoplayerState();
}

class _VideoplayerState extends State<Videoplayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          ClipRect(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Video(
                  loop: true,
                  videoPlayerController:
                      VideoPlayerController.network(widget.videoData),
                ),
              ),
              decoration: BoxDecoration(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class App extends StatefulWidget {                              // Class build for dragging the camera streaming
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  Color caughtColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return DragBox(Offset(0, 0));
  }
}

class DragBox extends StatefulWidget {
  final Offset initPos;
  DragBox(this.initPos);

  @override
  DragBoxState createState() => DragBoxState();
}

class DragBoxState extends State<DragBox> {
  Offset position = Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    if(widget.initPos == null){
      position = Offset(0.0, 0.0);
    } else {
      position = widget.initPos;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: position.dx,
      top: position.dy,
      child: Container(
        height: 200,
        width: 200,
        child: CameraApp(),
      ),
      // child: Draggable(
      //   child: Container(
      //     width: 200.0,
      //     height: 400.0,
      //     child: CameraApp(),
      //   ),
      //   onDraggableCanceled: (velocity, offset) {
      //     setState(() {
      //       position = offset;
      //     });
      //   },
      // ),
    );
  }
}

class CameraApp extends StatefulWidget {                                   // Camera Streaming Class
  @override
  CameraAppState createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp> {

  @override
  Widget build(BuildContext context) {
    if (_controller != null) {
      if (!_controller.value.isInitialized) {
        return Container();
      } else {
        return ClipRect(
              child: Transform.rotate(
                angle: -3.14/2,
                child: Container(
                  child: Transform.scale(
                    scale: 0.9,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: CameraPreview(_controller),
                      ),
                    ),
                  ),
                ),
              ),
        );
      }
    } else {
      return CircularProgressIndicator();
    }
  }
}