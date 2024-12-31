// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/features/blog/domain/usecases/fav_blog_usecase.dart';
import 'package:meta/meta.dart';

import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:medical_blog_app/features/blog/domain/usecases/fetch_blogs_usecase.dart';
import 'package:medical_blog_app/features/blog/domain/usecases/upload_blog_usecase.dart';



part 'blog_event.dart';
part 'blog_state.dart';



class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlogUseCase uploadBlogUseCase;
  final FetchBlogsUseCase fetchBlogsUseCase;
  final FavBlogUseCase favBlogUseCase;
  List<BlogEntity> allBlogs = [];

  BlogBloc({
    required this.favBlogUseCase,
    required this.uploadBlogUseCase,
    required this.fetchBlogsUseCase,
  }) : super(BlogInitial()) {

    on<FavBlogEvent>((event, emit)async {
      emit(FavBlogLoadingState());
      final res = await favBlogUseCase(FavParams(event.blogId, event.userId));
      res.fold((f){
        emit(FavBlogFailureState(message: f.message));
      }, (s){
        emit(FavBlogSuccessState());
      });
      
    },);

    on<BlogUploadBlogEvent>(
      (event, emit) async {
        emit(BlogLoadingState());

        final response = await uploadBlogUseCase(BlogData(
            title: event.title,
            content: event.content,
           
            image: event.image,
            authorId: event.authorId,
            topics: event.topics));
        response.fold((l) => emit(BlogFailureState(message: l.message)),
            (r) => emit(BlogSuccessState()));
      },
    );

    on<BlogFetchBlogsEvent>(
      (event, emit) async {
        emit(BlogLoadingState());

        final response = await fetchBlogsUseCase(NoParams());
        response.fold((l) => emit(BlogFailureState(message: l.message)), (r) {
          allBlogs = r;
          final availableTopics = r.map((blog) => blog.topics).expand((topics) => topics).toSet().toList();


          emit(BlogsSuccessState(blogs: r , selectedTopic: null, availableTopics: availableTopics));
        });
      },
    );
        on<BlogFilterByTopicEvent>((event, emit) {
      if (state is BlogsSuccessState){
        final currentState = state as BlogsSuccessState;
        final selectedTopic = event.selectedTopic;
      if (selectedTopic == null || selectedTopic == "All") {
        emit(BlogsSuccessState(blogs: allBlogs, selectedTopic: selectedTopic, availableTopics: currentState.availableTopics));
      } else {
        final filteredBlogs = allBlogs
            .where((blog) => blog.topics.contains(selectedTopic))
            .toList();
        emit(BlogsSuccessState(blogs: filteredBlogs, selectedTopic: selectedTopic, availableTopics: currentState.availableTopics));
      }
      }
      
    });
  }
}
