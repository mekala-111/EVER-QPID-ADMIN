import 'package:everqpidadmin/employeelogin/likemanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecievedLikes extends StatefulWidget {
  const RecievedLikes({super.key});

  @override
  State<RecievedLikes> createState() => _RecievedLikesState();
}

class _RecievedLikesState extends State<RecievedLikes>
    with SingleTickerProviderStateMixin {
  String? selectedHostId;
  String? selectedHostName;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    Future.microtask(() {
      if (mounted) {
        context.read<LikeManagementViewmodel>().getAssignedHosts();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    PColors.primaryColor,
                    PColors.primaryColor.withValues(alpha: 0.7)
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.favorite_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            const Text(
              "Received Likes",
              style: TextStyle(
                color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEEEF2)),
        ),
      ),
      body: Consumer<LikeManagementViewmodel>(
        builder: (context, vm, _) {
          return Row(
            children: [
              // ─── LEFT PANEL: HOST LIST ───────────────────────────────
              Container(
                width: 240,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    right: BorderSide(color: Color(0xFFEEEEF2), width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        "HOSTS",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade400,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: vm.isHostLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: PColors.primaryColor,
                                strokeWidth: 2,
                              ),
                            )
                          : vm.hosts.isEmpty
                              ? _buildEmptyState(
                                  icon: Icons.people_outline,
                                  message: "No hosts found",
                                )
                              : ListView.builder(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  itemCount: vm.hosts.length,
                                  itemBuilder: (context, index) {
                                    final host = vm.hosts[index];
                                    final isSelected =
                                        selectedHostId == host.id;

                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? PColors.primaryColor
                                                .withValues(alpha: 0.08)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: isSelected
                                            ? Border.all(
                                                color: PColors.primaryColor
                                                    .withValues(alpha: 0.25),
                                                width: 1,
                                              )
                                            : null,
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          setState(() {
                                            selectedHostId = host.id;
                                            selectedHostName = host.fullName;
                                          });
                                          vm.getReceivedLikes(host.id ?? "");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                          child: Row(
                                            children: [
                                              _buildAvatar(
                                                name: host.fullName ?? "",
                                                size: 38,
                                                isSelected: isSelected,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      host.fullName ?? "",
                                                      style: TextStyle(
                                                        fontWeight: isSelected
                                                            ? FontWeight.w700
                                                            : FontWeight.w500,
                                                        fontSize: 14,
                                                        color: isSelected
                                                            ? PColors
                                                                .primaryColor
                                                            : const Color(
                                                                0xFF2D2D3A),
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (isSelected)
                                                Icon(
                                                  Icons.chevron_right_rounded,
                                                  color: PColors.primaryColor,
                                                  size: 18,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),

              // ─── RIGHT PANEL: RECEIVED LIKES ────────────────────────
              Expanded(
                child: selectedHostId == null
                    ? _buildPlaceholder()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                            color: Colors.white,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedHostName ?? "",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A1A2E),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        vm.isLikesLoading
                                            ? "Loading..."
                                            : "${vm.receivedLikes.length} like${vm.receivedLikes.length != 1 ? 's' : ''} received",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(height: 1, color: const Color(0xFFEEEEF2)),

                          // Content
                          Expanded(
                            child: vm.isLikesLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: PColors.primaryColor,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : vm.receivedLikes.isEmpty
                                    ? _buildEmptyState(
                                        icon: Icons.favorite_border_rounded,
                                        message: "No likes received yet",
                                        subtitle:
                                            "Likes from users will appear here",
                                      )
                                    : GridView.builder(
                                        padding: const EdgeInsets.all(20),
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 320,
                                          childAspectRatio: 0.82,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                        ),
                                        itemCount: vm.receivedLikes.length,
                                        itemBuilder: (context, index) {
                                          final like = vm.receivedLikes[index];
                                          return _LikeCard(
                                            like: like,
                                            hostId: selectedHostId!,
                                            vm: vm,
                                          );
                                        },
                                      ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: PColors.primaryColor.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.adaptive.arrow_back,
              size: 40,
              color: PColors.primaryColor.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Select a host",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D2D3A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Choose a host from the left to view their received likes",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    String? subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar({
    required String name,
    double size = 40,
    bool isSelected = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSelected
              ? [
                  PColors.primaryColor,
                  PColors.primaryColor.withValues(alpha: 0.7)
                ]
              : [const Color(0xFFB0B0C0), const Color(0xFF9090A0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "?",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }
}

// ─── LIKE CARD ──────────────────────────────────────────────────────────────

class _LikeCard extends StatefulWidget {
  final dynamic like;
  final String hostId;
  final LikeManagementViewmodel vm;

  const _LikeCard({
    required this.like,
    required this.hostId,
    required this.vm,
  });

  @override
  State<_LikeCard> createState() => _LikeCardState();
}

class _LikeCardState extends State<_LikeCard>
    with SingleTickerProviderStateMixin {
  bool _likedBack = false;
  bool _isLoading = false;
  late AnimationController _heartController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    // ← Seed from model so already-liked cards render correctly on load
    _likedBack = widget.like.isLikedBack == true;

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heartScale = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  Future<void> _handleLikeBack() async {
    if (_likedBack || _isLoading) return;

    setState(() => _isLoading = true);
    _heartController.forward().then((_) => _heartController.reverse());

    await widget.vm.likeBackUser(
      hostId: widget.hostId,
      userId: widget.like.fromUserId?.id ?? "",
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        _likedBack = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final like = widget.like;
    final name = like.fromUserId?.fullName ?? "Unknown";
    final gender = like.fromUserId?.gender ?? "";
    final age = like.fromUserId?.age;
    final profileImageUrl = like.fromUserId?.profileImageUrl as String?;
    final isSuperLike = like.isSuperLike == true;
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "?";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _likedBack
              ? PColors.primaryColor.withValues(alpha: 0.3)
              : const Color(0xFFEEEEF2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top: profile image / avatar with gradient overlay ──
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Profile image or gradient avatar
                  _buildProfileImage(
                    imageUrl: profileImageUrl,
                    initial: initial,
                  ),

                  // Bottom fade for text legibility
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 80,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.55),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Super Like badge
                  if (isSuperLike)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded,
                                color: Colors.white, size: 11),
                            SizedBox(width: 3),
                            Text(
                              "Super Like",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Already liked back badge
                  if (_likedBack)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_rounded,
                                color: Colors.white, size: 11),
                            SizedBox(width: 3),
                            Text(
                              "Liked Back",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Name + gender overlay at bottom
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 10,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (age != null)
                          Text(
                            "$age",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.white70,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom: gender chip + action button ──
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Gender chip
                  if (gender.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          gender.toLowerCase() == 'female'
                              ? Icons.female_rounded
                              : gender.toLowerCase() == 'male'
                                  ? Icons.male_rounded
                                  : Icons.person_outline_rounded,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          gender,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),

                  // Like Back Button
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _likedBack
                          ? Container(
                              key: const ValueKey('liked'),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.3),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_rounded,
                                      color: Colors.green, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    "Liked Back!",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              key: const ValueKey('not-liked'),
                              onTap: _isLoading ? null : _handleLikeBack,
                              child: AnimatedBuilder(
                                animation: _heartScale,
                                builder: (context, child) => Transform.scale(
                                  scale: _heartScale.value,
                                  child: child,
                                ),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        PColors.primaryColor,
                                        PColors.primaryColor
                                            .withValues(alpha: 0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: PColors.primaryColor
                                            .withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.favorite_rounded,
                                                color: Colors.white, size: 15),
                                            SizedBox(width: 6),
                                            Text(
                                              "Like Back",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
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

  Widget _buildProfileImage({
    required String? imageUrl,
    required String initial,
  }) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildGradientFallback(initial);
        },
        errorBuilder: (context, error, stackTrace) =>
            _buildGradientFallback(initial),
      );
    }
    return _buildGradientFallback(initial);
  }

  Widget _buildGradientFallback(String initial) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PColors.primaryColor,
            PColors.primaryColor.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 40,
        ),
      ),
    );
  }
}
