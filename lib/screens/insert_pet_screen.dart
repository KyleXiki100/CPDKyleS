import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '/colors.dart';
import '/screens/client_list_screen.dart';
import '/services/database_service.dart';

class InsertPetScreen extends StatefulWidget {
  const InsertPetScreen({super.key});
  
  @override
  InsertPetScreenState createState() => InsertPetScreenState();
}

class InsertPetScreenState extends State<InsertPetScreen> {
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petBreedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _vaccineController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();

  File? _petImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _petImage = File(pickedFile.path));
    }
  }

  void _submitForm() async {
  if (_petNameController.text.isEmpty) {
    _showError('Pet name is required');
    return;
  }

  final petData = {
    'name': _petNameController.text,
    'breed': _petBreedController.text,
    'age': _ageController.text,
    'weight': _weightController.text,
    'vaccine': _vaccineController.text,
    'info': _infoController.text,
    'imagePath': _petImage?.path
  };

  try {
    print("Submitting pet data: $petData");
    await DatabaseService.pushPetData(petData);
    print("Data pushed successfully!");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ClientListScreen()),
    );
  } catch (error) {
    _showError('Failed to save pet: ${error.toString()}');
  }
}

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _petImage == null
                    ? Center(
                        child: Text(
                          "Tap to Add Image",
                          style: TextStyle(
                            color: Colors.brown[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_petImage!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageButton("CAMERA", Icons.camera_alt, 
                  () => _pickImage(ImageSource.camera)),
                const SizedBox(width: 20),
                _buildImageButton("GALLERY", Icons.photo_library, 
                  () => _pickImage(ImageSource.gallery)),
              ],
            ),
            const SizedBox(height: 30),
            _buildTextField("Pet Name", _petNameController),
            _buildTextField("Pet Breed", _petBreedController),
            _buildTextField("Age", _ageController),
            _buildTextField("Weight (kg)", _weightController),
            _buildTextField("Last Vaccine Date", _vaccineController),
            _buildTextField("Additional Info", _infoController),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  "SAVE PROFILE",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.black),
      label: Text(text, style: const TextStyle(color: Colors.black)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}