import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/colors.dart';
import 'package:uvbs/graphql/queries/product.dart';
import 'package:uvbs/providers/provider.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool loading = false;
  bool error = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      error = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        error = false;
        loading = true;
      });
      getAllProductsMutation().then((value) {
        if (value.hasException) {
          setState(() {
            loading = false;
          });
        }

        if (value.data != null) {
          setState(() {
            loading = false;
          });
          var allProducts = value.data?['allProducts'];

          setState(() {
            Provider.of<AppProvider>(context, listen: false)
                .addAllProduct(allProducts);
          });
        }

        if (value.data == null) {
          setState(() {
            loading = false;
            error = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List? products =
        Provider.of<AppProvider>(context, listen: false).products ?? [];
    var featuredProduct = products.isNotEmpty
        ? products.length > 1
            ? products[Random().nextInt(products.length - 1)]
            : products[0]
        : '';

    return Scaffold(
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: !error
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
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
                      : products.isNotEmpty
                          ? SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 100),
                              child: Column(
                                children: [
                                  featuredProduct != ""
                                      ? Stack(
                                          children: [
                                            Image.network(
                                              featuredProduct?['photo'],
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 400,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 400,
                                              alignment: Alignment.topLeft,
                                              padding: const EdgeInsets.all(30),
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Color.fromARGB(
                                                        111, 248, 252, 255),
                                                    Color.fromARGB(
                                                        209, 244, 249, 254),
                                                    Color.fromARGB(
                                                        255, 244, 249, 254)
                                                  ],
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    156,
                                                                    33,
                                                                    149,
                                                                    243)),
                                                    child: const Text(
                                                      "Random Pick",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Text(
                                                    featuredProduct['name'],
                                                    style: const TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    featuredProduct[
                                                        'description'],
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        color: Color.fromARGB(
                                                            153, 0, 0, 0)),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Provider.of<AppProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .updateProduct(
                                                                  featuredProduct);
                                                          Navigator.pushNamed(
                                                              context,
                                                              "/product");
                                                        },
                                                        child: Stack(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 20,
                                                                      left: 60),
                                                              height: 50,
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        64,
                                                                        123,
                                                                        215,
                                                                        255),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          50),
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Color.fromARGB(
                                                                          37,
                                                                          84,
                                                                          192,
                                                                          255),
                                                                      blurRadius:
                                                                          30,
                                                                      blurStyle:
                                                                          BlurStyle
                                                                              .outer)
                                                                ],
                                                              ),
                                                              child: const Text(
                                                                  "Buy Now"),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            100),
                                                                      ),
                                                                      boxShadow: [
                                                                    BoxShadow(
                                                                      color: Color.fromARGB(
                                                                          40,
                                                                          28,
                                                                          183,
                                                                          255),
                                                                      blurRadius:
                                                                          30,
                                                                    )
                                                                  ]),
                                                              child: const Icon(
                                                                Icons
                                                                    .shopping_cart,
                                                                color:
                                                                    Colors.blue,
                                                                size: 30,
                                                                shadows: [
                                                                  Shadow(
                                                                      blurRadius:
                                                                          20,
                                                                      color: Color.fromARGB(
                                                                          122,
                                                                          22,
                                                                          181,
                                                                          255),
                                                                      offset:
                                                                          Offset(
                                                                              1,
                                                                              2))
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 30,
                                      bottom: 30,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            "Products",
                                            style: TextStyle(fontSize: 22),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Wrap(
                                              alignment:
                                                  WrapAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 5,
                                              runSpacing: 20,
                                              children: products
                                                  .map<Widget>(
                                                    (p) => GestureDetector(
                                                      onTap: () {
                                                        Provider.of<AppProvider>(
                                                                context,
                                                                listen: false)
                                                            .updateProduct(p);
                                                        Navigator.pushNamed(
                                                            context,
                                                            "/product");
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.all(10),
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            40,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                                boxShadow: [
                                                              BoxShadow(
                                                                color: Color
                                                                    .fromARGB(
                                                                        24,
                                                                        28,
                                                                        183,
                                                                        255),
                                                                blurRadius: 30,
                                                              )
                                                            ]),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 150,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: NetworkImage(p?[
                                                                              'photo']),
                                                                          fit: BoxFit
                                                                              .cover),
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            20),
                                                                      ),
                                                                      boxShadow: const [
                                                                    BoxShadow(
                                                                      color: Color.fromARGB(
                                                                          48,
                                                                          28,
                                                                          183,
                                                                          255),
                                                                      blurRadius:
                                                                          30,
                                                                    )
                                                                  ]),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(p?[
                                                                      'name']),
                                                                  Text(
                                                                    '₹${p?['price'].toString() ?? ''}',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black45),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList()),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: const Text("No videos found!"),
                            ))
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: const Text(
                    "Something went wrong!",
                    style: TextStyle(color: Color.fromARGB(255, 164, 214, 255)),
                  ),
                )),
    );
  }
}
