import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/components/ecom/shipping.dart';
import 'package:uvbs/graphql/mutations/order.dart';
import 'package:uvbs/providers/userProvider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutStripe extends StatefulWidget {
  const CheckoutStripe({super.key});

  @override
  State<CheckoutStripe> createState() => _CheckoutStripeState();
}

class _CheckoutStripeState extends State<CheckoutStripe> {
  bool loading = false;
  bool isOrderPlaced = false;
  String tempOrderId = "";

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

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    PersistentBottomSheetController openBottomSheet(String msg) {
      return scaffoldKey.currentState!.showBottomSheet(
          (context) => Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      msg,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Expanded(child: SizedBox()),
                    IconButton(
                        splashRadius: 25,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Color.fromARGB(255, 247, 252, 255),
                          size: 20,
                        ))
                  ],
                ),
              ),
          backgroundColor: const Color.fromARGB(255, 1, 47, 83));
    }

    openModelBottemSheet(String msg) {
      showModalBottomSheet(
          context: context,
          backgroundColor: const Color.fromARGB(0, 1, 47, 83),
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(248, 0, 37, 50),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 120,
                    child: Text(
                      msg,
                      style: const TextStyle(
                          color: Colors.white, overflow: TextOverflow.clip),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                      splashRadius: 25,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Color.fromARGB(255, 247, 252, 255),
                        size: 20,
                      ))
                ],
              ),
            );
          });
    }

    Future<void> checkout() async {
      try {
        var paymentIndent =
            await generateStripePaymentIndentMutation(totalPrice);
        if (paymentIndent.hasException) {
          setState(() {
            loading = false;
            openModelBottemSheet("something went wrong!");
          });
        }
        if (paymentIndent.data != null) {
          String pid =
              paymentIndent.data?['generateStripePaymentIndent']?['id'];
          String clientSecret = paymentIndent
              .data?['generateStripePaymentIndent']?['client_secret'];

          await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            applePay: Stripe.instance.isApplePaySupported.value,
            googlePay: true,
            style: ThemeMode.dark,
            // testEnv: true,
            billingDetails: BillingDetails(
                email: user?['email'],
                name: user?['name'],
                phone: user?['phone'],
                address: Address(
                    city: user?['shipping']['city'],
                    country: user?['shipping']['country'],
                    line1: user?['shipping']['line1'],
                    line2: user?['shipping']['line2'],
                    postalCode: user?['shipping']['zip'].toString(),
                    state: user?['shipping']['state'])),
            merchantDisplayName: 'UVBS',
            paymentIntentClientSecret: clientSecret,
          ));

          await Stripe.instance.presentPaymentSheet();

          String products = jsonEncode(cartProducts);
          createRPOrderMutation(
                  user?['id'],
                  user?['shipping']['line1'],
                  user?['shipping']['line2'],
                  user?['shipping']['city'],
                  user?['shipping']['state'],
                  user?['shipping']['country'],
                  user?['shipping']['zip'],
                  products,
                  totalPrice,
                  "",
                  pid,
                  "",
                  "")
              .then((value) {
            if (value.hasException) {
              setState(() {
                loading = false;
              });
              openBottomSheet(value.exception!.graphqlErrors[0].message);
            }
            if (value.data != null) {
              setState(() {
                loading = false;
                Provider.of<UserProvider>(context, listen: false)
                    .setUser(value.data!['createRPOrder']);
                isOrderPlaced = true;
              });
            }
          });
        }
      } catch (e) {
        setState(() {
          loading = false;
        });
        openModelBottemSheet('Payment Failed!');
      }
    }

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
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
            : WillPopScope(
                onWillPop: () async {
                  if (loading) {
                    openBottomSheet("Please stay until your order is placed!");
                    return false;
                  } else {
                    return true;
                  }
                },
                child: Scaffold(
                  key: scaffoldKey,
                  backgroundColor: AppColor.background,
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 20),
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
                              onTap: () {
                                if (loading) {
                                  openBottomSheet(
                                      "Please stay until your order is placed!");
                                } else {
                                  Navigator.pop(context);
                                }
                              },
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
                              padding: const EdgeInsets.all(30),
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
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              233, 245, 255, 1),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 10,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        64,
                                                                        166,
                                                                        255,
                                                                        0.18),
                                                                blurStyle:
                                                                    BlurStyle
                                                                        .outer),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          100))),
                                                ),
                                                Container(
                                                  width: 120,
                                                  height: 120,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255,
                                                              188,
                                                              229,
                                                              255),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 10,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        127,
                                                                        208,
                                                                        255,
                                                                        0.565),
                                                                blurStyle:
                                                                    BlurStyle
                                                                        .outer),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 157, 255),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            blurRadius: 15,
                                                            color:
                                                                Color.fromARGB(
                                                                    181,
                                                                    1,
                                                                    161,
                                                                    254),
                                                            blurStyle: BlurStyle
                                                                .outer),
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
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
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.blue),
                                ),
                              ],
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
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.blue),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            !loading
                                ? Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            loading = true;
                                          });
                                          String products =
                                              jsonEncode(cartProducts);
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
                                                loading = false;
                                              });
                                            }
                                            if (value.data != null) {
                                              setState(() {
                                                loading = false;
                                                Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .setUser(value.data![
                                                        'createCODOrder']);
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
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(100)),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 55,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 0, 23, 42),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              100))),
                                              child: const Text(
                                                "Cash on Delivery",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            loading = true;
                                          });

                                          // generateRPOrderIdMutation(totalPrice)
                                          //     .then((value) {
                                          //   if (value.hasException) {
                                          //     setState(() {
                                          //       loading = false;
                                          //       openBottomSheet(
                                          //           "Something went wrong!");
                                          //     });
                                          //   }
                                          //   if (value.data != null) {
                                          //     setState(() {
                                          //       tempOrderId = value.data![
                                          //           'generateRPOrderId']['id'];
                                          //     });
                                          //     Razorpay razorpay = Razorpay();
                                          //     var options = {
                                          //       'key':
                                          //           'rzp_test_5GvNFRqm7IoqBP',
                                          //       'amount': RPAmount,
                                          //       'name': 'UVBS.',
                                          //       'description': 'UVBS products',
                                          //       'order_id':
                                          //           '${value.data!['generateRPOrderId']['id']}',
                                          //       'retry': {
                                          //         'enabled': false,
                                          //         // 'max_count': 1
                                          //       },
                                          //       'send_sms_hash': true,
                                          //       'prefill': {
                                          //         'contact': '${user['phone']}',
                                          //         'email': '${user['email']}'
                                          //       }
                                          //     };
                                          //     razorpay.on(
                                          //         Razorpay.EVENT_PAYMENT_ERROR,
                                          //         handlePaymentErrorResponse);
                                          //     razorpay.on(
                                          //         Razorpay
                                          //             .EVENT_PAYMENT_SUCCESS,
                                          //         handlePaymentSuccessResponse);
                                          //     razorpay.open(options);
                                          //   }
                                          // });

                                          checkout();
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 40),
                                          child: Material(
                                            elevation: 30,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(100)),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 55,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 0, 23, 42),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              100))),
                                              child: const Text(
                                                "Pay Now",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      )
                                    ],
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
                ),
              );
  }
}
