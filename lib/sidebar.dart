import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0, // Adjust the shadow blur radius as needed
                spreadRadius:
                2.0, // Adjust the shadow spread radius as needed
              ),
            ],
          ),
          child: const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ZEBRA',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'The Printing App',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Rest of the Drawer items

        Container(
          height: MediaQuery.of(context).size.height - 120,
          color: Colors.amber,
          child: Container(
            child: Column(
              children: [
                ListTile(
                  title: const Row(
                    children: [
                      Icon(
                        Icons.print,
                        size: 24,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'PREVIOUS PRINTS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Add your onTap logic here
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(
                        Icons.person_2_rounded,
                        size: 24,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'PROFILE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
