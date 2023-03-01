import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/home/controller/home_controller.dart';
import 'package:thedeck/features/home/ui/base_view.dart';
import 'package:thedeck/shared/app_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double _aspectRatio = 0.0;

  bool isSmall = false, isMedium = false, isLarge = false;

  @override
  Widget build(BuildContext context) {
    MySize.init(context);
    isSmall = MySize.isSmall;
    isMedium = MySize.isMedium;
    isLarge = MySize.isLarge;
    int crossAxisSpacing = 20;
    double screenWidth = MySize.xMargin(100);
    int crossAxisCount = 3;
    double width = (screenWidth - ((crossAxisCount - 1) * crossAxisSpacing)) /
        crossAxisCount;
    double cellHeight =
        MySize.yMargin(isSmall ? 19 : (isMedium ? 19 * 1.1 : 19 * 1.3));
    _aspectRatio = width / cellHeight;
    var gridViewHeight = (cellHeight * 2) + (crossAxisSpacing * 1.8);

    return BaseView<HomeController>(
        onModelReady: (model) => model.setUserData(),
        onModelRemoved: (model) => model.onClose(),
        builder: (context, controller, chilld) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    heightMin(),
                    appHeader(MySize.scaledSize(isSmall, isMedium, 45),
                        MySize.scaledSize(isSmall, isMedium, 10)),
                    heightMin(size: 9),
                    Center(
                      child: Container(
                        height: gridViewHeight,
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.appGrey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 27),
                          child: controller
                                      .currentUser.currentMatches.isNotEmpty &&
                                  controller
                                      .currentUser.currentMatches.isNotEmpty
                              ? StreamBuilder(
                                  stream: controller.combineStream(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<dynamic>> snapshot) {
                                    if (snapshot.hasData &&
                                        !snapshot.hasError) {
                                      return Container(
                                          child: deckGrid(snapshot.data![0],
                                              snapshot.data![1], controller));
                                    } else {
                                      return deckGrid([], [], controller);
                                    }
                                  },
                                )
                              : deckGrid([], [], controller),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: InkWell(
                        onTap: controller.navigateToEditProfile,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(MySize.xMargin(30)),
                          child: Container(
                              color: AppColors.appRed,
                              height: MySize.xMargin(18),
                              width: MySize.xMargin(18),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Hero(
                                    tag: 'profile',
                                    child: profilePicture(
                                        controller.currentUser.imageUrl!),
                                  ),
                                  Visibility(
                                      visible:
                                          controller.state != AppState.idle,
                                      child: const CircularProgressIndicator())
                                ],
                              )),
                        ),
                      ),
                    ),
                    heightOne()
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget? temp;

  GridView deckGrid(
    List<MatchDetails> match,
    List<UserDetails> user,
    HomeController controller,
  ) {
    List<Widget> myList = [];
    var noOfQuestions = 6;

    if (match.isNotEmpty && user.isNotEmpty) {
      final tt = (match.length + (controller.showTimer ? 1 : 0));

      noOfQuestions = 6 - tt;
      for (final matchedUser in user) {
        final matchIndex = match.indexWhere(
            (element) => matchedUser.currentDeck.contains(element.uid));
        final matchDetails = match[matchIndex];
        temp = AbsorbPointer(
          absorbing: !controller.hasInternet,
          child: InkWell(
            onTap: () => controller.navigateToChat(matchedUser, matchDetails),
            child: Dismissible(
              key: UniqueKey(),
              background: ColoredBox(color: AppColors.appRed),
              confirmDismiss: (DismissDirection direct) =>
                  controller.showConfirmationDialog(matchedUser),
              onDismissed: (DismissDirection direction) =>
                  controller.removeMatch(matchedUser, matchDetails),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: profilePicture(matchedUser.imageUrl),
                      ),
                    ),
                  ),
                  controller.getIsNewMatch(matchDetails) &&
                          matchDetails.unReadMessagesList == null
                      ? Positioned(
                          child: Align(
                            alignment: FractionalOffset.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Image.asset(
                                'assets/images/New.png',
                                height: MySize.yMargin(6),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      : (matchDetails.messageId != controller.currentUser.uid &&
                              matchDetails.unReadMessagesList != null &&
                              matchDetails.unReadMessagesList!.isNotEmpty)
                          ? Positioned(
                              left: 0,
                              right: 0,
                              top: isSmall ? -5 : -7,
                              child: Align(
                                alignment: FractionalOffset.topRight,
                                child: Stack(
                                  fit: StackFit.passthrough,
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/Message Alert.png',
                                      height: MySize.yMargin(5),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      child: Align(
                                        alignment: FractionalOffset.centerRight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 5.0,
                                              ),
                                              child: Text(
                                                '${matchDetails.unReadMessagesList!.length}',
                                                style: TextStyle(
                                                    fontSize:
                                                        MySize.textSize(4),
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );

        myList.add(temp!);
      }
    }
    if (user.length != 6) {
      if (controller.showTimer) {
        myList.add(Padding(
          padding: const EdgeInsets.all(6.0),
          child: gridItem(
            child: Text(controller.countDownTimer,
                style: TextStyle(
                    color: AppColors.appRed,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: MySize.textSize(6))),
          ),
        ));
      }

      if (controller.showTimer && (user.length + 1) != 6) {
        final list = List.generate(
          noOfQuestions,
          (index) => Padding(
            padding: const EdgeInsets.all(6.0),
            child: gridItem(
                child: Text('?',
                    style: TextStyle(
                        color: AppColors.appOrange,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: MySize.textSize(10)))),
          ),
        );
        myList = myList + list;
      }
    }

    return GridView(
      primary: false,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: isLarge ? 2 : 0,
        crossAxisSpacing: isLarge ? 2 : 0,
        childAspectRatio: _aspectRatio,
      ),
      children: myList,
    );
  }

  Container gridItem({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Center(child: child),
    );
  }
}
