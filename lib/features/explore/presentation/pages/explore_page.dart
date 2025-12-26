import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../bloc/explore_bloc.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ExploreBloc>()..add(ExploreLoadRequested()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Explore', style: TextStyle(color: AppColors.textPrimary)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: BlocBuilder<ExploreBloc, ExploreState>(
          builder: (context, state) {
            if (state is ExploreLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExploreLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  if (post.images.isNotEmpty) {
                    return Image.network(
                      post.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_,__,___) => Container(color: Colors.grey[300]),
                    );
                  }
                  return Container(
                    color: Colors.grey[300],
                    child: Center(child: Icon(Icons.image, color: Colors.grey[400])),
                  );
                },
              );
            } else if (state is ExploreError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Start exploring!'));
          },
        ),
      ),
    );
  }
}
