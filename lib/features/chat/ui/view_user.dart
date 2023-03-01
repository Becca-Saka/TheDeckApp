import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/chat/controller/chat_controller.dart';
import 'package:thedeck/features/home/ui/base_view.dart';

class ViewUser extends StatelessWidget {
  const ViewUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSmall = MySize.isSmall;
    bool isMedium = MySize.isMedium;
    bool isLarge = MySize.isLarge;
    return BaseView<ChatController>(builder: (context, controller, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: controller.goBack,
            icon: const Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.black,
            ),
          ),
          title: Text(
            '${controller.currentChat.name}',
            style: TextStyle(
                color: Colors.black,
                fontSize: isSmall
                    ? 12
                    : isMedium
                        ? 16
                        : 18,
                letterSpacing: 0.5,
                fontFamily: 'League Spartan',
                fontWeight: FontWeight.w400),
          ),
          actions: [
            PopupMenuButton(
                icon: const Icon(Icons.more_horiz,
                    color: Colors.black), // add this line
                itemBuilder: (_) => <PopupMenuItem<String>>[
                      const PopupMenuItem<String>(
                          value: '1',
                          child: SizedBox(
                              width: 100,
                              child: Text(
                                "Block",
                                style: TextStyle(color: Colors.red),
                              ))),
                    ],
                onSelected: (index) async {
                  controller.showConfirmationDialog();
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Hero(
                  tag: 'picture',
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FancyShimmerImage(
                        imageUrl: controller.currentImage,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              heightMin(size: 5),
              SizedBox(
                height: MySize.yMargin(15),
                child: ListView.builder(
                    itemCount: controller.currentChat.imageList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final image = controller.currentChat.imageList[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            left: index == 0
                                ? 0
                                : isSmall
                                    ? 6
                                    : 8),
                        child: InkWell(
                          onTap: () {
                            controller.changeImage(image);
                          },
                          child: SizedBox(
                            width: MySize.xMargin(isLarge ? 22 : 19),
                            height: MySize.yMargin(18),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: FancyShimmerImage(
                                  imageUrl: image,
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      );
    });
  }
}
