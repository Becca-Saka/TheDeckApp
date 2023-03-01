import 'dart:io';

import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/authentication/controller/edit_profile_controller.dart';
import 'package:thedeck/features/authentication/ui/widgets/age_picker.dart';
import 'package:thedeck/features/authentication/ui/widgets/gender_picker.dart';

class ImageStack extends StatelessWidget {
  const ImageStack({super.key, required this.controller});
  final EditProfileController controller;

  @override
  Widget build(BuildContext context) {
    final isLarge = MySize.isLarge;
    final isSmall = MySize.isSmall;
    return Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 35,
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              top: isLarge ? 25 : 16,
              right: isLarge ? 34 : 25,
              left: isLarge ? 34 : 25,
              bottom: isLarge ? 27 : 18),
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.appGrey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(50)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: isSmall ? 140 : MySize.yMargin(isLarge ? 16 : 20.5),
                    width: isSmall ? 90 : MySize.xMargin(isLarge ? 25 : 30),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Hero(
                            tag: 'profile',
                            child: !controller.currentUser.imageList
                                    .contains(controller.currentImage)
                                ? Image.file(
                                    File(controller.currentImage),
                                    fit: BoxFit.cover,
                                  )
                                : profilePicture(controller.currentImage),
                          ),
                        ),
                      ),
                    ),
                  ),
                  widthMin(size: 2),
                  Expanded(
                    child: Container(
                      height: MySize.yMargin(isSmall
                          ? 25
                          : isLarge
                              ? 15
                              : 22),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ).copyWith(bottom: isSmall ? 14 : 20, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customTextField(
                              hintText: 'Name',
                              initialValue: controller.nameText,
                              onChanged: controller.updateNameText,
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.only(left: 2, right: 2, bottom: 8),
                              child: Divider(),
                            ),
                            AgePicker(
                              initalAge: controller.age,
                              onPicked: (String c) {
                                controller.updateAge(c);
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  top: 4, left: 2, right: 2, bottom: 4),
                              child: Divider(),
                            ),
                            GenderPicker(
                              initalGender: controller.gender,
                              onPicked: controller.updateGender,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              heightMin(size: 1),
              SizedBox(
                height: MySize.yMargin(21),
                child: Row(
                  children: controller.newProfileImagesMap
                          .map(
                            (img) => cardWithStar(
                              img.onLocal ? img.localUrl! : img.firebaseUrl!,
                              controller,
                              index: controller.newProfileImagesMap.firstWhere(
                                (k) {
                                  return k == img;
                                },
                              ).index,
                            ),
                          )
                          .toList() +
                      List.generate(
                          4 - controller.newProfileImagesMap.length,
                          (index) => Visibility(
                              visible:
                                  (controller.newProfileImagesMap.length) != 4,
                              child: cardWithStar('', controller,
                                  isPicking: true))),
                ),
              )
            ],
          ),
        ));
  }

  Widget cardWithStar(String image, EditProfileController controller,
      {bool isNetwork = true, bool isPicking = false, int? index}) {
    bool isMain = image == controller.currentImage;
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              controller.pickImage(index: index, isMain: isMain);
            },
            child: SizedBox(
              height: MySize.yMargin(15),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: isPicking
                    ? const Icon(Icons.add)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: controller.currentUser.imageList.contains(image)
                            ? profilePicture(image)
                            : Image.file(
                                File(image),
                                fit: BoxFit.cover,
                              )),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (isPicking == false) {
                controller.changeImage(image, index!);
              }
            },
            child: Icon(
              Icons.star,
              size: MySize.xMargin(8),
              color: isMain ? AppColors.appOrange : AppColors.appGrey,
            ),
          )
        ],
      ),
    );
  }
}
