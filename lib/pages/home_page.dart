import 'package:flutter/material.dart';
import 'package:flutter_login/components/logo.dart';
import 'package:flutter_login/pages/main_page.dart';

// 로고 os로 돌리면 깨짐
class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 200),
            logo("MILESTONE"),
            SizedBox(height: 50),
            TextButton(
              onPressed: () {
                //Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: Text("Get Started"),
            )
          ],
        ),
      ),
    );
  }
}
