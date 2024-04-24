import 'package:flutter/material.dart';
import 'package:uvbs/screens/ecom/Cart.dart';
import 'package:uvbs/screens/ecom/Products.dart';

class Ecom extends StatefulWidget {
  const Ecom({super.key});

  @override
  State<Ecom> createState() => _EcomState();
}

class _EcomState extends State<Ecom> {
  int index = 0;

  late List<Widget> screens = [const Products(), const Cart()];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Products();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed("/home"),
          elevation: 0,
          backgroundColor: Colors.transparent,
          splashColor: const Color.fromARGB(255, 7, 226, 255),
          child: Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 4, 188, 255),
                    Color.fromARGB(255, 39, 140, 255)
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, 4),
                    blurRadius: 20,
                    color: Color.fromARGB(171, 1, 149, 255),
                  )
                ]),
            child: const Icon(
              Icons.home_rounded,
              color: Colors.white,
              size: 30,
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.white,
        shadowColor: const Color.fromARGB(206, 0, 0, 0),
        shape: const CircularNotchedRectangle(),
        notchMargin: 15,
        elevation: 20,
        child: SizedBox(
          height: 70,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  highlightColor: const Color.fromARGB(19, 255, 255, 255),
                  splashColor: const Color.fromARGB(155, 231, 251, 255),
                  minWidth: 10,
                  onPressed: () {
                    setState(() {
                      currentScreen = const Products();
                      index = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.storefront_outlined,
                        color: index == 0 ? Colors.black : Colors.black26,
                      ),
                      Text(
                        "Products",
                        style: TextStyle(
                          fontSize: 12,
                          color: index == 0 ? Colors.black : Colors.black26,
                        ),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  highlightColor: const Color.fromARGB(19, 255, 255, 255),
                  splashColor: const Color.fromARGB(155, 231, 251, 255),
                  minWidth: 10,
                  onPressed: () {
                    setState(() {
                      currentScreen = const Cart();
                      index = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: index == 1 ? Colors.black : Colors.black26,
                      ),
                      Text(
                        "Cart",
                        style: TextStyle(
                          fontSize: 12,
                          color: index == 1 ? Colors.black : Colors.black26,
                        ),
                      )
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 90),
                //   child: MaterialButton(
                //     highlightColor: const Color.fromARGB(19, 255, 255, 255),
                //     splashColor: const Color.fromARGB(155, 231, 251, 255),
                //     minWidth: 10,
                //     onPressed: () {
                //       setState(() {
                //         currentScreen = MyOrders();
                //         index = 2;
                //       });
                //     },
                //     child: Icon(
                //       Icons.library_music_outlined,
                //       color: index == 2 ? Colors.black : Colors.black26,
                //     ),
                //   ),
                // ),
                // MaterialButton(
                //   highlightColor: const Color.fromARGB(19, 255, 255, 255),
                //   splashColor: const Color.fromARGB(155, 231, 251, 255),
                //   minWidth: 10,
                //   onPressed: () {
                //     setState(() {
                //       currentScreen = Chat();
                //       index = 3;
                //     });
                //   },
                //   child: Icon(
                //     Icons.message_outlined,
                //     color: index == 3 ? Colors.black : Colors.black26,
                //   ),
                // ),
              ]),
        ),
      ),
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
    );
  }
}
