import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/feed_repository.dart';

class GetPostsUseCase {
  final FeedRepository repository;

  GetPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call() {
    return repository.getPosts();
  }
}
