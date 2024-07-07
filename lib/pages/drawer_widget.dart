import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width;
    double sHeight = MediaQuery.of(context).size.height;
    List<String> listDrawn = ['weather', 'profile', 'city', 'privacy', 'exit'];
    return Drawer(
      width: sWidth * 0.4,
      backgroundColor: const Color.fromARGB(255, 0, 170, 255),
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            width: sWidth * 0.10,
            height: sHeight * 0.12,
            child: const DrawerHeader(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 0, 170, 255)),
              margin: EdgeInsets.all(0),
              child: Text('MENU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
          for (String section in listDrawn)
            ListTile(
              onTap: () {},
              tileColor: const Color.fromARGB(255, 0, 170, 255),
              title: Text(
                section,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            )
        ],
      ),
    );
  }
}
