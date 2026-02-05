import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';

class PhoneNumberInput extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String initialCountryCode;
  final String initialCountry;
  final String initialPhoneNumber;
  final String hintText;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final bool showFlag; // New property to toggle flag visibility
  final bool showPhoneIcon; // New property to toggle phone icon visibility
  final bool
  showIconDown; // New property to toggle the dropdown icon visibility
  final bool
  showCountryCode; // New property to toggle the country code visibility

  const PhoneNumberInput({
    Key? key,
    this.onChanged,
    this.initialCountryCode = '+966',
    this.initialCountry = '',
    this.initialPhoneNumber = '',
    this.hintText = '+966 5656 5656 665',
    this.textStyle,
    this.decoration,
    this.showFlag = true, // Default: show flag
    this.showPhoneIcon = true, // Default: show phone icon
    this.showIconDown = true, // Default: show dropdown icon
    this.showCountryCode = true, // Default: show country code
  }) : super(key: key);

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  late TextEditingController _phoneController;
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhoneNumber);
    _selectedCountry = CountryPickerUtils.getCountryByPhoneCode(
      widget.initialCountryCode.replaceAll('+', ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 77, 77, 77)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Country code picker with optional flag and icons
          GestureDetector(
            onTap: _openCountryPicker,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showFlag)
                    // Flag Icon
                    CountryPickerUtils.getDefaultFlagImage(_selectedCountry),
                  SizedBox(width: widget.showFlag ? 8 : 0),
                  if (widget.showCountryCode)
                    Text(
                      '+${_selectedCountry.phoneCode}',
                      style:
                          widget.textStyle ??
                          TextStyle(fontFamily: 'Serif', fontSize: 16),
                    ),
                  // Conditionally show the dropdown icon
                  if (widget.showIconDown) ...[
                    SizedBox(width: 8),
                    IconDown.chevronDown, // Dropdown icon
                  ],
                  if (widget.showPhoneIcon) SizedBox(width: 8),
                  if (widget.showPhoneIcon)
                    IconePhone.phone, // Phone icon near the flag
                ],
              ),
            ),
          ),
          // Phone number input
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: widget.textStyle,
                decoration:
                    (widget.decoration ??
                        InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            fontFamily: 'Serif',
                            color: Color(0xffA3A3A3),
                            fontSize: 12,
                          ), // Set the hint text color
                          border:
                              InputBorder
                                  .none, // Keeps the border none, still applies the hintStyle
                        )),
                onChanged: (value) => _notifyParent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openCountryPicker() {
    showDialog(
      context: context,
      builder:
          (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: AppColor.darkblue),
            child: CountryPickerDialog(
              titlePadding: EdgeInsets.all(8.0),
              searchCursorColor: AppColor.darkblue,
              searchInputDecoration: InputDecoration(hintText: 'Search...'),
              isSearchable: true,
              title: Text(
                'Select your phone code',
                style: TextStyle(fontFamily: 'Serif'),
              ),
              onValuePicked: (Country country) {
                setState(() {
                  _selectedCountry = country;
                  _notifyParent();
                });
              },
            ),
          ),
    );
  }

  void _notifyParent() {
    if (widget.onChanged != null) {
      widget.onChanged!(
        '+${_selectedCountry.phoneCode}${_phoneController.text}',
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
