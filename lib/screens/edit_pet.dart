import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cpdkylescicluna/services/database_service.dart';
import '/colors.dart';

class EditPetScreen extends StatefulWidget {
  final String petId;
  const EditPetScreen({Key? key, required this.petId}) : super(key: key);

  @override
  _EditPetScreenState createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  String petName = "";
  String age = "";
  String weight = "";
  String vaccineDate = "";
  String additionalInfo = "";
  String? imagePath;

  late DatabaseReference _petRef;

  @override
  void initState() {
    super.initState();
    _petRef = DatabaseService.petsRef.child(widget.petId);
    _loadPetData();
  }

  Future<void> _loadPetData() async {
    try {
      DataSnapshot snapshot = await _petRef.get();
      if (snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          petName = data['name'] ?? '';
          age = data['age']?.toString() ?? '';
          weight = data['weight']?.toString() ?? '';
          vaccineDate = data['vaccine'] ?? '';
          additionalInfo = data['info'] ?? '';
          imagePath = data['imagePath'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pet not found")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading pet data: ${e.toString()}")),
      );
    }
  }

  Future<void> _saveEdits() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _petRef.update({
          'name': petName,
          'age': age,
          'weight': weight,
          'vaccine': vaccineDate,
          'info': additionalInfo,
          // If needed, update imagePath here
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pet updated successfully")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating pet: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Pet"),
        backgroundColor: primaryColor, 
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: petName,
                      decoration: const InputDecoration(labelText: "Pet Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter pet name";
                        }
                        return null;
                      },
                      onSaved: (value) => petName = value!,
                    ),
                    TextFormField(
                      initialValue: age,
                      decoration: const InputDecoration(labelText: "Age"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter age";
                        }
                        return null;
                      },
                      onSaved: (value) => age = value!,
                    ),
                    TextFormField(
                      initialValue: weight,
                      decoration: const InputDecoration(labelText: "Weight (kg)"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter weight";
                        }
                        return null;
                      },
                      onSaved: (value) => weight = value!,
                    ),
                    TextFormField(
                      initialValue: vaccineDate,
                      decoration: const InputDecoration(labelText: "Last Vaccine Date"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the vaccine date";
                        }
                        return null;
                      },
                      onSaved: (value) => vaccineDate = value!,
                    ),
                    TextFormField(
                      initialValue: additionalInfo,
                      decoration: const InputDecoration(labelText: "Additional Information"),
                      onSaved: (value) => additionalInfo = value ?? "",
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveEdits,
                      child: const Text("Save Changes"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
