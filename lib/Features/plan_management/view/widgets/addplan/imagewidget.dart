import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart' show DottedBorder;
import 'package:everqpidadmin/Features/plan_management/viewmodel/viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RightSidePlanSection extends StatefulWidget {
  final SubscriptionViewmodel viewModel;

  const RightSidePlanSection({
    super.key,
    required this.viewModel,
  });

  @override
  State<RightSidePlanSection> createState() => RightSidePlanSectionState();
}

class RightSidePlanSectionState extends State<RightSidePlanSection> {
  String? _selectedImageUrl;
  Uint8List? _imageBytes;
  String? _fileName;
  bool _isUploading = false;

  final TextEditingController _featureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.viewModel.selectedPlan != null) {
      _selectedImageUrl = widget.viewModel.selectedPlan!.imageUrl;
      widget.viewModel.uploadedImageUrl = _selectedImageUrl;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _featureController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _imageBytes = result.files.first.bytes;
          _fileName = result.files.first.name;
          _selectedImageUrl = null;
        });
      }
    } catch (e) {
      _showError("Failed to pick image");
    }
  }

  Future<void> _uploadImage() async {
    if (_imageBytes == null || _fileName == null) {
      _showError("Please select an image first");
      return;
    }

    setState(() => _isUploading = true);

    try {
      final signedUrl = await widget.viewModel.repo.profileSignedUrl(
        fileName: _fileName!,
        fieldName: "sub1",
      );

      await widget.viewModel.repo.uploadToSignedUrl(
        signedUrl: signedUrl,
        bytes: _imageBytes!,
        contentType: 'image/jpeg',
      );

      final publicUrl = signedUrl.split('?').first;

      setState(() {
        _selectedImageUrl = publicUrl;
        _imageBytes = null;
        _fileName = null;
      });

      widget.viewModel.uploadedImageUrl = publicUrl;
      widget.viewModel.refresh();

      _showSuccess("Image uploaded successfully");
    } catch (e) {
      _showError("Failed to upload image: $e");
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _addFeature() {
    final feature = _featureController.text.trim();
    if (feature.isNotEmpty) {
      setState(() {
        widget.viewModel.subscriptionfeatures.add(feature);
      });

      _featureController.clear();
      widget.viewModel.refresh();
    }
  }

  void _removeFeature(int index) {
    setState(() {
      widget.viewModel.subscriptionfeatures.removeAt(index);
    });
    widget.viewModel.refresh();
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _imageCard(),
        const SizedBox(height: 16),
        _featuresCard(),
      ],
    );
  }

  Widget _imageCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Plan Image",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          const Text("Add a photo of plan logo",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          if (_selectedImageUrl != null)
            Container(
              height: 170,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.network(
                      _selectedImageUrl!,
                      height: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error,
                            color: Colors.red, size: 50);
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _selectedImageUrl = null;
                          widget.viewModel.uploadedImageUrl = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          else if (_imageBytes != null)
            Container(
              height: 170,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.memory(_imageBytes!,
                        height: 150, fit: BoxFit.contain),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _imageBytes = null;
                          _fileName = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: _pickImage,
              child: DottedBorder(
                child: Container(
                  height: 170,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.upload, color: Colors.purple, size: 40),
                      SizedBox(height: 8),
                      Text("Select or Drop File",
                          style: TextStyle(color: Colors.purple)),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _isUploading
                  ? null
                  : (_imageBytes != null ? _uploadImage : _pickImage),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: _isUploading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      _imageBytes != null ? "Upload" : "Select Image",
                      style: const TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featuresCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Features", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _featureController,
                  decoration: InputDecoration(
                    hintText: "Enter feature name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                  onSubmitted: (_) => _addFeature(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addFeature,
                icon: const Icon(Icons.add, color: Colors.purple),
                style: IconButton.styleFrom(
                    backgroundColor: Colors.purple.shade50),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.viewModel.subscriptionfeatures.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No features added yet",
                    style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.viewModel.subscriptionfeatures.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    dense: true,
                    leading:
                        const Icon(Icons.check_circle, color: Colors.purple),
                    title: Text(
                      widget.viewModel.subscriptionfeatures[index],
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon:
                          const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () => _removeFeature(index),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
