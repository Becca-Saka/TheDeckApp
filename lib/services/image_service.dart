import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thedeck/app/routes/const_routes.dart';

class ImageService extends StatelessWidget {
  final bool isSignUp, removeVisible;
  final Function()? removeImage;

  const ImageService(
      {Key? key,
      this.isSignUp = false,
      this.removeImage,
      this.removeVisible = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: MySize.yMargin(15),
      width: MySize.xMargin(80),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    pickImage(isCamera: true);
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        'Take photo',
                        style: TextStyle(
                            height: 1.5, fontFamily: 'Poppins', fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: pickImage,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        'Choose from Gallery',
                        style: TextStyle(
                            height: 1.5, fontFamily: 'Poppins', fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: removeVisible,
                child: Expanded(
                  child: InkWell(
                    onTap: removeImage,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'Remove Image',
                          style: TextStyle(
                              height: 1.5,
                              fontFamily: 'Poppins',
                              color: Colors.red,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> pickImage({bool isCamera = false}) async {
    final ImagePicker picker = ImagePicker();
    final NavigationService navigationService = locator<NavigationService>();
    locator<AppDialog>().showLoadingDialog();
    final XFile? image = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 30,
        preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      final result = await _cropFile(image.path);
      navigationService.close(1);
      navigationService.back(result ?? image.path);
    } else {
      navigationService.close(2);
    }
  }

  Future<String?> _cropFile(String image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Adjust the image size',
          toolbarColor: AppColors.appRed,
          hideBottomControls: isSignUp ? true : false,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: isSignUp ? true : false,
        )
      ],
    );
    if (croppedFile != null) {
      return croppedFile.path;
    }
    return null;
  }
}
