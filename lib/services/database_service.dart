import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  static Future<FirebaseDatabase> _initializeFirebase() async {
  
    await Firebase.initializeApp();
    return FirebaseDatabase.instanceFor(
      app: Firebase.app(), 
      databaseURL: 'https://petdb-6d1e5-default-rtdb.europe-west1.firebasedatabase.app/',
      
    );
  }

  static Future<DatabaseReference> get petsRef async {
    FirebaseDatabase database = await _initializeFirebase();
    return database.ref().child('pets');
  }

  static Future<void> pushPetData(Map<String, dynamic> data) async {
    try {
      DatabaseReference ref = await petsRef;
      await ref.push().set(data);
    } catch (e) {
      rethrow;
    }
  }
}
