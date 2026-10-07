import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/model/hostmodel.dart';
import 'package:everqpidadmin/employeelogin/likemanagement/model/hostlikemodel.dart';
import 'package:everqpidadmin/employeelogin/likemanagement/repo/repo.dart';
import 'package:flutter/material.dart';

class LikeManagementViewmodel extends ChangeNotifier {
  final repo = LikeManagementRepo(NetworkApiServiceV2());

  bool _isHostLoading = false;
  bool get isHostLoading => _isHostLoading;

  List<Hostmodel> hosts = [];

  Future<void> getAssignedHosts() async {
    try {
      _isHostLoading = true;
      notifyListeners();

      final result = await repo.getHost();

      if (result['statusCode'] == 200 && result['data'] != null) {
        final HostsResponse response = HostsResponse.fromJson(result);

        hosts = response.data ?? [];
      } else {
        hosts.clear();
      }
    } catch (e) {
      hosts.clear();
    } finally {
      _isHostLoading = false;
      notifyListeners();
    }
  }

  bool _isLikesLoading = false;
  bool get isLikesLoading => _isLikesLoading;

  List<LikeModel> receivedLikes = [];

  Future<void> getReceivedLikes(String hostId) async {
    try {
      _isLikesLoading = true;
      notifyListeners();

      final result = await repo.getReceivedLikes(hostId);

      if (result['statusCode'] == 200 && result['data'] != null) {
        final HostLikesResponse response = HostLikesResponse.fromJson(result);

        receivedLikes = response.data?.likes ?? [];
      } else {
        receivedLikes.clear();
      }
    } catch (e) {
      receivedLikes.clear();
    } finally {
      _isLikesLoading = false;
      notifyListeners();
    }
  }

  bool _isLikeBackLoading = false;
  bool get isLikeBackLoading => _isLikeBackLoading;

  Future<void> likeBackUser({
    required String hostId,
    required String userId,
  }) async {
    try {
      _isLikeBackLoading = true;
      notifyListeners();

      final result = await repo.likeBackuser(
        hostId: hostId,
        userId: userId,
      );

      if (result['statusCode'] == 200) {
        final index = receivedLikes.indexWhere(
          (like) => like.fromUserId?.id == userId,
        );
        if (index != -1) {
          final old = receivedLikes[index];
          receivedLikes[index] = LikeModel(
            id: old.id,
            documentStatus: old.documentStatus,
            fromUserId: old.fromUserId,
            toUserId: old.toUserId,
            createdUser: old.createdUser,
            createdAt: old.createdAt,
            updatedUser: old.updatedUser,
            updatedAt: old.updatedAt,
            isSuperLike: old.isSuperLike,
            v: old.v,
            isLikedBack: true, // ← only this changes
          );
        }
      }
    } finally {
      _isLikeBackLoading = false;
      notifyListeners();
    }
  }
}
