import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/api_client.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final ApiClient apiClient;

  NotificationRepository({required this.apiClient});

  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    try {
      final response = await apiClient.get('/user/notifications');
      final List<dynamic> data = response.data['data'] ?? [];
      final notifications = data.map((e) => NotificationModel.fromJson(e)).toList();
      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> markAsRead(int notificationId) async {
    try {
      await apiClient.post('/user/notifications/$notificationId/read');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
