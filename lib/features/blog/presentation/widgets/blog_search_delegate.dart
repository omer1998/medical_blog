import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/bloc/blog_bloc.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:medical_blog_app/features/blog/presentation/widgets/new_blog_card.dart';

class BlogSearchDelegate extends SearchDelegate{
  
  final UserEntity mainAppUser;

  BlogSearchDelegate({ required this.mainAppUser});
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = '';
      },)
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, null);
    }, icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length <3 ){
      return Center(child: Text('Please enter at least 3 characters'),);
    }
     BlocProvider.of<BlogBloc>(context).add(BlogFetchBlogsEvent());
     return BlocBuilder<BlogBloc, BlogState>(builder:(context, state) {
       if (state is BlogLoadingState){
         return Center(child: CircularProgressIndicator(),);
       }
       if(state is BlogsSuccessState){
         final blogs = state.blogs;
         return ListView.builder(
           itemCount: blogs.length,
           itemBuilder: (context, index){
             return Column(
               children: [
                 GestureDetector(
                  onTap: (){
                   Navigator.of(context).push(BlogViewerPage.route(blog: blogs[index], user: mainAppUser));
                  },
                  child: ListTile(title: Text(blogs[index].title.capitalize(), style: TextStyle(fontSize: 18),),)),
                 Divider(height: 1, color: Colors.grey,),
               ],
             );
           },
         );
       } else if (state is BlogFailureState){
        return Text(state.message);
       }
       return Container();
     },);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }

} 