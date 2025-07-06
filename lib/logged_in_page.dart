import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'sign_in_page.dart';

class LoggedInPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final User? user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => SignInPage()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (user.photoURL != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoURL!),
                      radius: 40,
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Hello, ${user.displayName ?? 'User'}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(user.email ?? '', style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: Icon(Icons.logout),
                    label: Text("Sign Out"),
                    onPressed: () async {
                      await _authService.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => SignInPage()),
                      );
                    },
                  ),
                ],
              )
            : Text("No user info available"),
      ),
    );
  }
}
