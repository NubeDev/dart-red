import 'package:uuid/uuid.dart';

/// A page pinned to the home screen by the user.
/// Stored in SharedPreferences as a JSON list via [LocalCollection].
class PinnedPage {
  final String id;
  final String locationId;
  final String locationName;
  final String nodeId;
  final String nodeLabel;
  final String? pageId;
  final String? pageTitle;
  final DateTime pinnedAt;

  const PinnedPage({
    required this.id,
    required this.locationId,
    required this.locationName,
    required this.nodeId,
    required this.nodeLabel,
    this.pageId,
    this.pageTitle,
    required this.pinnedAt,
  });

  factory PinnedPage.create({
    required String locationId,
    required String locationName,
    required String nodeId,
    required String nodeLabel,
    String? pageId,
    String? pageTitle,
  }) {
    return PinnedPage(
      id: const Uuid().v4(),
      locationId: locationId,
      locationName: locationName,
      nodeId: nodeId,
      nodeLabel: nodeLabel,
      pageId: pageId,
      pageTitle: pageTitle,
      pinnedAt: DateTime.now(),
    );
  }

  factory PinnedPage.fromJson(Map<String, dynamic> json) {
    return PinnedPage(
      id: json['id'] as String,
      locationId: json['locationId'] as String,
      locationName: json['locationName'] as String,
      nodeId: json['nodeId'] as String,
      nodeLabel: json['nodeLabel'] as String,
      pageId: json['pageId'] as String?,
      pageTitle: json['pageTitle'] as String?,
      pinnedAt: DateTime.parse(json['pinnedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'locationId': locationId,
        'locationName': locationName,
        'nodeId': nodeId,
        'nodeLabel': nodeLabel,
        'pageId': pageId,
        'pageTitle': pageTitle,
        'pinnedAt': pinnedAt.toIso8601String(),
      };
}
