// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const ServiceReportAddPhoto());
}

class ServiceReportAddPhoto extends StatelessWidget {
  const ServiceReportAddPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Image Picker Demo',
      home: ServiceReportAddPhotoPage(title: 'Image Picker Example'),
    );
  }
}

class ServiceReportAddPhotoPage extends StatefulWidget {
  const ServiceReportAddPhotoPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<ServiceReportAddPhotoPage> createState() =>
      _ServiceReportAddPhotoPageState();
}

class _ServiceReportAddPhotoPageState extends State<ServiceReportAddPhotoPage> {
  List<XFile>? _imageFileList;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? [] : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (kIsWeb) {
        controller = VideoPlayerController.network(file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }
      _controller = controller;

      const double volume = kIsWeb ? 0.0 : 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      setState(() {});
    }
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (isVideo) {
      final XFile? file = await _picker.pickVideo(
          source: source, maxDuration: const Duration(seconds: 10));
      await _playVideo(file);
    } else if (isMultiImage) {
      try {
        final List<XFile> pickedFileList = await _picker.pickMultiImage(
            // maxWidth: maxWidth,
            // maxHeight: maxHeight,
            // imageQuality: quality,
            );
        setState(() {
          _imageFileList = pickedFileList;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
      // await _displayPickImageDialog(context!,
      //     (double? maxWidth, double? maxHeight, int? quality) async {
      //   try {
      //     final List<XFile> pickedFileList = await _picker.pickMultiImage(
      //         // maxWidth: maxWidth,
      //         // maxHeight: maxHeight,
      //         // imageQuality: quality,
      //         );
      //     setState(() {
      //       _imageFileList = pickedFileList;
      //     });
      //   } catch (e) {
      //     setState(() {
      //       _pickImageError = e;
      //     });
      //   }
      // });
    } else {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
        );
        setState(() {
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
      // await _displayPickImageDialog(context!,
      //     (double? maxWidth, double? maxHeight, int? quality) async {
      //   try {
      //     final XFile? pickedFile = await _picker.pickImage(
      //       source: source,
      //       // maxWidth: maxWidth,
      //       // maxHeight: maxHeight,
      //       // imageQuality: quality,
      //     );
      //     setState(() {
      //       _setImageFileListFromFile(pickedFile);
      //     });
      //   } catch (e) {
      //     setState(() {
      //       _pickImageError = e;
      //     });
      //   }
      // });
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    // maxWidthController.dispose();
    // maxHeightController.dispose();
    // qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewVideo() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller),
    );
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_imageFileList![index].path)
                  : Image.file(File(_imageFileList![index].path)),
            );
          },
          itemCount: _imageFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    if (isVideo) {
      return _previewVideo();
    } else {
      return _previewImages();
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          if (response.files == null) {
            _setImageFileListFromFile(response.file);
          } else {
            _imageFileList = response.files;
          }
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(widget.title!),
          ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.done:
                      return _handlePreview();
                    case ConnectionState.active:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      }
                  }
                },
              )
            : _handlePreview(),
      ),
      floatingActionButton: Container(
        // container untuk button
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10, top: 10, right: 5, left: 10),
              child: Container(
                // container untuk button per foto
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            isVideo = false;
                            _onImageButtonPressed(ImageSource.gallery,
                                context: context);
                          },
                          heroTag: 'unit0',
                          tooltip: 'Pick Image from gallery',
                          child: const Icon(Icons.photo),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            isVideo = false;
                            _onImageButtonPressed(ImageSource.camera,
                                context: context);
                          },
                          heroTag: 'unit1',
                          tooltip: 'Take a Photo',
                          child: const Icon(Icons.camera_alt),
                        ),
                      ],
                    ),
                    Text('Photo Unit', style: TextStyle(fontSize: 12.0))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10, top: 10, right: 5, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          isVideo = false;
                          _onImageButtonPressed(ImageSource.gallery,
                              context: context);
                        },
                        heroTag: 'sn0',
                        tooltip: 'Pick Image from gallery',
                        child: const Icon(Icons.photo),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          isVideo = false;
                          _onImageButtonPressed(ImageSource.camera,
                              context: context);
                        },
                        heroTag: 'sn1',
                        tooltip: 'Take a Photo',
                        child: const Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                  Text('Photo Serial Number', style: TextStyle(fontSize: 12.0))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 5, top: 10, right: 10, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          isVideo = false;
                          _onImageButtonPressed(ImageSource.gallery,
                              context: context);
                        },
                        heroTag: 'hm0',
                        tooltip: 'Pick Image from gallery',
                        child: const Icon(Icons.photo),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          isVideo = false;
                          _onImageButtonPressed(ImageSource.camera,
                              context: context);
                        },
                        heroTag: 'hm1',
                        tooltip: 'Take a Photo',
                        child: const Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                  Text('Photo HM', style: TextStyle(fontSize: 12.0))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class AspectRatioVideo extends StatefulWidget {
  const AspectRatioVideo(this.controller, {Key? key}) : super(key: key);

  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        ),
      );
    } else {
      return Container();
    }
  }
}
