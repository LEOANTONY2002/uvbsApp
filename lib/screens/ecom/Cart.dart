import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/graphql/mutations/cart.dart';
import 'package:uvbs/providers/userProvider.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool loading = false;
  bool removing = false;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    List? cartProducts = user?['cart']?['products'];

    int price(int p, int q) {
      return p * q;
    }

    int totalPrice = cartProducts!.isNotEmpty
        ? cartProducts
            .map<int>((p) => p?['product']?['price'] * p?['quantity'])
            .reduce((value1, value2) => value1 + value2)
        : 0;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height - 10,
        decoration: BoxDecoration(color: AppColor.background),
        child: loading
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: AppColor.gradientFirst,
                      ),
                    ),
                  ],
                ),
              )
            : cartProducts.isNotEmpty
                ? Stack(children: [
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 60,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 90),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 0, bottom: 20, left: 0, right: 20),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 237, 247, 255),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.elliptical(180, 120)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(116, 132, 194, 255),
                                      blurRadius: 30,
                                    )
                                  ],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 50, bottom: 25, left: 70, right: 90),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        bottomRight:
                                            Radius.elliptical(180, 120)),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(215, 53, 150, 247),
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    "Cart",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: AppColor.background),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: cartProducts
                                      .map<Widget>((p) => Column(
                                            children: [
                                              Stack(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              40,
                                                      height: 75,
                                                      decoration:
                                                          const BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      92,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    blurStyle:
                                                                        BlurStyle
                                                                            .outer,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            22,
                                                                            54,
                                                                            190,
                                                                            252),
                                                                    blurRadius:
                                                                        20),
                                                              ],
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20))),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Material(
                                                            elevation: 20,
                                                            shadowColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    135,
                                                                    33,
                                                                    149,
                                                                    243),
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            20)),
                                                            child: Container(
                                                              width: 70,
                                                              height: 70,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                        p?["product"]
                                                                            ?[
                                                                            "photo"]),
                                                                    fit: BoxFit
                                                                        .cover),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            20)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20,
                                                                    left: 10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(p?['product']
                                                                    ?['name']),
                                                                Text(
                                                                  p?['product']
                                                                              ?[
                                                                              'price']
                                                                          .toString() ??
                                                                      '',
                                                                  style: const TextStyle(
                                                                      color: Color
                                                                          .fromARGB(
                                                                              65,
                                                                              0,
                                                                              0,
                                                                              0)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Expanded(
                                                              child:
                                                                  SizedBox()),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            decoration: const BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        225,
                                                                        236,
                                                                        255),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50))),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                setState(() {
                                                                  removing =
                                                                      true;
                                                                });
                                                                removeFromCartMutation(
                                                                  user?['id'],
                                                                  p?['id'],
                                                                ).then((value) {
                                                                  if (value
                                                                      .hasException) {
                                                                    setState(
                                                                        () {
                                                                      removing =
                                                                          false;
                                                                    });
                                                                    print(
                                                                        "EROO----------");
                                                                    print(value
                                                                        .exception);
                                                                  }
                                                                  if (value
                                                                          .data !=
                                                                      null) {
                                                                    print(value
                                                                            .data![
                                                                        'removeFromCartProduct']);
                                                                    setState(
                                                                        () {
                                                                      removing =
                                                                          false;
                                                                      Provider.of<UserProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .setUser(
                                                                              value.data!['removeFromCartProduct']);
                                                                    });
                                                                  }
                                                                });
                                                              },
                                                              child: const Icon(
                                                                  Icons
                                                                      .delete_forever_rounded,
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ]),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    80,
                                                margin: const EdgeInsets.only(
                                                    top: 10, bottom: 20),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(10),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromARGB(
                                                            145, 206, 233, 255),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50)),
                                                      ),
                                                      child: Text(
                                                          'x${p?['quantity'].toString() ?? ""}'),
                                                    ),
                                                    const Expanded(
                                                        child: SizedBox()),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromARGB(
                                                            145, 206, 233, 255),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50)),
                                                      ),
                                                      child: Text(
                                                          '₹${price(p?['product']?['price'], p?['quantity']).toString()}'),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ))
                                      .toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 50,
                        left: 10,
                        child: Material(
                          elevation: 25,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 20,
                            height: 80,
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(45, 53, 150, 247),
                                    blurRadius: 30,
                                  )
                                ],
                                color: Color.fromARGB(255, 1, 33, 61),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹${totalPrice.toString()}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                    Text(
                                      "${cartProducts.length.toString()} products",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                                const Expanded(child: SizedBox()),
                                GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/checkout'),
                                  child: Material(
                                    elevation: 25,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 25),
                                      decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: const Text(
                                        "Buy",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                          ),
                        ))
                  ])
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("lib/assets/images/no_fav.png"),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("No products found!"),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Add some products to the cart",
                          style: TextStyle(
                              color: Color.fromARGB(110, 33, 149, 243)),
                        ),
                      ],
                    )),
      ),
    );
  }
}
