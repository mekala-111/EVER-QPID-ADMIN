import 'package:everqpidadmin/Features/hostmanagement/model/sendlikemodel.dart';
import 'package:everqpidadmin/Features/hostmanagement/viewmodel/hostdetailsviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sendlikewidget extends StatefulWidget {
  const Sendlikewidget({super.key});

  @override
  State<Sendlikewidget> createState() => _SendlikewidgetState();
}

class _SendlikewidgetState extends State<Sendlikewidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  static const int _pageSize = 20;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final vm = context.read<Hostdetailsviewmodel>();
    final hostId = vm.hostDetails?.data.userProfile.id;

    if (hostId != null) {
      vm.getHostSentLikesFn(
        context,
        hostId: hostId,
        pageNumber: 1,
        pageSize: _pageSize,
        loadMore: false,
      );
      _currentPage = 1;
    }
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    final vm = context.read<Hostdetailsviewmodel>();

    // Check if we've reached the bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more if there's more data
      if (vm.hasNextSentLikes && !vm.sentLikesLoading) {
        _loadMoreData();
      }
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final vm = context.read<Hostdetailsviewmodel>();
    final hostId = vm.hostDetails?.data.userProfile.id;

    if (hostId != null) {
      await vm.getHostSentLikesFn(
        context,
        hostId: hostId,
        pageNumber: _currentPage + 1,
        pageSize: _pageSize,
        loadMore: true,
      );
      _currentPage++;
    }

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Hostdetailsviewmodel>(
      builder: (context, vm, _) {
        final hostId = vm.hostDetails?.data.userProfile.id;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title with count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Send Likes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // if (vm.totalSentLikes > 0)
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 12,
                  //       vertical: 4,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: Colors.blue.shade50,
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Text(
                  //       '${vm.sentLikes.length} / ${vm.totalSentLikes}',
                  //       style: TextStyle(
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.blue.shade700,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
              const SizedBox(height: 16),

              /// Loading initial data
              if (vm.sentLikesLoading && vm.sentLikes.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                )

              /// Empty state
              else if (vm.sentLikes.isEmpty && !vm.sentLikesLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No likes sent yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              /// Grid with users
              else
                SizedBox(
                  height: 500, // Fixed height for scrollable area
                  child: GridView.builder(
                    controller: _scrollController,
                    itemCount:
                        vm.sentLikes.length + (vm.hasNextSentLikes ? 1 : 0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the end
                      if (index == vm.sentLikes.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final user = vm.sentLikes[index];
                      final isLiked = true; // Already sent like

                      return _UserCard(
                        user: user,
                        isLiked: isLiked,
                        onLikeToggle: () async {
                          if (hostId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Host ID not found'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Since user is already liked, this would be unlike
                          // You might want to implement unlike functionality
                          // For now, just show a message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Already liked this user'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  final SentLikeUser user;
  final bool isLiked;
  final VoidCallback onLikeToggle;

  const _UserCard({
    required this.user,
    required this.isLiked,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        children: [
          /// Profile Image
          /// Profile Image
          /// Profile Image
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: user.profileImageUrl.isNotEmpty
                  ? Image.network(
                      user.profileImageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: FractionallySizedBox(
                          widthFactor: 0.6, // 60% of container width
                          heightFactor: 0.6, // 60% of container height
                          child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: FractionallySizedBox(
                        widthFactor: 0.6,
                        heightFactor: 0.6,
                        child: const FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
            ),
          ),

          /// User Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),

                  /// Like Button
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: onLikeToggle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isLiked ? Colors.pink.shade50 : Colors.blue.shade50,
                        foregroundColor: isLiked
                            ? Colors.pink.shade700
                            : Colors.blue.shade700,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                      ),
                      label: Text(
                        isLiked ? 'Liked' : 'Send Like',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
