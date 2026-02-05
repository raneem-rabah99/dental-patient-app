import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class SelectOneFromOptionsWidget extends StatefulWidget {
  const SelectOneFromOptionsWidget({super.key, required this.items});
  final List<String> items;

  @override
  State<SelectOneFromOptionsWidget> createState() =>
      _SelectOneFromOptionsWidgetState();
}

class _SelectOneFromOptionsWidgetState
    extends State<SelectOneFromOptionsWidget> {
  int currentINdex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(widget.items.length, (index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 4.0,
                left: 4,
              ), // Padding between buttons
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  gradient:
                      index == currentINdex
                          ? LinearGradient(
                            colors: [AppColor.darkblue, AppColor.lightblue],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                          : null, // No gradient for unselected buttons
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  border: Border.all(
                    color: Color.fromARGB(255, 77, 77, 77), // Border color
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // Transparent button background
                    disabledForegroundColor: Colors.transparent.withOpacity(
                      0.38,
                    ),
                    disabledBackgroundColor: Colors.transparent.withOpacity(
                      0.12,
                    ), // Ensure transparency
                    shadowColor: Colors.transparent, // Remove button shadow
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      currentINdex = index;
                    });
                  },
                  child: Text(
                    widget.items[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Serif',
                      color:
                          index == currentINdex
                              ? Colors
                                  .white // Text color when selected
                              : const Color.fromARGB(
                                255,
                                33,
                                33,
                                33,
                              ), // Text color when unselected
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
