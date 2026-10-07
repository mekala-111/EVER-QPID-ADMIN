import 'package:everqpidadmin/employeelogin/chatmangaement/model/userdetailsmodel.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsPanel extends StatelessWidget {
  const UserDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeChatManagementViewModel>(
      builder: (context, vm, _) {
        if (vm.isUserDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.userDetailsError != null) {
          return Center(
            child: Text(
              vm.userDetailsError!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final user = vm.selectedUserDetails;
        if (user == null) {
          return const Center(
              child: Text('Select a chat to view user details'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileHeader(user),
              const SizedBox(height: 24),
              _InfoGrid(user),
              const SizedBox(height: 24),
              _AboutSection(user),
              const SizedBox(height: 24),
              _PhotosSection(user),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserData user;
  const _ProfileHeader(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundImage: NetworkImage(user.profileImageUrl),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(user.email),
              const SizedBox(height: 6),
              Row(
                children: [
                  _StatusDot(isOnline: user.isOnline),
                  const SizedBox(width: 6),
                  Text(user.isOnline ? 'Online' : 'Offline'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final bool isOnline;
  const _StatusDot({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOnline ? Colors.green : Colors.grey,
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final UserData user;
  const _InfoGrid(this.user);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _InfoCard(
          title: 'Personal Info',
          children: [
            _info('Gender', user.gender),
            _info(
                'DOB', user.dateOfBirth.toLocal().toString().split(' ').first),
            _info('Status', user.relationshipStatus),
            _info('Religion', user.religion),
          ],
        ),
        _InfoCard(
          title: 'Location',
          children: [
            _info('City', user.homeLocation.city),
            _info('State', user.homeLocation.state),
            _info('Lat', user.homeLocation.coordinates[1].toString()),
            _info('Lng', user.homeLocation.coordinates[0].toString()),
          ],
        ),
        _InfoCard(
          title: 'Account',
          children: [
            _info('User Type', user.userType),
            _info('Customer Status', user.customerStatus),
            _info('Verified', user.isVerified ? 'Yes' : 'No'),
            _info('Created At', user.createdAt.toLocal().toString()),
          ],
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }
}

Widget _info(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Flexible(child: Text(value, textAlign: TextAlign.end)),
      ],
    ),
  );
}

class _AboutSection extends StatelessWidget {
  final UserData user;
  const _AboutSection(this.user);

  @override
  Widget build(BuildContext context) {
    if (user.aboutMe.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Me',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(user.aboutMe),
        ],
      ),
    );
  }
}

class _PhotosSection extends StatelessWidget {
  final UserData user;
  const _PhotosSection(this.user);

  @override
  Widget build(BuildContext context) {
    if (user.profilePhotos.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile Photos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: user.profilePhotos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (_, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  user.profilePhotos[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
      ),
    ],
  );
}
