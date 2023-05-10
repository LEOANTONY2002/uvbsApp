import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/providers/provider.dart';
import 'package:uvbs/providers/userProvider.dart';
import 'package:intl/intl.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    List? userOrders = user?['orders'];
    List? orders = userOrders!.reversed.toList();
    final DateFormat formatter = DateFormat('MMM dd, yyyy');

    String convertedDate(String date) {
      DateTime d = DateTime.parse(date);
      return formatter.format(d);
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 254, 255),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 220, 239, 255),
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: Color.fromARGB(255, 48, 138, 255),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "My Orders",
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              orders.isNotEmpty
                  ? Column(
                      children: orders
                          .map<Widget>((o) => GestureDetector(
                                onTap: () {
                                  Provider.of<AppProvider>(context,
                                          listen: false)
                                      .updateOrder(o);
                                  Navigator.pushNamed(context, "/order");
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 20,
                                            blurStyle: BlurStyle.normal,
                                            offset: Offset(3, 6),
                                            color: Color.fromARGB(
                                                31, 23, 154, 255))
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: const Color.fromARGB(
                                                        255, 227, 243, 255)),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(100)),
                                                color: const Color.fromARGB(
                                                    255, 250, 252, 255)),
                                            child: Icon(
                                                o?['status'] == "PLACED"
                                                    ? Icons
                                                        .shopping_cart_checkout_outlined
                                                    : o?['status'] == "SHIPPED"
                                                        ? Icons
                                                            .local_shipping_rounded
                                                        : Icons.done,
                                                color: Colors.blue),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                o?['status'] ?? "",
                                                style: const TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              Text(
                                                convertedDate(o?['createdAt']),
                                                style: const TextStyle(
                                                    fontSize: 22),
                                              ),
                                            ],
                                          ),
                                          const Expanded(child: SizedBox()),
                                          const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Colors.blue),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Text(
                                        "order id: ",
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              233, 245, 253, 255),
                                        ),
                                        child: Text(
                                          o?['id'],
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 2, 183, 255)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(15),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Color.fromARGB(
                                                  69, 235, 235, 235),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                    Icons
                                                        .local_shipping_rounded,
                                                    color: Colors.blue),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      o?['status'] ==
                                                              "DELIVERED"
                                                          ? "Delivered Date"
                                                          : "Estimated Delivery",
                                                      style: const TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                    Text(
                                                      convertedDate(
                                                          o?['deliveryDate']),
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(child: SizedBox()),
                                          Material(
                                            elevation: 10,
                                            shadowColor: const Color.fromARGB(
                                                72, 236, 245, 255),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        jsonDecode(o?['products'])?[
                                                                        0]
                                                                    ?['product']
                                                                ?['photo'] ??
                                                            "")),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList())
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("lib/assets/images/no_fav.png"),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text("No orders placed!"),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Place your orders",
                            style: TextStyle(
                                color: Color.fromARGB(110, 33, 149, 243)),
                          ),
                        ],
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
