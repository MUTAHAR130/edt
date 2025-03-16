import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const _jsonPath = "assets/edt.json";
  static const _fcmApi =
      "https://fcm.googleapis.com/v1/projects/edtapp-2e807/messages:send";
  static const List<String> _scopes = [
    "https://www.googleapis.com/auth/cloud-platform"
  ];

  // static Future<void> init() async {
  //   await _messaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );

  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     log('Got a message whilst in the foreground!');
  //     log('Message data: ${message.data}');

  //     if (message.notification != null) {
  //       log('Message also contained a notification: ${message.notification}');
  //     }
  //   });

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     log('Got a message whilst in the foreground!');
  //     log('Message data: ${message.data}');

  //     if (message.notification != null) {
  //       log('Message also contained a notification: ${message.notification}');
  //       // Call our local notification display method here (Step 4)
  //       showLocalNotification(message.notification?.title, message.notification?.body);
  //     }
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     log('A notification was tapped on: ${message.data}');
  //   });
  // }

  static Future<void> init() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings(
            'ic_icon');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        
      },
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
        showLocalNotification(
            message.notification?.title, message.notification?.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A notification was tapped on: ${message.data}');
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log("Handling a background message: ${message.messageId}");
  }

  static Future<String> _getAccessToken() async {
    try {
      final jsonCredentials = await rootBundle.loadString(_jsonPath);
      final accountCredentials =
          ServiceAccountCredentials.fromJson(jsonCredentials);

      var client = http.Client();
      AuthClient authClient =
          await clientViaServiceAccount(accountCredentials, _scopes);

      final accessToken = authClient.credentials.accessToken.data;
      client.close();

      return accessToken;
    } catch (e) {
      log('Error getting access token: $e');
      return '';
    }
  }

  static Future<void> showLocalNotification(String? title, String? body) async {
    log('Attempting to show local notification: title=$title, body=$body');

    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'Channel description',
        importance: Importance.max,
        priority: Priority.high,
        icon: 'ic_icon'
      );
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch %
            100000, 
        title,
        body,
        notificationDetails,
      );
      log('Local notification displayed successfully');
    } catch (e) {
      log('Error showing local notification: $e');
    }
  }

  static Future<List<String>> _getUserTokens(String uid, String role) async {
    try {
      final collection = role == 'driver' ? 'drivers' : 'passengers';
      final userDoc = await _firestore.collection(collection).doc(uid).get();

      if (userDoc.exists && userDoc.data()!.containsKey('tokens')) {
        List<dynamic> tokensList = userDoc.data()!['tokens'];
        return tokensList.cast<String>();
      }
      return [];
    } catch (e) {
      log('Error getting user tokens: $e');
      return [];
    }
  }

  static Future<void> storeNotification(
      String uid, String title, String body, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': uid,
        'title': title,
        'body': body,
        'data': data,
        'read': false,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log('Error storing notification: $e');
    }
  }

  static Future<void> _removeTokenFromDatabase(
      String token, String uid, String role) async {
    try {
      final collection = role == 'driver' ? 'drivers' : 'passengers';
      await _firestore.collection(collection).doc(uid).update({
        'tokens': FieldValue.arrayRemove([token])
      });
    } catch (e) {
      log('Error removing token: $e');
    }
  }

  static Future<void> sendNotification({
    required String uid,
    required String role,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    log('INSIDE SEND NOTIFICATION METHOD');
    List<String> tokens = await _getUserTokens(uid, role);
    if (tokens.isEmpty) {
      log('No tokens found for user: $uid');
      return;
    }

    String accessToken = await _getAccessToken();
    if (accessToken.isEmpty) {
      log('Failed to get access token');
      return;
    }

    for (String token in tokens) {
      Map<String, dynamic> notificationPayload = {
        "message": {
          "token": token,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": data ?? {},
        }
      };

      try {
        final response = await http.post(
          Uri.parse(_fcmApi),
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
          body: jsonEncode(notificationPayload),
        );

        if (response.statusCode == 200) {
          log('Notification sent successfully to $token');
          await storeNotification(uid, title, body, data ?? {});
        } else {
          log('Error sending notification: ${response.statusCode}, ${response.body}');

          if (response.statusCode == 404) {
            final responseBody = jsonDecode(response.body);
            final errorCode =
                responseBody['error']?['details']?[0]?['errorCode'];
            if (errorCode == 'UNREGISTERED') {
              log('Token is unregistered. Removing token from database.');
              await _removeTokenFromDatabase(token, uid, role);
            }
          }
        }
      } catch (e) {
        log('Exception sending notification: $e');
      }
    }
  }

  // Send payment notification based on payment status
  static Future<void> sendPaymentNotification({
    required String passengerId,
    required String driverId,
    required String amount,
    required String status,
    required String paymentId,
    required String rideId,
    String? currentUserId,
  }) async {
    try {

      bool isCompleted = status.toLowerCase() == 'completed';
      String passengerTitle =
          isCompleted ? 'Payment Successful' : 'Payment Failed';
      String driverTitle = isCompleted ? 'Payment Received' : 'Payment Failed';

      String passengerBody = isCompleted
          ? 'Your payment of \$${amount} has been processed successfully.'
          : 'Your payment of \$${amount} was cancelled or failed.';

      String driverBody = isCompleted
          ? 'You received a payment of \$${amount} from your passenger.'
          : 'A payment of \$${amount} from your passenger was cancelled or failed.';

      Map<String, dynamic> notificationData = {
        'type': 'payment',
        'paymentId': paymentId,
        'amount': amount,
        'status': status.toLowerCase(),
        'rideId': rideId,
      };

      // Add to history collection
      // await addRideToHistory(
      //   driverId: driverId,
      //   passengerId: passengerId,
      //   price: amount,
      //   rideId: rideId,
      //   status: status.toLowerCase(),
      //   vehicleName: vehicleName,
      // );

      if (currentUserId == passengerId) {
      await showLocalNotification(passengerTitle, passengerBody);
    }
      await sendNotification(
        uid: passengerId,
        role: 'passenger',
        title: passengerTitle,
        body: passengerBody,
        data: notificationData,
      );

      await sendNotification(
        uid: driverId,
        role: 'driver',
        title: driverTitle,
        body: driverBody,
        data: notificationData,
      );
    } catch (e) {
      log('Error sending payment notification: $e');
    }
  }
}
