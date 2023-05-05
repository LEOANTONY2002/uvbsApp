import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  const Input({
    Key? key,
    required this.placeholder,
    required this.textInputType,
    required this.labelText,
    required this.onChange,
    required this.value,
  }) : super(key: key);

  final String placeholder;
  final TextInputType textInputType;
  final String labelText;
  final String value;
  final Function onChange;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      height: 55,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                color: Color.fromARGB(27, 77, 177, 253),
                offset: Offset(0, 3)),
          ]),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: TextFormField(
          initialValue: widget.value,
          cursorColor: Colors.black,
          cursorRadius: Radius.circular(10),
          keyboardType: widget.textInputType,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.placeholder,
            labelText: widget.placeholder,
            hintStyle: const TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 18,
                fontWeight: FontWeight.w300),
          ),
          onChanged: (value) => widget.onChange(value),
        ),
      ),
    );
  }
}
