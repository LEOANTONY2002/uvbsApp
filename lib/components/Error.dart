import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  const Error({
    Key? key,
    required this.message,
    required this.onChange,
  }) : super(key: key);

  final String message;

  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: MediaQuery.of(context).size.width - 60,
        margin: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 87, 14, 1),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 10,
                  color: Color.fromARGB(182, 253, 243, 243),
                  offset: Offset(2, 4))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                // error.msg,
                message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            IconButton(
                onPressed: () => onChange(),
                color: Colors.red,
                iconSize: 30,
                icon: const Icon(Icons.cancel_rounded))
          ],
        ));
  }
}
