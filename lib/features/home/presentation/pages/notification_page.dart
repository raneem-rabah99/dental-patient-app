import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Optional: Uncomment if you're getting the token from storage
// import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notifications = [];
  bool isLoading = true;

  // Replace this with your actual token from Postman or login response
  final String token = '2457|8Osr377Q71V2FlRjaBzKOWAsIo9Gi55iSdT0MduU8d06814d';

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final url = Uri.parse(
      'http://94.72.98.154/abdulrahim/public/api/notifications',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          notifications = data['data'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        print('Failed to load notifications. Status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(fontFamily: 'Serif', color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : notifications.isEmpty
              ? Center(child: Text('No notifications'))
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationCard(notification);
                },
              ),
    );
  }

  Widget _buildNotificationCard(dynamic notification) {
    final DateTime createdAt = DateTime.parse(notification['created_at']);
    final String formattedDate =
        '${createdAt.day}-${createdAt.month}-${createdAt.year}';

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/user_avatar.png'),
              radius: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['title'] ?? 'No Title',
                    style: TextStyle(
                      fontFamily: 'Serif',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification['body'] ?? '',
                    style: TextStyle(
                      fontFamily: 'Serif',
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      formattedDate,
                      style: TextStyle(
                        fontFamily: 'Serif',
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
