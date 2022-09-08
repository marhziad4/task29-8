// import 'package:flutter/material.dart';
// import 'package:todo_emp/widgets/drawer_list_tile.dart';
//
// Drawer buildDrawer(BuildContext context) {
//   // bool _darkMode = true;
//
//   return Drawer(
//     child: Padding(
//       padding: const EdgeInsets.all(33),
//       child: ListView(
//         children: [
//           SizedBox(
//             height: 30,
//           ),
//           ListTile(
//             // UserAccountsDrawerHeader(
//             //     currentAccountPicture: CircleAvatar(
//             //       backgroundColor: Colors.white,
//             //       child: Text('O'),
//             //     ),
//             //     accountName: Text('Omar'),
//             //     accountEmail: Text('omar@gmail.com')),
//             // leading: CircleAvatar(
//             //   radius: 30,
//             //   backgroundImage: AssetImage('assets/images/person.png'),
//             // ),
//             title: Text(
//               'Marah',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black,
//                 fontFamily: 'NotoNaskhArabic',
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Divider(
//             indent: 0,
//             endIndent: 50,
//             thickness: 1,
//             color: Colors.grey.shade300,
//           ),
//           DrawerListTile(
//             title: "HOME",
//             iconData: Icons.home,
//             onTab: () {
//               // RouterClass.routerClass.routingToSpecificWidgetWithoutPop(
//               //     MyHomePage());
//             },
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           DrawerListTile(
//             title: "settings",
//             iconData: Icons.settings,
//             onTab: () {
//               Navigator.pushReplacementNamed(context, '/MapScreen');
//
//
//             },
//           ),
//           Divider(),
//           DrawerListTile(
//               iconData: Icons.logout,
//               title: "Logout",
//               onTab: () async {
//                 // Provider.of<AppProvider>(context, listen: false).logOut();
//
//                 // await logout();
//                 // showSnackBar(
//                 //     context: context, content: 'Logout successfully');
//               }),
//         ],
//       ),
//     ),
//   );
// }
