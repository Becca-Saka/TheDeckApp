import 'dart:async';

import 'package:intl/intl.dart';
import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/chat/ui/view_image.dart';
import 'package:thedeck/features/home/controller/home_controller.dart';
import 'package:thedeck/models/message_details/message_details.dart';
import 'package:thedeck/services/chat_service.dart';
import 'package:thedeck/services/firebase_firestore_services.dart';

class ChatController extends StateController {
  ChatController({
    required this.navigationService,
    required this.appDialog,
  });
  final NavigationService navigationService;
  final AppDialog appDialog;
  TextEditingController chat = TextEditingController();
  final ChatService _chatService = ChatService();
  late UserDetails currentChat;
  late MatchDetails matchDetails;
  List<Message> currentUploading = [];
  List<Message> messages = [];
  String currentImage = '';
  String resp = '';

  FocusNode focusNode = FocusNode();
  final HomeController _homeController = locator<HomeController>();
  final FirestoreServices _firestoreServices = locator<FirestoreServices>();
  UserDetails get currentUser => _homeController.currentUser;
  StreamController<List<Message>> streamController = StreamController();
  late StreamSubscription streamSubscription;
  void onInit(UserDetails chat, MatchDetails match) {
    currentChat = chat;
    matchDetails = match;
    _listenToMessages();
  }

  Future<void> onClose() async {
    await streamController.close();
    await streamSubscription.cancel();
    streamController = StreamController();
  }

  StreamSubscription<List<Message>> _listenToMessages() => streamSubscription =
          getMessageStream().asBroadcastStream().listen((data) {
        streamController.add(data);
      });

  Stream<List<Message>> getMessageStream() =>
      _chatService.getMessage(matchDetails.uid!);

  void updateIsRead() {
    if (matchDetails.unReadMessagesList != null &&
        matchDetails.messageId != currentUser.uid) {
      _chatService.updateReadMessage(matchDetails.uid!, currentUser.uid!);
    }
  }

  Future<void> sendMessage({String? url}) async {
    final text = chat.text;
    if ((text.isNotEmpty || url != null) && hasInternet) {
      final temp = Message(
          senderId: currentUser.uid,
          message: text,
          isImage: url != null,
          imageUrl: url,
          time: getTimeStamp(DateTime.now()));

      await streamSubscription.cancel();
      currentUploading.add(temp);
      notifyListeners();
      chat.clear();
      await _chatService.sendMessage(
        text,
        matchDetails,
        currentChat,
        currentUser.uid!,
        hasImage: url != null,
        imagePath: url,
      );
      currentUploading.remove(temp);
      notifyListeners();

      _listenToMessages();
    }
  }

  void openImageLocationDialog() async {
    final result = await navigationService.dialog(const ImageService());
    if (result != null) {
      resp = result;
      await sendMessage(url: result);
      resp = '';
    }
  }

  void navigateToViewImage(Message element) {
    final day = readTimeStampDaysOnly(element.time);
    final time = DateFormat.Hm().format(parseTimeStamp(element.time));
    navigationService.natigate(
      ViewImage(
        url: element.imageUrl!,
        sentBy: element.senderId == currentUser.uid ? 'You' : currentChat.name!,
        time: '$day,  $time',
      ),
      fullscreenDialog: true,
    );
  }

  void navigateToViewUser() {
    currentImage = currentChat.imageList.first;
    navigationService.navigateTo(
      AppRoutes.viewUser,
      arguments: {'user': currentChat},
    );
  }

  void changeImage(String image) {
    currentImage = image;
    notifyListeners();
  }

  void goBack() => navigationService.back();

  Future<void> blockUser() async {
    appDialog.showLoadingDialog(msg: 'Blocking ${currentChat.name}');
    await _firestoreServices
        .blockUser(currentChat, matchDetails, currentUser)
        .whenComplete(
          () => navigationService.closeAllAndNavigateTo(AppRoutes.home,
              arguments: 'blocked'),
        );
  }

  Future<void> showConfirmationDialog() async {
    appDialog.showBlockUserDialog(
      name: currentChat.name!,
      onConfirm: () async => await blockUser(),
    );
  }
}
