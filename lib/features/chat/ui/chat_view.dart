import 'package:grouped_list/grouped_list.dart';
import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/chat/controller/chat_controller.dart';
import 'package:thedeck/features/chat/ui/widgets/message_item.dart';
import 'package:thedeck/features/home/ui/base_view.dart';
import 'package:thedeck/models/message_details/message_details.dart';

import 'widgets/app_bar_title.dart';
import 'widgets/chat_actions.dart';
import 'widgets/no_message_item.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize.init(context);
    bool isSmall = MySize.isSmall;
    bool isMedium = MySize.isMedium;
    bool isLarge = MySize.isLarge;
    return BaseView<ChatController>(
        onModelRemoved: (model) => model.onClose(),
        builder: (context, controller, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                elevation: 1,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                title: AppBarTitle(
                  isSmall: isSmall,
                  isMedium: isMedium,
                  title: controller.currentChat.name!,
                  navigateToViewUser: controller.navigateToViewUser,
                  url: controller.currentUser.imageUrl!,
                ),
              ),
              body: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MySize.yMargin(
                            controller.focusNode.hasFocus ? 9 : 6)),
                    child: SizedBox(
                      height: MySize.yMargin(91),
                      width: MySize.xMargin(100),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: StreamBuilder(
                              stream: controller.streamController.stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Message>> snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  controller.updateIsRead();

                                  return GroupedListView<Message, DateTime>(
                                    reverse: true,
                                    elements: snapshot.data!,
                                    order: GroupedListOrder.DESC,
                                    floatingHeader: true,
                                    padding:
                                        controller.currentUploading.isNotEmpty
                                            ? const EdgeInsets.all(0)
                                            : null,
                                    groupBy: (Message element) => DateTime(
                                      parseTimeStamp(element.time).year,
                                      parseTimeStamp(element.time).month,
                                      parseTimeStamp(element.time).day,
                                    ),
                                    groupHeaderBuilder: (Message element) =>
                                        _groupHeaderBuilder(
                                            controller, element),
                                    itemComparator: (Message element1,
                                            Message element2) =>
                                        parseTimeStamp(element1.time).compareTo(
                                            parseTimeStamp(element2.time)),
                                    itemBuilder: (_, Message element) =>
                                        MessageItem(
                                      key: Key(element.uid!),
                                      element: element,
                                      isLarge: isLarge,
                                      isSmall: isSmall,
                                      isTemp: false,
                                      uid: controller.currentUser.uid!,
                                      onTap: () => controller
                                          .navigateToViewImage(element),
                                    ),
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data!.isEmpty) {
                                  return const NoMessageItem();
                                } else {
                                  return const NoMessageItem();
                                }
                              },
                            ),
                          ),
                          controller.currentUploading.isNotEmpty
                              ? ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: controller.currentUploading.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return TempMessageItem(
                                      element:
                                          controller.currentUploading[index],
                                      isLarge: isLarge,
                                      isSmall: isSmall,
                                      uid: controller.currentUser.uid!,
                                    );
                                  })
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  ChatActions(
                    isSmall: isSmall,
                    isLarge: isLarge,
                    openImage: controller.openImageLocationDialog,
                    controller: controller.chat,
                    sendMessage: controller.sendMessage,
                    focusNode: controller.focusNode,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Center _groupHeaderBuilder(ChatController controller, Message element) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          readTimeStampDaysOnly(element.time),
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 11),
        ),
      ),
    );
  }
}
