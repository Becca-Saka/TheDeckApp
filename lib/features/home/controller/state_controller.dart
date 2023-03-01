import 'package:flutter/widgets.dart';
import 'package:thedeck/shared/app_state.dart';
import 'package:thedeck/services/internet_services.dart';

class StateController extends ChangeNotifier {
  AppState _state = AppState.idle;

  bool get hasInternet => ConnectionUtil.instance.hasConnection;
  AppState get state => _state;

  void setAppState(AppState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
