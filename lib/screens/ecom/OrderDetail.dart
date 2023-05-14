import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/providers/provider.dart';
import 'package:uvbs/providers/userProvider.dart';

class OrderDetail extends StatefulWidget {
  dynamic order;
  OrderDetail({super.key, this.order});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    var order = Provider.of<AppProvider>(context, listen: false).order;
    List? orderProducts = jsonDecode(order?['products']);
    var user = Provider.of<UserProvider>(context, listen: false).user;

    final DateFormat formatter = DateFormat('MMM dd, yyyy');

    String convertedDate(String date) {
      DateTime d = DateTime.parse(date);
      return formatter.format(d);
    }

    int price(int p, int q) {
      return p * q;
    }

    int totalItems = orderProducts!.isNotEmpty
        ? orderProducts
            .map<int>((p) => p?['quantity'])
            .reduce((value1, value2) => value1 + value2)
        : 0;

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topLeft,
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("lib/assets/images/order_ellipse.png"),
                  ),
                ),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(76, 220, 239, 255),
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20, color: Color.fromARGB(255, 244, 248, 255)),
                  ),
                ),
              ),
              orderProducts.length > 2
                  ? Container(
                      margin: const EdgeInsets.only(top: 230),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 130),
                            child: Material(
                              elevation: 10,
                              shadowColor: const Color.fromARGB(76, 2, 35, 61),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        orderProducts[0]?['product']?['photo']),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 130),
                            child: Material(
                              elevation: 10,
                              shadowColor: const Color.fromARGB(76, 2, 35, 61),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        orderProducts[1]?['product']?['photo']),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Material(
                            elevation: 30,
                            shadowColor: const Color.fromARGB(159, 2, 35, 61),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      orderProducts[2]?['product']?['photo']),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 230),
                      child: Material(
                        elevation: 20,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  orderProducts[0]?['product']?['photo']),
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("order from"),
              const SizedBox(
                width: 10,
              ),
              Text(
                convertedDate(order?['createdAt']),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(right: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromARGB(151, 209, 235, 255),
                ),
                child: Row(
                  children: [
                    Icon(
                      order?['status'] == "PLACED"
                          ? Icons.shopping_cart_checkout_outlined
                          : order?['status'] == "SHIPPED"
                              ? Icons.local_shipping_rounded
                              : Icons.done,
                      color: Colors.blue,
                      size: 17,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Status",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 23, 41),
                              fontSize: 9,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          order?['status'],
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromARGB(151, 209, 235, 255),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_shipping_rounded,
                      color: Colors.blue,
                      size: 17,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order?['status'] == "DELIVERED"
                              ? "Delivered At"
                              : "Est. Delivery",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 23, 41),
                              fontSize: 9,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          convertedDate(order?['deliveryDate']),
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 20,
                          blurStyle: BlurStyle.normal,
                          offset: Offset(3, 6),
                          color: Color.fromARGB(31, 98, 187, 255))
                    ]),
                child: Row(
                  children: [
                    RotatedBox(
                      quarterTurns: -45,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 220, 239, 255),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              size: 15,
                              color: Color.fromARGB(255, 48, 138, 255),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Shipping")
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order?['line1'],
                            style: const TextStyle(
                                overflow: TextOverflow.clip,
                                color: Color.fromARGB(83, 0, 0, 0)),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            order?['line2'],
                            style: const TextStyle(
                                overflow: TextOverflow.clip,
                                color: Color.fromARGB(83, 0, 0, 0)),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            order?['city'],
                            style: const TextStyle(
                                overflow: TextOverflow.clip,
                                color: Color.fromARGB(83, 0, 0, 0)),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            order?['state'],
                            style: const TextStyle(
                                overflow: TextOverflow.clip,
                                color: Color.fromARGB(83, 0, 0, 0)),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            order?['country'],
                            style: const TextStyle(
                                overflow: TextOverflow.clip,
                                color: Color.fromARGB(83, 0, 0, 0)),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            order?['zip'].toString() ?? "",
                            style: const TextStyle(
                                overflow: TextOverflow.clip,
                                color: Color.fromARGB(83, 0, 0, 0)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment',
                      style: TextStyle(
                          fontSize: 17,
                          overflow: TextOverflow.clip,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 220, 239, 255),
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          child: Icon(
                            order?['payment_mode'] == "COD"
                                ? Icons.payments
                                : Icons.payment,
                            size: 15,
                            color: const Color.fromARGB(255, 48, 138, 255),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mode',
                              style: TextStyle(
                                overflow: TextOverflow.clip,
                                fontSize: 9,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              order?['payment_mode'] == "COD"
                                  ? "Cash"
                                  : "Online",
                              style: const TextStyle(
                                  overflow: TextOverflow.clip,
                                  color: Color.fromARGB(255, 3, 129, 240)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 220, 239, 255),
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          child: Icon(
                            order?['payment_status'] == "P"
                                ? Icons.currency_rupee
                                : Icons.money_off,
                            size: 15,
                            color: const Color.fromARGB(255, 48, 138, 255),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(
                                overflow: TextOverflow.clip,
                                fontSize: 9,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              order?['payment_status'] == "P"
                                  ? "Paid"
                                  : "Not Paid",
                              style: const TextStyle(
                                  overflow: TextOverflow.clip,
                                  color: Color.fromARGB(255, 3, 129, 240)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: orderProducts
                  .map<Widget>((p) => Column(
                        children: [
                          Stack(alignment: Alignment.topCenter, children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: MediaQuery.of(context).size.width - 40,
                              height: 75,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(92, 255, 255, 255),
                                  boxShadow: [
                                    BoxShadow(
                                        blurStyle: BlurStyle.outer,
                                        color: Color.fromARGB(22, 54, 190, 252),
                                        blurRadius: 20),
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 80,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Material(
                                    elevation: 20,
                                    shadowColor:
                                        const Color.fromARGB(135, 33, 149, 243),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                p?["product"]?["photo"]),
                                            fit: BoxFit.cover),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(p?['product']?['name']),
                                        Text(
                                          "₹${p?['product']?['price'].toString() ?? ''}",
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(65, 0, 0, 0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                          'x${p?['quantity'].toString() ?? ""}'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '₹${price(p?['product']?['price'], p?['quantity']).toString()}',
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ]),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(orderProducts.length.toString()),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(totalItems.toString()),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '₹${order?['price'].toString() ?? ""}',
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 30,
          )
        ],
      )),
    );
  }
}
