import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pn_fl_jewellery_empire/screens/screens.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ghamloush Jewelery',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: primaryColor,
            primary: primaryColor,
          ),
          scaffoldBackgroundColor: whiteColor,
          primaryColor: primaryColor,
          fontFamily: 'Mukta',
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
        ),
        home: const SplashScreen(),
        onGenerateRoute: routes,
      ),
    );
  }

  Route<dynamic>? routes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
            child: const SplashScreen(),
            type: PageTransitionType.fade,
            settings: settings);
      case '/login':
        return PageTransition(
            child: const LoginScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      
      case '/bottombar':
        return PageTransition(
            child: const BottomBar(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/home':
        return PageTransition(
            child: const HomeScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/categoryProducts':
        return PageTransition(
            child: const CategoryProductsScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/productDetail':
        return PageTransition(
            child: const ProductDetailScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/search':
        return PageTransition(
            child: const SearchScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/searchFilter':
        return PageTransition(
            child: const SearchFilterScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/cart':
        return PageTransition(
            child: const CartScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      
      case '/success':
        return PageTransition(
            child: const SuccessScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/favourite':
        return PageTransition(
            child: const FavouriteScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      default:
        return null; // Return null if no route is found
    }
  }
}