// // invitation_page.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:texans_web/ScreenUtils/screen_utils.dart';
// import 'package:texans_web/widgets/wp_button.dart';

// class InvitationPage extends StatefulWidget {
//   const InvitationPage({super.key});

//   @override
//   State<InvitationPage> createState() => _InvitationPageState();
// }

// class _InvitationPageState extends State<InvitationPage> {
//   // @override
//   // void initState() {
//   //   super.initState();

//   // }

//   // @override
//   // void dispose() {
//   //   for (final t in _otpControllers) {
//   //     t.dispose();
//   //   }
//   //   _controller.dispose();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           // Use the shared WebSpec — no more private _ResponsiveSpec
//           final spec = WebSpec.fromConstraints(constraints);
//           return Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: spec.outerPadding),
//               child: _buildCard(spec),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCard(WebSpec spec) {
//     return Container(
//       width: spec.cardWidth,
//       height: 300,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(spec.cardRadius),
//         border: Border.all(color: const Color(0xFFE9EBEF)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.10),
//             blurRadius: 24,
//             spreadRadius: 1,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(spec.cardPadding),
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: _buildContent(spec),
//               ),
//             ),
//             SizedBox(height: spec.buttonTopGap),
//             WpButton.primary(
//               label: 'Accept & setup account',
//               height: spec.buttonHeight,
//               fontSize: spec.buttonFontSize,
//               borderRadius: spec.buttonRadius,
//               //enabled: !_controisLocked,
//               onPressed: () {},
//             ),
//             SizedBox(height: spec.sectionGap),
//             WpButton.secondary(
//               label: 'Decline',
//               height: spec.buttonHeight,
//               fontSize: spec.buttonFontSize,
//               borderRadius: spec.buttonRadius,
//               // isLoading: _controller.isDeclining.value,
//               // enabled: !_controller.isLocked,
//               onPressed: () {},
//             ),
//             SizedBox(height: spec.sectionGap * 0.55),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContent(WebSpec spec) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: spec.iconSize,
//           height: spec.iconSize,
//           decoration: const BoxDecoration(
//             color: Color(0xFFF2F4F7),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             Icons.person_outline,
//             size: spec.iconInnerSize,
//             color: const Color(0xFF6B7280),
//           ),
//         ),
//         SizedBox(height: spec.sectionGap),
//         Text(
//           'Set Up Your Account',
//           style: TextStyle(
//             fontSize: spec.titleSize,
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF111827),
//           ),
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(height: spec.sectionGap * 0.4),
//         Text(
//           'Complete your coach registration',
//           style: TextStyle(
//             fontSize: spec.subtitleSize,
//             color: const Color(0xFF6B7280),
//           ),
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(height: spec.sectionGap),
//         Column(
//           children: [
//             Text(
//               'Welcome',
//               style: TextStyle(
//                 fontSize: spec.bodySize,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xFF111827),
//               ),
//             ),
//             SizedBox(height: spec.sectionGap * 0.5),
//           ],
//         ),
//         Text(
//           '—',
//           style: TextStyle(
//             fontSize: spec.bodySize,
//             color: const Color(0xFF9CA3AF),
//           ),
//         ),
//         SizedBox(height: spec.sectionGap * 0.5),
//         Text(
//           'Read Only',
//           style: TextStyle(
//             fontSize: spec.subtitleSize,
//             color: const Color(0xFF6B7280),
//           ),
//         ),
//       ],
//     );
//   }
// }
