import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_apartments_finder/providers/dark_theme_provider.dart';
import 'package:rental_apartments_finder/providers/note_provider.dart';
import 'package:rental_apartments_finder/providers/place_provider.dart';
import 'package:rental_apartments_finder/providers/property_list_provider.dart';
import 'package:rental_apartments_finder/providers/rentlist_provider.dart';
import 'package:rental_apartments_finder/providers/wishlist_provider.dart';
import 'package:rental_apartments_finder/screens/address/address_book_screen.dart';
import 'package:rental_apartments_finder/screens/home_screen.dart';
import 'package:rental_apartments_finder/screens/messages/messaging_main_screen.dart';
import 'package:rental_apartments_finder/screens/notes/note_list_screen.dart';
import 'package:rental_apartments_finder/screens/stores/checkout_screen.dart';
import 'package:rental_apartments_finder/screens/stores/notification_screen.dart';
import 'package:rental_apartments_finder/screens/store_main_screen.dart';
import 'package:rental_apartments_finder/screens/stores/rent_list_screen.dart';
import 'package:rental_apartments_finder/screens/stores/wishlist_screen.dart';
import 'package:rental_apartments_finder/screens/users/recover_password_screen.dart';
import 'package:rental_apartments_finder/services/notifications/push_notification_service.dart';
import 'constants/theme_data.dart';
import 'models/places/address.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider darkThemeProvider = new DarkThemeProvider();

  void getCurrentAppTheme() async {
    darkThemeProvider.setDarkTheme(await darkThemeProvider.getTheme());
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => darkThemeProvider),
        ChangeNotifierProvider(create: (context) => PropertiesListProvider()),
        ChangeNotifierProvider(create: (context) => RentListProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => Address.empty()),
        ChangeNotifierProvider(create: (context) => PlaceProvider()),
        ChangeNotifierProvider(create: (context) => NoteProvider()),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeData, child) {
          return MaterialApp(
            theme: Styles.themeData(false, context),
            title: "Social Media",
            routes: {
              '/': (context) => HomeScreen(),
              '/store_main_screen': (context) => StoreMainScreen(),
              '/RentList_screen': (context) => RentListScreen(),
              '/wishlist_screen': (context) => WishlistScreen(),
              '/recover_password_screen': (context) => RecoverPasswordScreen(),
              '/checkout_screen': (context) => CheckoutScreen(),
              '/address_book_screen': (context) => AddressBookScreen(),
              '/notification_screen': (context) => NotificationScreen(),
              '/messaging_main_screen': (context) =>
                  const MessagingMainScreen(),
              '/note_list_screen': (context) => const NoteListScreen(),
            },
          );
        },
      ),
    );
  }

  Future<void> getPushNotifications() async {
    PushNotificationService notificationService = new PushNotificationService();
    notificationService.getToken();
    notificationService.initialize();
  }
}
