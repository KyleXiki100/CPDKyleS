import 'package:flutter/material.dart';
import '/screens/quick_access_button.dart';
import '/screens/insert_pet_screen.dart';
import '/screens/client_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QuickAccessButton(
              label: "Insert Pet",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InsertPetScreen()),
                );
              },
            ),
            const SizedBox(height: 10),
            QuickAccessButton(
              label: "Client List",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClientListScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
