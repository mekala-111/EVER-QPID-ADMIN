import 'package:everqpidadmin/Features/usermanagement/userdetails/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotosSection extends StatelessWidget {
  const PhotosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailsViewModel>(
      builder: (context, vm, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              const Text(
                'Photos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              /// Loading
              if (vm.photosLoading)
                const Center(child: CircularProgressIndicator())

              /// Empty
              else if (vm.userPhotos.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('No photos available'),
                  ),
                )

              /// Grid
              else
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: vm.userPhotos.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    return _PhotoCard(
                      imageUrl: vm.userPhotos[index],
                      onRemove: () async {
                        // Show loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        await context
                            .read<UserDetailsViewModel>()
                            .deleteUserPhotoFn(
                              context,
                              userId:
                                  context.read<UserDetailsViewModel>().userId!,
                              photoIndex: index,
                            );

                        // Close loading dialog
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                ),

              const SizedBox(height: 24),

              /// Remove All
              if (vm.userPhotos.isNotEmpty)
                ElevatedButton(
                  onPressed: () async {
                    // Show confirmation dialog
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Remove All Photos'),
                        content: const Text(
                          'Are you sure you want to remove all photos? This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                            ),
                            child: const Text('Remove All'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && context.mounted) {
                      // Show loading dialog
                      await context
                          .read<UserDetailsViewModel>()
                          .deleteAllUserPhotosFn(
                            context,
                            userId:
                                context.read<UserDetailsViewModel>().userId!,
                          );
                      // showDialog(
                      //   context: context,
                      //   barrierDismissible: false,
                      //   builder: (ctx) => const Center(
                      //     child: CircularProgressIndicator(),
                      //   ),
                      // );

                      // await context
                      //     .read<UserDetailsViewModel>()
                      //     .deleteAllUserPhotosFn(
                      //       context,
                      //       userId:
                      //           context.read<UserDetailsViewModel>().userId!,
                      //     );

                      // // Close loading dialog
                      // if (context.mounted) {
                      //   Navigator.of(context).pop();
                      // }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Remove All',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onRemove;

  const _PhotoCard({
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          /// Image
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),
          ),

          /// Remove Button
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              height: 36,
              child: OutlinedButton(
                onPressed: onRemove,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Remove'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
