import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/view/widgets/audiorecord.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/viewmodel/viewmodel.dart';

class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;

  const MessageInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool _isRecording = false;
  late WebAudioRecorder _recorder;

  @override
  void initState() {
    super.initState();
    _recorder = WebAudioRecorder();
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    final viewModel = context.read<EmployeeChatManagementViewModel>();

    if (!_isRecording) {
      try {
        await _recorder.start();
        setState(() => _isRecording = true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recording started...'),
              duration: Duration(seconds: 1),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to start recording: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      try {
        final audioBytes = await _recorder.stop();
        setState(() => _isRecording = false);

        if (audioBytes.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Recording is empty'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }

        // Generate unique filename with .webm extension
        final fileName = 'voice_${DateTime.now().millisecondsSinceEpoch}.webm';

        if (!mounted) return;
        await viewModel.uploadAndSendAudio(
          context: context,
          audioBytes: audioBytes,
          fileName: fileName,
        );
      } catch (e) {
        setState(() => _isRecording = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send voice message: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final viewModel = context.read<EmployeeChatManagementViewModel>();
    final picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return;

      // Read image bytes
      final Uint8List imageBytes = await image.readAsBytes();

      // Get file name
      final String fileName = image.name;

      if (!context.mounted) return;
      await viewModel.uploadAndSendMedia(
        context: context,
        imageBytes: imageBytes,
        fileName: fileName,
        caption: '',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeChatManagementViewModel>(
      builder: (context, viewModel, _) {
        final isUploading = viewModel.isUploadingMedia;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border(top: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              // 📎 Image picker
              IconButton(
                icon: const Icon(
                  Icons.attach_file,
                  color: Colors.black,
                ),
                onPressed: isUploading || _isRecording
                    ? null
                    : () => _pickImage(context),
                tooltip: 'Attach Image',
              ),

              // 🎤 Mic Button
              Semantics(
                button: true,
                label: _isRecording ? 'Stop recording' : 'Record voice message',
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: _isRecording
                      ? Colors.red
                      : (isUploading ? Colors.grey : Colors.grey.shade300),
                  child: IconButton(
                    tooltip: _isRecording
                        ? 'Stop recording'
                        : 'Record voice message',
                    onPressed: isUploading ? null : _toggleRecording,
                    icon: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      color: _isRecording ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // ✍️ Text field
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: _isRecording
                        ? 'Recording...'
                        : (isUploading ? 'Uploading...' : 'Type a message...'),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  enabled: !_isRecording && !isUploading,
                  onSubmitted: (_) {
                    if (!_isRecording && !isUploading) {
                      widget.onSend();
                    }
                  },
                ),
              ),

              const SizedBox(width: 8),

              // 📤 Send Button
              if (isUploading)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                CircleAvatar(
                  radius: 22,
                  backgroundColor: _isRecording
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                  child: IconButton(
                    tooltip: 'Send message',
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _isRecording ? null : widget.onSend,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
