import 'package:thedeck/app/routes/const_routes.dart';

class AppDialog {
  AppDialog({required this.navigationService});
  final NavigationService navigationService;
  void showBlockUserDialog(
      {required String name, required Function()? onConfirm}) {
    navigationService.dialog(
      AlertDialog(
        title: Text(
          'Block $name?',
          style: const TextStyle(
            fontSize: 17.5,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Blocking match will remove them from your deck and you won\'t get matched with them in future.',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            heightMin(size: 1),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              navigationService.back();
            },
          ),
          TextButton(
            onPressed: onConfirm,
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void showDeleteUserDialog(
      {required bool isFacebook,
      required TextEditingController passwordController,
      required Function()? onConfirm}) {
    bool delete = false;
    navigationService.dialog(
      StatefulBuilder(builder: (BuildContext context, setState) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to delete your account?',
            style: TextStyle(
              fontSize: 15.5,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Deleting your account will remove all your information from our database. This cannot be undone',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              heightMin(size: 1),
              Text(
                isFacebook
                    ? "Type 'Delete' in the box to continue"
                    : 'Enter your password to continue',
                style: const TextStyle(
                  fontSize: 14.5,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              heightMin(size: 1),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: passwordController,
                  onChanged: (value) {
                    if (value.isNotEmpty && !isFacebook ||
                        isFacebook && value.trim() == 'Delete') {
                      delete = true;
                    } else {
                      delete = false;
                    }
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    hintText: 'Password',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                passwordController.clear();
                navigationService.back();
              },
            ),
            IgnorePointer(
              ignoring: delete == false,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: delete ? Colors.red : Colors.grey[400],
                ),
                onPressed: onConfirm,
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<bool> showRemoveFromDeckDialog(String name) async {
    bool dismiss = false;
    await navigationService.dialog(
      AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Do you want to remove $name from your deck?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No', style: TextStyle(color: Colors.black)),
            onPressed: () {
              dismiss = false;
              navigationService.back();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
            onPressed: () {
              dismiss = true;
              navigationService.back();
            },
          ),
        ],
      ),
    );
    return dismiss;
  }

  ScaffoldFeatureController<Widget, dynamic> errorSnackbar(
      {required String msg}) {
    return navigationService.snackBar(
      'Error!',
      msg,
      backgroundColor: Colors.red[700],
      colorText: Colors.white,
    );
  }

  ScaffoldFeatureController<Widget, dynamic> successSnackbar(
      {required String msg, required String title}) {
    return navigationService.snackBar(
      title,
      msg,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<dynamic> showLoadingDialog({String? msg}) {
    return navigationService
        .dialog(SimpleDialog(backgroundColor: Colors.white, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.appRed),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${msg ?? ''} Please wait...',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.appRed, fontSize: 13),
            )
          ],
        ),
      ),
    ]));
  }
}
