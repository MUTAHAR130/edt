import 'package:edt/pages/authentication/signup/widgets/agree_row.dart';
import 'package:edt/pages/authentication/signup/widgets/phone_field.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:flutter/material.dart';

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
  TextEditingController vehicleType = TextEditingController();
  TextEditingController vehicleNumber = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController idProof = TextEditingController();
  TextEditingController drivingLicense = TextEditingController();
  TextEditingController vehicleRegistration = TextEditingController();
  TextEditingController vehiclePic = TextEditingController();
  int _currentStep = 0;

  final List<String> _labels = [
    'Personal\nInformation',
    'Vehicle\nInformation',
    'Upload\nDocuments',
  ];

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
            SizedBox(
              height: 20,
            ),
            Container(
              width: 120,
              height: 120,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              hintText: 'Full Name',
              controller: name,
            ),
            SizedBox(
              height: 20,
            ),
            PhoneInputField(
              controller: phone,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              hintText: 'Email',
              controller: email,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              hintText: 'Street',
              controller: street,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              hintText: 'City',
              // imagePath: 'assets/icons/arrow_down.svg',
              controller: city,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              hintText: 'District',
              // imagePath: 'assets/icons/arrow_down.svg',
              controller: district,
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
                onTap: () {
                  if (name.text.isEmpty ||
                      phone.text.isEmpty ||
                      email.text.isEmpty ||
                      street.text.isEmpty ||
                      city.text.isEmpty ||
                      district.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please fill in all the fields")),
                    );
                    return;
                  }
                  if (_currentStep < _labels.length - 1) {
                    _nextStep();
                  } else if (_currentStep > 0) {
                    _previousStep();
                  }
                },
                child: getContainer(context, 'Next'))
          ],
        );
      case 1:
        return Column(
          children: [
            SizedBox(
              height: 30,
            ),
            CustomTextFormField(
              hintText: 'Select Vehicle Type',
              imagePath: 'assets/icons/arrow_down.svg',
              controller: vehicleType,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              hintText: 'Vehicle Number',
              controller: vehicleNumber,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              hintText: 'Color',
              controller: color,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  if (vehicleType.text.isEmpty ||
                      vehicleNumber.text.isEmpty ||
                      color.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please fill in all the fields")),
                    );
                    return;
                  }
                  if (_currentStep < _labels.length - 1) {
                    _nextStep();
                  } else if (_currentStep > 0) {
                    _previousStep();
                  }
                },
                child: getContainer(context, 'Next')),
          ],
        );
      case 2:
        return Column(
          children: [
            SizedBox(
              height: 30,
            ),
            CustomTextFormField(
              hintText: 'ID Proof',
              imagePath: 'assets/icons/cloud.svg',
              controller: idProof,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              hintText: 'Driving License',
              imagePath: 'assets/icons/cloud.svg',
              controller: drivingLicense,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              hintText: 'Vehicle Registration Certificate',
              imagePath: 'assets/icons/cloud.svg',
              controller: vehicleRegistration,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              hintText: 'Vehicle Picture',
              imagePath: 'assets/icons/cloud.svg',
              controller: vehiclePic,
            ),
            SizedBox(
              height: 20,
            ),
            aggreeRow(),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  if (_currentStep < _labels.length - 1) {
                    _nextStep();
                  } else if (_currentStep > 0) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BottomBar()));
                  }
                },
                child: getContainer(context, 'Submit'))
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
}
