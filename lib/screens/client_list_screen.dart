import 'package:cpdkylescicluna/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import '/colors.dart';
import 'dart:async';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  _ClientListScreenState createState() => _ClientListScreenState();
}

 class _ClientListScreenState extends State<ClientListScreen> {
   final DatabaseReference _dbRef = DatabaseService.petsRef;
   StreamSubscription<DatabaseEvent>? _petsSubscription;
   List<Map<String, dynamic>> _petData = [];
   bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

   @override
   void dispose() {
     _petsSubscription?.cancel();
     super.dispose();
   }

  void _fetchPets() {
    
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final List<Map<String, dynamic>> loadedPets = [];
        data.forEach((key, value) {
          loadedPets.add({
            'id': key,
            'name': value['name'] ?? 'Unknown',
            'age': value['age'] ?? '',
            'weight': value['weight'] ?? '',
            'vaccine': value['vaccine'] ?? '',
            'info': value['info'] ?? '',
            'imagePath': value['imagePath']
          });
        });

        setState(() {
          _petData = loadedPets;
          _isLoading = false;
        });
      } else {
        setState(() {
          _petData = [];
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet List"),
        backgroundColor: primaryColor,
      ),
      backgroundColor: primaryColor2,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _petData.isEmpty
              ? const Center(child: Text("No pets found"))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _petData.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 20),
                  itemBuilder: (context, index) {
                    final pet = _petData[index];
                    return _PetCard(
                      petId: pet['id'],
                      petName: pet['name'],
                      age: pet['age'],
                      weight: pet['weight'],
                      vaccineDate: pet['vaccine'],
                      additionalInfo: pet['info'],
                      imagePath: pet['imagePath'],
                    );
                  },
                ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final String petId;
  final String petName;
  final String age;
  final String weight;
  final String vaccineDate;
  final String additionalInfo;
  final String? imagePath;


  const _PetCard({
    required this.petId,
    required this.petName,
    required this.age,
    required this.weight,
    required this.vaccineDate,
    required this.additionalInfo,
    this.imagePath,
  });

  void _deletePet(BuildContext context) async {
        final DatabaseReference petRef = DatabaseService.petsRef.child(petId);

    try {
      await petRef.remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$petName deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting pet: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(File(imagePath!), fit: BoxFit.cover),
                        )
                      : const Icon(Icons.pets, size: 40, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        petName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Age: $age years, Weight: $weight kg",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Last Vaccine: $vaccineDate",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (additionalInfo.isNotEmpty) ...[
              const Text(
                "Additional Information:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                additionalInfo,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
              const SizedBox(height: 12),
            ],
            const Divider(),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deletePet(context),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

