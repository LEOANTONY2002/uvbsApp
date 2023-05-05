import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uvbs/graphql/GraphQLConfig.dart';
import 'package:uvbs/prefs.dart';
import 'package:uvbs/providers/favProvider.dart';
import 'package:uvbs/providers/playlistProvider.dart';
import 'package:uvbs/providers/provider.dart';
import 'package:uvbs/providers/userProvider.dart';
import 'package:uvbs/screens/Login.dart';
import 'package:uvbs/screens/Main.dart';
import 'package:uvbs/screens/Profile.dart';
import 'package:uvbs/screens/ecom/Checkout.dart';
import 'package:uvbs/screens/ecom/OrderDetail.dart';
import 'package:uvbs/screens/ecom/Orders.dart';
import 'package:uvbs/screens/ecom/ProductDetail.dart';
import 'package:uvbs/screens/ecom/Shipping.dart';
import 'package:uvbs/screens/stream/AudioDetail.dart';
import 'package:uvbs/screens/stream/FavVideoDetail.dart';
import 'package:uvbs/screens/stream/Stream.dart';
import 'package:uvbs/screens/ecom/Ecom.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uvbs/screens/stream/VideoDetail.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initPref();
  // WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => PlaylistProvider()),
      ],
      child: MyApp(),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var video = Provider.of<AppProvider>(context, listen: false).video;
    var audio = Provider.of<AppProvider>(context, listen: false).audio;
    var product = Provider.of<AppProvider>(context, listen: false).product;
    var order = Provider.of<AppProvider>(context, listen: false).order;

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
          link: GraphQLConfig.link,
          cache: GraphQLCache(store: InMemoryStore())),
    );
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/login': (context) => const Login(),
            '/home': (context) => const Main(),
            '/profile': (context) => const Profile(),
            '/stream': (context) => const Stream(),
            '/video': (context) => VideoDetail(vid: video),
            '/favVideo': (context) => FavVideoDetail(vid: video),
            '/audio': (context) => AudioDetail(aud: audio),
            '/ecom': (context) => const Ecom(),
            '/product': (context) => ProductDetail(product: product),
            '/checkout': (context) => const Checkout(),
            '/shipping': (context) => const MyShipping(),
            '/orders': (context) => const MyOrders(),
            '/order': (context) => OrderDetail(order: order),
          },
          theme: ThemeData(
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'Montserrat',
                ),
          ),
          home: const Scaffold(
            backgroundColor: Colors.white,
            body: Main(),
          )),
    );
  }
}
