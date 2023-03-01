import 'package:flutter/material.dart';
import 'package:thedeck/shared/const_color.dart';
import 'package:thedeck/shared/const_size.dart';

class GenderPicker extends StatefulWidget {
  final Function(String) onPicked;
  final String? initalGender;
  const GenderPicker({Key? key, required this.onPicked, this.initalGender})
      : super(key: key);
  @override
  State<GenderPicker> createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  String selectedGender = 'Gender';
  @override
  void initState() {
    if (widget.initalGender != null) {
      selectedGender = widget.initalGender!;
    }
    super.initState();
  }

  final genderList = ['Male', 'Female'];
  @override
  Widget build(BuildContext context) {
    MySize.init(context);
    bool isSmall = MySize.isSmall;
    return SizedBox(
      height: MySize.yMargin(isSmall ? 3.5 : 2.8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            iconSize: 0.0,
            hint: Text(selectedGender,
                style: TextStyle(
                    height: 1,
                    letterSpacing: 0.2,
                    color: AppColors.apptextGrey)),
            value: selectedGender == 'Gender' ? null : selectedGender,
            style: const TextStyle(
                color: Colors.black,
                fontFamily: 'League Spartan',
                fontSize: 16,
                fontWeight: FontWeight.bold),
            isExpanded: true,
            onChanged: selectGender,
            items: genderList
                .map((String e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e,
                    )))
                .toList()),
      ),
    );
  }

  void selectGender(String? value) {
    if (value != null) {
      selectedGender = value;

      setState(() {});
      widget.onPicked(value);
    }
  }
}
