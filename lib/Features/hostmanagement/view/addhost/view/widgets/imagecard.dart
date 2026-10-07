// import 'package:everqpidadmin/Features/hostmanagement/viewmodel/viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:provider/provider.dart';

// class ProfileImageCard extends StatelessWidget {
//   const ProfileImageCard({super.key});

//   Future<void> _pickImage(BuildContext context) async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//         allowMultiple: false,
//       );

//       if (result != null && result.files.isNotEmpty) {
//         final file = result.files.first;
//         if (file.bytes != null) {
//           context.read<HostmanagementViewmodel>().setImage(
//                 file.bytes!,
//                 file.name,
//               );
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to pick image: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _uploadImage(BuildContext context) async {
//     final viewModel = context.read<HostmanagementViewmodel>();
//     await viewModel.uploadProfileImage(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<HostmanagementViewmodel>(
//       builder: (context, viewModel, child) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           decoration: _cardDecoration(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Profile Image",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 6),
//               const Text(
//                 "Add a photo of the host",
//                 style: TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//               const SizedBox(height: 16),

//               /// Upload Box or Preview
//               InkWell(
//                 onTap: () => _pickImage(context),
//                 child: Container(
//                   height: 180,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: const Color(0xFF9B5DE5),
//                       style: BorderStyle.solid,
//                       width: 1,
//                     ),
//                   ),
//                   child: _buildImagePreview(viewModel),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: viewModel.uploadingImage
//                       ? null
//                       : () => _uploadImage(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF9B5DE5),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: viewModel.uploadingImage
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor:
//                                 AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                       : Text(
//                           viewModel.uploadedImageUrl != null
//                               ? "Image Uploaded ✓"
//                               : "Upload",
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildImagePreview(HostmanagementViewmodel viewModel) {
//     if (viewModel.selectedImageBytes != null) {
//       // Show selected image
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Image.memory(
//           viewModel.selectedImageBytes!,
//           fit: BoxFit.cover,
//           width: double.infinity,
//         ),
//       );
//     } else if (viewModel.uploadedImageUrl != null &&
//         viewModel.uploadedImageUrl!.isNotEmpty) {
//       // Show uploaded image from URL
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Image.network(
//           viewModel.uploadedImageUrl!,
//           fit: BoxFit.cover,
//           width: double.infinity,
//           errorBuilder: (context, error, stackTrace) {
//             return _buildUploadPlaceholder();
//           },
//         ),
//       );
//     } else {
//       // Show upload placeholder
//       return _buildUploadPlaceholder();
//     }
//   }

//   Widget _buildUploadPlaceholder() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.upload, color: Color(0xFF9B5DE5), size: 32),
//           SizedBox(height: 8),
//           Text(
//             "Select or Drop File",
//             style: TextStyle(
//               color: Color(0xFF9B5DE5),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   BoxDecoration _cardDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//     );
//   }
// }
