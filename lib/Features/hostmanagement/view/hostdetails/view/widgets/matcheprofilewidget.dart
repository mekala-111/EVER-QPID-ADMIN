import 'package:everqpidadmin/Features/hostmanagement/model/hostmatchesmodel.dart';
import 'package:everqpidadmin/Features/hostmanagement/viewmodel/hostdetailsviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostMatchedProfilesCard extends StatelessWidget {
  const HostMatchedProfilesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Hostdetailsviewmodel>(
      builder: (context, vm, child) {
        Color genderColor(String gender) {
          switch (gender.toLowerCase()) {
            case "male":
            case "man":
              return Colors.blue;
            case "female":
            case "woman":
            case "women":
              return Colors.pink;
            default:
              return Colors.grey;
          }
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              const Text(
                "Matched Profiles",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              /// Loading
              if (vm.matchesLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                )

              /// Empty
              else if (vm.userMatches.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "No matched profiles found",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              /// Data
              else ...[
                _tableHeader(),
                const Divider(height: 24),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vm.userMatches.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final UserMatch match = vm.userMatches[index];

                    return _tableRow(
                      username: match.fullName,
                      gender: match.gender,
                      datetime: _formatDate(
                          match.matchedAt), // Changed from updatedAt
                      genderColor: genderColor(match.gender),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Header Row
  Widget _tableHeader() {
    return const Row(
      children: [
        Expanded(flex: 3, child: Text("Username", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Gender", style: _headerStyle)),
        Expanded(flex: 3, child: Text("Date & Time", style: _headerStyle)),
      ],
    );
  }

  /// Table Row
  Widget _tableRow({
    required String username,
    required String gender,
    required String datetime,
    required Color genderColor,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            username,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            gender,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: genderColor,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(datetime),
        ),
      ],
    );
  }

  /// Date formatter
  String _formatDate(DateTime? date) {
    if (date == null) return '-';

    final localDate = date.toLocal(); // ✅ convert UTC to local

    return "${localDate.day.toString().padLeft(2, '0')}/"
        "${localDate.month.toString().padLeft(2, '0')}/"
        "${localDate.year}, "
        "${localDate.hour % 12 == 0 ? 12 : localDate.hour % 12}:"
        "${localDate.minute.toString().padLeft(2, '0')} "
        "${localDate.hour >= 12 ? 'PM' : 'AM'}";
  }
}

const _headerStyle = TextStyle(
  fontSize: 13,
  color: Colors.grey,
  fontWeight: FontWeight.w500,
);
