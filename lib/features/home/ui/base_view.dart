import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thedeck/app/locator.dart';
import 'package:thedeck/features/home/controller/state_controller.dart';

///Creates a wrapper that makes the [StateController] available to all descendants in the widget tree

class BaseView<T extends StateController> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T)? onModelReady;
  final Function(T)? onModelRemoved;

  const BaseView(
      {Key? key, required this.builder, this.onModelReady, this.onModelRemoved})
      : super(key: key);
  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends StateController> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onModelRemoved != null) {
      widget.onModelRemoved!(model);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(builder: widget.builder),
    );
  }
}
