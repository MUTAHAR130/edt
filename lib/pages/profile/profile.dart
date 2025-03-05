import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:edt/pages/bottom_bar/provider/profile_provider.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';

class ProfileScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ProfileScreen({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for profile fields.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  File? _newProfileImage;
  String _profileImageUrl = '';

  final ImagePicker _picker = ImagePicker();

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final profileProvider = Provider.of<UserProfileProvider>(context, listen: false);
      final roleProvider = Provider.of<UserRoleProvider>(context, listen: false);
      String collectionName = roleProvider.role == 'Driver' ? 'drivers' : 'passengers';
      if (!profileProvider.isLoaded) {
        profileProvider.loadUserProfile(collectionName).then((_) {
          _populateControllers();
        });
      } else {
        _populateControllers();
      }
      _isInitialized = true;
    }
  }

  void _populateControllers() {
    final profile = Provider.of<UserProfileProvider>(context, listen: false);
    nameController.text = profile.username;
    emailController.text = profile.email;
    phoneController.text = profile.phone;
    cityController.text = profile.city;
    _profileImageUrl = profile.profileImage;
  }

  Future<void> _pickProfileImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newProfileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadProfileImage(String folder) async {
    if (_newProfileImage != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child(folder).child(fileName);
      UploadTask uploadTask = ref.putFile(_newProfileImage!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    return null;
  }

  Future<void> _updateProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    var roleProvider = Provider.of<UserRoleProvider>(context, listen: false);
    String role = roleProvider.role;
    String collectionName = role == 'Driver' ? 'drivers' : 'passengers';
    String folder = role == 'Driver' ? "driver_images" : "passenger_images";

    EasyLoading.show(status: "Updating profile...");
    try {
      String? newImageUrl = await _uploadProfileImage(folder);
      String updatedImageUrl = newImageUrl ?? _profileImageUrl;
      Map<String, dynamic> updateData = {
        'email': emailController.text,
        'phone': phoneController.text,
        'city': cityController.text,
      };
      if (role == 'Driver') {
        updateData['fullname'] = nameController.text;
        updateData['driverImage'] = updatedImageUrl;
      } else {
        updateData['username'] = nameController.text;
        updateData['passengerImage'] = updatedImageUrl;
      }
      await FirebaseFirestore.instance.collection(collectionName).doc(currentUser.uid).update(updateData);
      EasyLoading.showSuccess("Profile updated successfully");
      // Update the provider.
      Provider.of<UserProfileProvider>(context, listen: false).updateProfile(
        username: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        city: cityController.text,
        profileImage: updatedImageUrl,
      );
    } catch (e) {
      EasyLoading.showError(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<UserRoleProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        primary: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                final scaffold = Scaffold.of(context);
                if (scaffold.hasDrawer) {
                  scaffold.openDrawer();
                } else {
                  widget.scaffoldKey.currentState?.openDrawer();
                }
              },
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xffe7f0fc),
                ),
                child: Center(
                  child: SvgPicture.asset('assets/icons/bars.svg'),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            color: Color(0xff2a2a2a),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              GestureDetector(
                onTap: _pickProfileImage,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 138,
                      height: 138,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        image: _newProfileImage != null
                            ? DecorationImage(
                                image: FileImage(_newProfileImage!),
                                fit: BoxFit.cover,
                              )
                            : (_profileImageUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(_profileImageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                      ),
                      child: (_newProfileImage == null && _profileImageUrl.isEmpty)
                          ? Center(
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                Provider.of<UserProfileProvider>(context).username,
                style: GoogleFonts.poppins(
                  color: Color(0xff5a5a5a),
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                ),
              ),
              SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: roleProvider.role == 'Driver' ? 'Full Name' : 'Username',
                  hintStyle: GoogleFonts.poppins(
                    color: Color(0xffb8b8b8),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: GoogleFonts.poppins(
                    color: Color(0xffb8b8b8),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Phone',
                  hintStyle: GoogleFonts.poppins(
                    color: Color(0xffb8b8b8),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  hintText: 'City',
                  hintStyle: GoogleFonts.poppins(
                    color: Color(0xffb8b8b8),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
                  ),
                ),
              ),
              SizedBox(height: 32),
              GestureDetector(
                onTap: _updateProfile,
                child: getContainer(context, 'Update'),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
