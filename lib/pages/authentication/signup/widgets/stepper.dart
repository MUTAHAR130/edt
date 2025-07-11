import 'dart:io';

import 'package:edt/pages/authentication/signup/provider/signup_provider.dart';
import 'package:edt/pages/authentication/signup/set_password.dart';
import 'package:edt/pages/authentication/signup/widgets/agree_row.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CustomStepperWidget extends StatefulWidget {
  const CustomStepperWidget({super.key});

  @override
  State<CustomStepperWidget> createState() => _CustomStepperWidgetState();
}

class _CustomStepperWidgetState extends State<CustomStepperWidget> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController vehicleName = TextEditingController();
  TextEditingController vehicleType = TextEditingController();
  TextEditingController vehicleNumber = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController idProof = TextEditingController();
  TextEditingController drivingLicense = TextEditingController();
  TextEditingController vehicleRegistration = TextEditingController();
  TextEditingController vehiclePic = TextEditingController();
  TextEditingController driverImage = TextEditingController();
  int _currentStep = 0;

  final List<String> _labels = [
    'Personal\nInformation',
    'Vehicle\nInformation',
    'Upload\nDocuments',
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDriverImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      driverImage.text=pickedFile.path;
      Provider.of<SignupProvider>(context, listen: false)
          .setDriverImage(pickedFile.path);
    }
  }

  Future<void> _pickImageForField(TextEditingController controller) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      controller.text = pickedFile.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: SizedBox(
        child: Column(
          children: [
            Row(
              children: List.generate(_labels.length * 2 - 1, (index) {
                if (index % 2 == 0) {
                  return _buildStep(index ~/ 2);
                } else {
                  return _buildDivider();
                }
              }),
            ),
            Expanded(
              child: Center(
                child: _buildStepContent(_currentStep),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int index) {
    bool isActive = index == _currentStep;
    bool isCompleted = index < _currentStep;
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Color(0xffcfe1f8) : Color(0xffEBEBEB),
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check,
                    color: Color(0xff163051),
                  )
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isActive ? Color(0xff0F69DB) : Color(0xff999999),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          _labels[index],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Color(0xff0F69DB) : Color(0xff999999),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 2,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildStepContent(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return Column(
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: _pickDriverImage,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      image: Provider.of<SignupProvider>(context).driverImage !=
                              null
                          ? DecorationImage(
                              image: FileImage(File(
                                  Provider.of<SignupProvider>(context)
                                      .driverImage!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child:
                        Provider.of<SignupProvider>(context).driverImage == null
                            ? Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              )
                            : null,
                  ),
                  Positioned(
                    bottom: -5,
                    right: -5,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'Full Name',
              controller: name,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'Write phone with country code',
              keyboardType: TextInputType.phone,
              controller: phone,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'Email',
              controller: email,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'Street',
              controller: street,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'City',
              controller: city,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'District',
              controller: district,
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                if (name.text.isEmpty ||
                    phone.text.isEmpty ||
                    email.text.isEmpty ||
                    street.text.isEmpty ||
                    city.text.isEmpty ||
                    district.text.isEmpty) {
                  EasyLoading.showError("Please fill in all the fields");
                  return;
                } else {
                  var signupPro =
                      Provider.of<SignupProvider>(context, listen: false);
                  signupPro.setDriverValue1(
                      name.text,
                      phone.text,
                      email.text,
                      street.text,
                      city.text,
                      district.text,
                      driverImage.text);
                }
                if (_currentStep < _labels.length - 1) {
                  _nextStep();
                } else if (_currentStep > 0) {
                  _previousStep();
                }
              },
              child: getContainer(context, 'Next'),
            )
          ],
        );
      case 1:
        return Column(
          children: [
            SizedBox(height: 30),
            CustomTextFormField(
              hintText: 'Vehicle Name',
              controller: vehicleName,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'Select Vehicle Type',
              imagePath: 'assets/icons/arrow_down.svg',
              controller: vehicleType,
              enabled: false,
              onTap: () {
                _showVehicleType(context);
              },
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'Vehicle Number',
              controller: vehicleNumber,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'Color',
              controller: color,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (vehicleName.text.isEmpty || vehicleType.text.isEmpty ||
                    vehicleNumber.text.isEmpty ||
                    color.text.isEmpty) {
                  EasyLoading.showError("Please fill in all the fields");
                  return;
                } else {
                  var signupPro =
                      Provider.of<SignupProvider>(context, listen: false);
                  signupPro.setDriverValue2(
                      vehicleName.text, vehicleType.text, vehicleNumber.text, color.text);
                }
                if (_currentStep < _labels.length - 1) {
                  _nextStep();
                } else if (_currentStep > 0) {
                  _previousStep();
                }
              },
              child: getContainer(context, 'Next'),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            SizedBox(height: 30),
            CustomTextFormField(
              hintText: 'ID Proof',
              imagePath: 'assets/icons/cloud.svg',
              controller: idProof,
              enabled: false,
              onTap: () {
                _pickImageForField(idProof);
              },
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'Driving License',
              imagePath: 'assets/icons/cloud.svg',
              controller: drivingLicense,
              enabled: false,
              onTap: () {
                _pickImageForField(drivingLicense);
              },
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'Vehicle Registration Certificate',
              imagePath: 'assets/icons/cloud.svg',
              controller: vehicleRegistration,
              enabled: false,
              onTap: () {
                _pickImageForField(vehicleRegistration);
              },
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'Vehicle Picture',
              imagePath: 'assets/icons/cloud.svg',
              controller: vehiclePic,
              enabled: false,
              onTap: () {
                _pickImageForField(vehiclePic);
              },
            ),
            SizedBox(height: 20),
            aggreeRow(),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (idProof.text.isEmpty ||
                    drivingLicense.text.isEmpty ||
                    vehicleRegistration.text.isEmpty ||
                    vehiclePic.text.isEmpty) {
                  EasyLoading.showError("Please fill in all the fields");
                  return;
                } else {
                  var signupPro =
                      Provider.of<SignupProvider>(context, listen: false);
                  signupPro.setDriverValue3(idProof.text, drivingLicense.text,
                      vehicleRegistration.text, vehiclePic.text);
                }
                if (_currentStep < _labels.length - 1) {
                  _nextStep();
                } else if (_currentStep > 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetPassword(role: 'Driver'),
                    ),
                  );
                }
              },
              child: getContainer(context, 'Submit'),
            )
          ],
        );
      default:
        return Text('Unknown step.');
    }
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < _labels.length - 1) {
        _currentStep++;
      }
    });
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  void _showVehicleType(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                title: Text('Car', style: GoogleFonts.poppins(fontSize: 16)),
                onTap: () {
                  setState(() {
                    vehicleType.text = 'Car';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Motorcycle',
                    style: GoogleFonts.poppins(fontSize: 16)),
                onTap: () {
                  setState(() {
                    vehicleType.text = 'Motorcycle';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Van', style: GoogleFonts.poppins(fontSize: 16)),
                onTap: () {
                  setState(() {
                    vehicleType.text = 'Van';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
