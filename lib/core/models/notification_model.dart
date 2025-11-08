/// Notification model
class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type; // application, course, payment, alert, message
  final Map<String, dynamic>? data;
  bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'data': data,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Mock notifications for development
  static List<NotificationModel> mockNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: '1',
        userId: 'user1',
        title: 'Application Accepted',
        body: 'Your application to University of Ghana has been accepted!',
        type: 'application',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: '2',
        userId: 'user1',
        title: 'New Course Available',
        body: 'Data Science course is now available for enrollment',
        type: 'course',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      NotificationModel(
        id: '3',
        userId: 'user1',
        title: 'Payment Successful',
        body: 'Your payment of \$50 has been processed successfully',
        type: 'payment',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: '4',
        userId: 'user1',
        title: 'Application Under Review',
        body: 'Your application is currently being reviewed',
        type: 'application',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      NotificationModel(
        id: '5',
        userId: 'user1',
        title: 'Deadline Reminder',
        body: 'Application deadline for Makerere University is in 7 days',
        type: 'alert',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  /// Single mock notification for development
  static NotificationModel mockNotification([int index = 0]) {
    final titles = [
      'Application Accepted',
      'New Course Available',
      'Payment Successful',
      'Application Under Review',
      'Deadline Reminder',
    ];
    final bodies = [
      'Your application to University of Ghana has been accepted!',
      'Data Science course is now available for enrollment',
      'Your payment of \$50 has been processed successfully',
      'Your application is currently being reviewed',
      'Application deadline for Makerere University is in 7 days',
    ];
    final types = ['application', 'course', 'payment', 'application', 'alert'];

    return NotificationModel(
      id: '${index + 1}',
      userId: 'user1',
      title: titles[index % titles.length],
      body: bodies[index % bodies.length],
      type: types[index % types.length],
      isRead: index % 3 == 0,
      createdAt: DateTime.now().subtract(Duration(hours: (index + 1) * 2)),
    );
  }
}
