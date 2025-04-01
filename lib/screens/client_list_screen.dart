// screens/client_list_screen.dart
import 'package:flutter/material.dart';
import 'dart:io';
import '/colors.dart';

class ClientListScreen extends StatelessWidget {
  const ClientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Dummy data for now
    final List<Map<String, dynamic>> petData = [
      {
        'name': 'Max',
        'age': '3',
        'weight': '12',
        'vaccine': '2024-01-15',
        'info': 'Friendly golden retriever',
        'imagePath': null, 
        'clientName': 'John Doe',
        'email': 'john@example.com',
      },
      {
        'name': 'Bella',
        'age': '2',
        'weight': '8',
        'vaccine': '2024-02-20',
        'info': 'Playful tabby cat',
        'imagePath': null,
        'clientName': 'Jane Smith',
        'email': 'jane@example.com',
      },
      
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet List"),
        backgroundColor: primaryColor,
      ),
      backgroundColor: primaryColor2,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: petData.length,
        separatorBuilder: (context, index) => const Divider(height: 20),
        itemBuilder: (context, index) {
          final pet = petData[index];
          return _PetCard(
            petName: pet['name'],
            age: pet['age'],
            weight: pet['weight'],
            vaccineDate: pet['vaccine'],
            additionalInfo: pet['info'],
            imagePath: pet['imagePath'],
            clientName: pet['clientName'],
            email: pet['email'],
          );
        },
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final String petName;
  final String age;
  final String weight;
  final String vaccineDate;
  final String additionalInfo;
  final String? imagePath;
  final String clientName;
  final String email;

  const _PetCard({
    required this.petName,
    required this.age,
    required this.weight,
    required this.vaccineDate,
    required this.additionalInfo,
    this.imagePath,
    required this.clientName,
    required this.email,
  });

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
                // Pet Image
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
                
                // Pet Details
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
                      Row(
                        children: [
                          Text(
                            "Age: $age years",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "Weight: $weight kg",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Last Vaccine: $vaccineDate",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Additional Info
            if (additionalInfo.isNotEmpty) ...[
              const Text(
                "Additional Information:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                additionalInfo,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
            ],
            
            // Client Info
            const Divider(),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Owner: $clientName",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: primaryColor,
                  onPressed: () {
                   
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                   
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
