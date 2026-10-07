class SubscriptionResponse {
  final SubscriptionData? data;

  SubscriptionResponse({this.data});

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      data:
          json['data'] != null ? SubscriptionData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class SubscriptionData {
  final List<SubscriptionModel> subscriptions;
  final bool hasNext;
  final int totalCount;

  SubscriptionData({
    required this.subscriptions,
    required this.hasNext,
    required this.totalCount,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      subscriptions: (json['subscriptions'] as List)
          .map((e) => SubscriptionModel.fromJson(e))
          .toList(),
      hasNext: json['hasNext'] ?? false,
      totalCount: json['totalCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscriptions': subscriptions.map((e) => e.toJson()).toList(),
      'hasNext': hasNext,
      'totalCount': totalCount,
    };
  }
}

class SubscriptionModel {
  final String id;
  final String planName;
  final String planTitle;
  final int price;
  final String imageUrl;
  final List<FeatureModel> features;
  final int durationValue;
  final String durationUnit;
  final int? messagesPerDay;
  final int? superLikesPerDay;
  final bool unlimitedLikes;
  final bool unlimitedMessages;
  final bool unlimitedSuperLikes;
  final bool isPlanActive;
  final bool setPreferences;
  final bool accessToClan;
  final bool accessToRecentPasses;
  final DateTime createdAt;
  final int? sellingPrice; // Make it nullable

  SubscriptionModel(
      {required this.id,
      required this.planName,
      required this.planTitle,
      required this.price,
      required this.imageUrl,
      required this.features,
      required this.durationValue,
      required this.durationUnit,
      this.messagesPerDay,
      this.superLikesPerDay,
      required this.unlimitedLikes,
      required this.unlimitedMessages,
      required this.unlimitedSuperLikes,
      required this.isPlanActive,
      required this.setPreferences,
      required this.accessToClan,
      required this.accessToRecentPasses,
      required this.createdAt,
      this.sellingPrice});

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['_id'] ?? '',
      planName: json['planName'] ?? '',
      planTitle: json['planTitle'] ?? '',
      price: json['price'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      features: (json['features'] as List? ?? [])
          .map((e) => FeatureModel.fromJson(e))
          .toList(),
      durationValue: json['durationValue'] ?? 0,
      durationUnit: json['durationUnit'] ?? '',
      messagesPerDay: json['messagesPerDay'],
      superLikesPerDay: json['superLikesPerDay'],
      unlimitedLikes: json['unlimitedLikes'] ?? false,
      unlimitedMessages: json['unlimitedMessages'] ?? false,
      unlimitedSuperLikes: json['unlimitedSuperLikes'] ?? false,
      isPlanActive: json['isPlanActive'] ?? false,
      setPreferences: json['setPreferences'] ?? false,
      accessToClan: json['accessToClan'] ?? false,
      accessToRecentPasses: json['accessToRecentPasses'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      sellingPrice:
          json['sellingPrice'], // ✅ Correct - allows null for nullable int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'planName': planName,
      'planTitle': planTitle,
      'price': price,
      'imageUrl': imageUrl,
      'features': features.map((e) => e.toJson()).toList(),
      'durationValue': durationValue,
      'durationUnit': durationUnit,
      'messagesPerDay': messagesPerDay,
      'superLikesPerDay': superLikesPerDay,
      'unlimitedLikes': unlimitedLikes,
      'unlimitedMessages': unlimitedMessages,
      'unlimitedSuperLikes': unlimitedSuperLikes,
      'isPlanActive': isPlanActive,
      'setPreferences': setPreferences,
      'accessToClan': accessToClan,
      'accessToRecentPasses': accessToRecentPasses,
      'createdAt': createdAt.toIso8601String(),
      'sellingPrice': sellingPrice,
    };
  }
}

class FeatureModel {
  final String id;
  final String feature;

  FeatureModel({
    required this.id,
    required this.feature,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['_id'] ?? '',
      feature: json['feature'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'feature': feature,
    };
  }
}
