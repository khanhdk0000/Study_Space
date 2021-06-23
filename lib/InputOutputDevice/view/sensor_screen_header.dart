import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// class SensorScreenHeader extends StatelessWidget {
//   const SensorScreenHeader({
//     Key key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: MyClipper(),
//       child: Container(
//         height: 150,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF0D044E),
//               Color(0xFF09033a),
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               left: 10,
//               top: 50,
//               child: MenuButton(),
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: Text(
//                 'Your Devices',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 25,
//                     fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Positioned(
//               right: -10,
//               top: 10,
//               child: SvgPicture.asset(
//                 'assets/img/circuit-print-for-electronic-products.svg',
//                 color: Colors.white54,
//                 height: 100,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class MyClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, size.height - 60);
//     path.quadraticBezierTo(
//         size.width / 2, size.height, size.width, size.height - 60);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        child: Icon(Icons.menu, color: Colors.black87, size: 24.0),
      ),
    );
  }
}
