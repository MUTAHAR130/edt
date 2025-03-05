import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/home/widgets/payment_success.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PayPalService {
  final String clientId =
      'AYvLV348BZ63EPC4ZQ1WHpGD2rg82LW1R11whJze82pbY4i_Vdv0LDdndQnYFvp-a6WDvNCFpNS1ewcB';
  final String secret =
      'EM5NuRndVOCMh0LKZB7fk9TeoGZAjY0oEgL49PrUtTgCX3osfCIyq_IFgKVc-5KhWyYePtz6BGIlWK0R';
  final String sandboxUrl = 'https://api.sandbox.paypal.com';
  String? passengerUid;
  String? driverUid;
  double? amountPaid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserExpenses(
      String passengerId, String driverId, double amount) async {
    try {
      DocumentReference passengerDoc =
          _firestore.collection('passengers').doc(passengerId);
      DocumentSnapshot passengerSnapshot = await passengerDoc.get();
      if (passengerSnapshot.exists) {
        double currentExpense = (passengerSnapshot.data() as Map<String, dynamic>)['totalExpense'] ?? 0.0;


        double updatedExpense = currentExpense + amount;
        await passengerDoc.update({'totalExpense': updatedExpense});
      }

      DocumentReference driverDoc =
          _firestore.collection('drivers').doc(driverId);
      DocumentSnapshot driverSnapshot = await driverDoc.get();
      if (driverSnapshot.exists) {
        double currentEarnings = (driverSnapshot.data() as Map<String, dynamic>)['totalEarnings'] ?? 0.0;
        double updatedEarnings = currentEarnings + amount;
        await driverDoc.update({'totalEarnings': updatedEarnings});
      }
    } catch (e) {
      print('Error updating Firebase: $e');
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final response = await http.post(
        Uri.parse('$sandboxUrl/v1/oauth2/token'),
        headers: {
          'Accept': 'application/json',
          'Accept-Language': 'en_US',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$clientId:$secret'))}',
        },
        body: {'grant_type': 'client_credentials'},
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return body['access_token'];
      }
      print('Failed to get Access Token: ${response.body}');
      return null;
    } catch (e) {
      print('Exception in getAccessToken: $e');
      return null;
    }
  }

  Future<PaymentResult> createPayment({
    required String amount,
    required String currency,
    required String passengerId,
    required String driverId,
    String returnUrl = 'https://example.com/success',
    String cancelUrl = 'https://example.com/cancel',
  }) async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null) {
        return PaymentResult(
            success: false, message: 'Failed to obtain access token');
      }

      final url = '$sandboxUrl/v1/payments/payment';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          "intent": "sale",
          "payer": {"payment_method": "paypal"},
          "transactions": [
            {
              "amount": {
                "total": amount,
                "currency": currency,
                "details": {"subtotal": amount}
              },
              "description": "Payment from Passenger to Driver",
              "item_list": {
                "items": [
                  {
                    "name": "Ride Payment",
                    "quantity": "1",
                    "price": amount,
                    "currency": currency
                  }
                ]
              }
            }
          ],
          "redirect_urls": {"return_url": returnUrl, "cancel_url": cancelUrl}
        }),
      );

      print('Payment Creation Response: ${response.body}');
      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 201) {
        final body = json.decode(response.body);
        String? approvalUrl;
        String? paymentId;

        for (var link in body['links']) {
          if (link['rel'] == 'approval_url') {
            approvalUrl = link['href'];
          }
        }

        paymentId = body['id'];

        if (approvalUrl == null || paymentId == null) {
          return PaymentResult(
              success: false, message: 'Approval URL or Payment ID not found');
        }

        double amountPai = double.tryParse(amount) ?? 0.0;

        passengerUid = passengerId;
        driverUid = driverId;
        amountPaid = amountPai;

        await FirebaseFirestore.instance
            .collection('payments')
            .doc(paymentId)
            .set({
          'passengerId': passengerId,
          'driverId': driverId,
          'amount': amount,
          'currency': currency,
          'paymentId': paymentId,
          'status': 'Pending',
          'timestamp': DateTime.now(),
          'approvalUrl': approvalUrl
        });

        return PaymentResult(
            success: true, paymentId: paymentId, approvalUrl: approvalUrl);
      } else {
        return PaymentResult(
            success: false,
            message: 'Payment creation failed: ${response.body}');
      }
    } catch (e) {
      print('Exception in createPayment: $e');
      return PaymentResult(
          success: false, message: 'An unexpected error occurred: $e');
    }
  }

  Future<PaymentVerificationResult> verifyPayment(
      String paymentId, BuildContext context) async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null) {
        return PaymentVerificationResult(
            success: false, message: 'Failed to obtain access token');
      }

      final url = '$sandboxUrl/v1/payments/payment/$paymentId';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('Verify Payment Response Status Code: ${response.statusCode}');
      print('Verify Payment Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        String state = body['state']?.toLowerCase() ?? '';
        String payerStatus = body['payer']?['status']?.toLowerCase() ?? '';

        bool isActuallyPaid = state == 'approved' ||
            state == 'completed' ||
            payerStatus == 'verified';

        if (isActuallyPaid) {
          await FirebaseFirestore.instance
              .collection('payments')
              .doc(paymentId)
              .update({
            'status': 'Completed',
            'verifiedAt': DateTime.now(),
            'paypalState': state,
            'payerStatus': payerStatus
          });

          if (isActuallyPaid) {
            var paymentSnapshot = await FirebaseFirestore.instance
                .collection('payments')
                .doc(paymentId)
                .get();

            String passengerId = paymentSnapshot['passengerId'];
            String driverId = paymentSnapshot['driverId'];
            double amount = double.tryParse(paymentSnapshot['amount']) ?? 0.0;

            await updateUserExpenses(passengerId, driverId, amount);
            showPaymentSuccess(amount.toString());

          }

          return PaymentVerificationResult(
              success: true, message: 'Payment verified successfully');
        } else {
          await FirebaseFirestore.instance
              .collection('payments')
              .doc(paymentId)
              .update({
            'status': 'Cancelled',
            'paypalState': state,
            'payerStatus': payerStatus
          });

          return PaymentVerificationResult(
              success: false,
              message: 'Payment not completed. Current state: $state');
        }
      } else {
        return PaymentVerificationResult(
            success: false, message: 'Failed to verify payment');
      }
    } catch (e) {
      print('Exception in verifyPayment: $e');
      return PaymentVerificationResult(
          success: false, message: 'An unexpected error occurred: $e');
    }
  }

  Future<void> checkPendingPayments(BuildContext context) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('payments')
          .where('status', isEqualTo: 'Pending')
          .get();

      print('Pending Payments Found: ${snapshot.docs.length}');

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          String paymentId = doc['paymentId'];
          print('Checking Payment ID: $paymentId');
          await verifyPayment(paymentId, context);
        }
      }
    } catch (e) {
      print('Exception in checkPendingPayments: $e');
    }
  }
}

// Custom result classes for better error handling
class PaymentResult {
  final bool success;
  final String? paymentId;
  final String? approvalUrl;
  final String? message;

  PaymentResult(
      {required this.success, this.paymentId, this.approvalUrl, this.message});
}

class PaymentVerificationResult {
  final bool success;
  final String message;

  PaymentVerificationResult({required this.success, required this.message});
}
