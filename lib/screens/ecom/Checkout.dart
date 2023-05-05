import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/components/ecom/shipping.dart';
import 'package:uvbs/graphql/mutations/order.dart';
import 'package:uvbs/providers/userProvider.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool loadingCOD = false;
  bool loadingRP = false;
  bool isOrderPlaced = false;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    List? cartProducts = user?['cart']?['products'] ?? [];
    int totalPrice = cartProducts!.isNotEmpty
        ? cartProducts
            .map<int>((p) => p?['product']?['price'] * p?['quantity'])
            .reduce((value1, value2) => value1 + value2)
        : 0;

    int totalItems = cartProducts.isNotEmpty
        ? cartProducts
            .map<int>((p) => p?['quantity'])
            .reduce((value1, value2) => value1 + value2)
        : 0;

    return user!['shipping'] == null
        ? const Shipping()
        : isOrderPlaced
            ? Scaffold(
                backgroundColor: AppColor.background,
                body: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 200,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(200),
                            bottomRight: Radius.circular(200)),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(1, 79, 147, 1),
                              Color.fromRGBO(0, 22, 41, 1),
                            ]),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Image(
                              image: AssetImage(
                                  "lib/assets/images/thank_you.png")),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Thank You",
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                          Text(
                            "Your order has been placed",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(118, 4, 142, 240)),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 2,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Color.fromARGB(0, 1, 41, 54),
                            Color.fromARGB(255, 0, 27, 49)
                          ])),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/ecom"),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 0, 64, 104),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 15,
                                  color: Color.fromARGB(102, 3, 51, 80),
                                  blurStyle: BlurStyle.outer),
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: const Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Scaffold(
                backgroundColor: AppColor.background,
                body: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Checkout",
                            style: TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 214, 237, 255),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.shopping_cart,
                                  size: 15,
                                  color: Color.fromARGB(255, 2, 150, 255),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text("Products",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.blue)),
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.all(30),
                            child: Row(
                              children: cartProducts
                                  .map<Widget>(
                                    (p) => Column(
                                      children: [
                                        Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 150,
                                                height: 150,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        233, 245, 255, 1),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 10,
                                                          color: Color.fromRGBO(
                                                              64,
                                                              166,
                                                              255,
                                                              0.18),
                                                          blurStyle:
                                                              BlurStyle.outer),
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100))),
                                              ),
                                              Container(
                                                width: 120,
                                                height: 120,
                                                decoration: const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 188, 229, 255),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 10,
                                                          color: Color.fromRGBO(
                                                              127,
                                                              208,
                                                              255,
                                                              0.565),
                                                          blurStyle:
                                                              BlurStyle.outer),
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100))),
                                              ),
                                              Container(
                                                width: 90,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(p?[
                                                                    'product']
                                                                ?['photo'] ??
                                                            ""),
                                                        fit: BoxFit.cover),
                                                    color: const Color.fromARGB(
                                                        255, 0, 157, 255),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          blurRadius: 15,
                                                          color: Color.fromARGB(
                                                              181, 1, 161, 254),
                                                          blurStyle:
                                                              BlurStyle.outer),
                                                    ],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                100))),
                                              ),
                                            ]),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(p?['product']?['name'] ?? ""),
                                        Text(
                                          'x${p?['quantity'].toString() ?? ""}',
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 166, 209, 255)),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 214, 237, 255),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.summarize,
                                  size: 15,
                                  color: Color.fromARGB(255, 2, 150, 255),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Order Summary",
                                style:
                                    TextStyle(fontSize: 17, color: Colors.blue),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("Total products"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Total items"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Total price",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(cartProducts.length.toString()),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(totalItems.toString()),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '₹${totalPrice.toString()}',
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 214, 237, 255),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.payment_rounded,
                                  size: 15,
                                  color: Color.fromARGB(255, 2, 150, 255),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Payment",
                                style:
                                    TextStyle(fontSize: 17, color: Colors.blue),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          !loadingCOD
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      loadingCOD = true;
                                    });
                                    String products = jsonEncode(cartProducts);
                                    createCODOrderMutation(
                                            user['id'],
                                            user['shipping']['line1'],
                                            user['shipping']['line2'],
                                            user['shipping']['city'],
                                            user['shipping']['state'],
                                            user['shipping']['country'],
                                            user['shipping']['zip'],
                                            products,
                                            totalPrice)
                                        .then((value) {
                                      if (value.hasException) {
                                        setState(() {
                                          loadingCOD = false;
                                        });
                                      }
                                      if (value.data != null) {
                                        setState(() {
                                          loadingCOD = false;
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .setUser(value
                                                  .data!['createCODOrder']);
                                          isOrderPlaced = true;
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: Material(
                                      elevation: 30,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100)),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 55,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 0, 23, 42),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        child: const Text(
                                          "Cash on Delivery",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(
                                    color: Color.fromARGB(255, 0, 23, 42),
                                  ),
                                )
                        ],
                      )
                    ],
                  ),
                ),
              );
  }
}
