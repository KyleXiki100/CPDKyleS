import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  static FirebaseDatabase _getDatabase() {
    return FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://petdb-6d1e5-default-rtdb.europe-west1.firebasedatabase.app/',
    );
  }

  static DatabaseReference get petsRef => _getDatabase().ref().child('pets');

  static Future<void> pushPetData(Map<String, dynamic> data) async {
    try {
      await petsRef.push().set(data);
    } catch (e) {
      rethrow;
    }
  }
}