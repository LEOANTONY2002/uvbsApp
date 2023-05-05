import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/graphql/mutations/cart.dart';
import 'package:uvbs/providers/provider.dart';
import 'package:uvbs/providers/userProvider.dart';

class ProductDetail extends StatefulWidget {
  dynamic product;
  ProductDetail({super.key, this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool loading = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    var product = Provider.of<AppProvider>(context, listen: false).product;
    var user = Provider.of<UserProvider>(context, listen: false).user;

    List? cartProducts = user?['cart']?['products'];

    dynamic cartProduct =
        cartProducts!.where((p) => p?['product']?['id'] == product?['id']);
    bool isCartProduct = cartProduct.isNotEmpty;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 60),
                  width: MediaQuery.of(context).size.width - 60,
                  height: MediaQuery.of(context).size.height - 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(2, 61, 112, 1),
                          Color.fromRGBO(1, 31, 57, 1),
                        ]),
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(200)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Material(
                        elevation: 30,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(product?['photo']),
                                  fit: BoxFit.cover),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Image.asset("lib/assets/images/radial_grad.png"),
                      const SizedBox(
                        height: 40,
                      ),
                      !isCartProduct
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                quantity > 1
                                    ? GestureDetector(
                                        onTap: () => setState(() {
                                          quantity -= 1;
                                        }),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  214, 255, 255, 255),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: const Icon(
                                              Icons.horizontal_rule_rounded),
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    quantity += 1;
                                  }),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(214, 255, 255, 255),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Color.fromARGB(90, 0, 115, 209)),
                              child: const Text(
                                "Added to the Cart",
                                style: TextStyle(
                                    color: Color.fromARGB(215, 33, 149, 243)),
                              ),
                            )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product?['name'],
                            style: const TextStyle(fontSize: 22),
                          ),
                          Text(
                            '₹${product?['price'].toString() ?? ""}',
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 22),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        child: Text(
                          product?['description'],
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black38),
                        ),
                      ),
                    ],
                  ),
                ),
                !isCartProduct
                    ? loading
                        ? const CircularProgressIndicator()
                        : Material(
                            elevation: 20,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            shadowColor:
                                const Color.fromARGB(111, 33, 149, 243),
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color.fromARGB(255, 209, 239, 255),
                                      Color.fromARGB(255, 241, 251, 255)
                                    ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  addToCartMutation(
                                          user?['id'],
                                          user?['cart']?['id'],
                                          product['id'],
                                          quantity)
                                      .then((value) {
                                    if (value.hasException) {
                                      setState(() {
                                        loading = true;
                                      });
                                    }
                                    if (value.data != null) {
                                      setState(() {
                                        loading = true;
                                      });
                                      setState(() {
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .setUser(value
                                                .data!['addToCartProduct']);
                                      });
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.add_shopping_cart_rounded,
                                  color: Color.fromARGB(255, 1, 28, 50),
                                  size: 30,
                                ),
                              ),
                            ),
                          )
                    : GestureDetector(
                        onTap: () => Navigator.pushNamed(context, "/ecom"),
                        child: Material(
                          elevation: 20,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                color: Color.fromARGB(255, 1, 49, 89)),
                            child: const Text(
                              "Go to Cart",
                              style: TextStyle(
                                  color: Color.fromARGB(246, 224, 241, 255)),
                            ),
                          ),
                        ),
                      )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(22, 33, 149, 243),
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  border:
                      Border.all(color: const Color.fromARGB(66, 1, 61, 80))),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
