import 'package:flutter/material.dart';
import '../models/input_model.dart';

class DynamicInput extends StatefulWidget {
  final InputModel input;

  const DynamicInput({Key? key, required this.input}) : super(key: key);

  @override
  _DynamicInputState createState() => _DynamicInputState();
}

class _DynamicInputState extends State<DynamicInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final input = widget.input;

    return Container(
      margin: EdgeInsets.only(
        top: input.marginTop,
        right: input.marginRight,
        bottom: input.marginBottom,
        left: input.marginLeft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (input.label.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                bottom: 4.0,
                left: input.paddingLeft,
              ),
              child: Text(
                input.label,
                style: TextStyle(
                  color: Color(int.parse(input.textColor.replaceFirst('#', '0xFF'))),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.only(
              top: input.paddingTop,
              right: input.paddingRight,
              bottom: input.paddingBottom,
              left: input.paddingLeft,
            ),
            decoration: input.underline
                ? null
                : BoxDecoration(
              color: Color(int.parse(input.backgroundColor.replaceFirst('#', '0xFF'))),
              border: Border.all(
                color: Color(int.parse(input.borderColor.replaceFirst('#', '0xFF'))),
                width: input.borderWidth,
              ),
              borderRadius: BorderRadius.circular(input.borderRadius),
            ),
            child: TextField(
              obscureText: input.type == 'password' ? _obscureText : false,
              decoration: InputDecoration(
                hintText: input.placeholder,
                hintStyle: TextStyle(
                  color: Color(int.parse(input.textColor.replaceFirst('#', '0xFF'))),
                  fontSize: 26,
                ),
                enabledBorder: input.underline
                    ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(int.parse(input.underlineColor.replaceFirst('#', '0xFF'))),
                    width: input.borderWidth,
                  ),
                )
                    : InputBorder.none,
                focusedBorder: input.underline
                    ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(int.parse(input.underlineColor.replaceFirst('#', '0xFF'))),
                    width: input.borderWidth + 1,
                  ),
                )
                    : InputBorder.none,
                suffixIcon: input.type == 'password'
                    ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Color(int.parse(input.textColor.replaceFirst('#', '0xFF'))),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                    : null,
              ),
              style: TextStyle(
                color: Color(int.parse(input.textColor.replaceFirst('#', '0xFF'))),
                fontSize: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
