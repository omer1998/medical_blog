import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import 'package:medical_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medical_blog_app/features/blog/data/datasources/remote_data_source.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/add_new_blog_page_section.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/bloc/blog_bloc.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/profile_drawer.dart';
import 'package:medical_blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:medical_blog_app/features/blog/presentation/widgets/blog_search_delegate.dart';
import 'package:medical_blog_app/features/blog/presentation/widgets/new_blog_card.dart';
import 'package:medical_blog_app/features/case/pages/cases_page.dart';
import 'package:medical_blog_app/features/med_calc/med_calc_page.dart';
import 'package:medical_blog_app/init_dependencies.dart';



final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class BlogPage extends ConsumerStatefulWidget {
  const BlogPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlogPageState();
}

class _BlogPageState extends ConsumerState<BlogPage> {
  @override
  void initState() {
    super.initState();
   
    BlocProvider.of<BlogBloc>(context).add(BlogFetchBlogsEvent());
  }

  @override
  Widget build(BuildContext context) {
    
    final userId =
        (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState)
            .user
            .id;
    final user =
        (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState).user;

    return Scaffold(
        // bottomNavigationBar: ,
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: CircleAvatar(
                radius: 5,
                backgroundImage: NetworkImage(user.img_url!),

                // child: IconButton(
                //   onPressed: () {
                //     _scaffoldKey.currentState?.openDrawer();
                //   },
                //   icon: Image.network(user.user.img_url!),
                //   color: Colors.black,
                // ),
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            ("Blog"),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // Navigator.push(context, AddNewBlogPage.route());
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return AddNewBlogSection(
                        userId: userId,
                      );
                    },
                  ));
                },
                icon: Icon(CupertinoIcons.add_circled)),
                IconButton(onPressed: (){
                  showSearch(context: context, delegate: BlogSearchDelegate(mainAppUser: user));
                }, icon: Icon(Icons.search))
          ],
        ),
        drawer: ProfileDrawer(user: user),
        body: Container(
          // decoration: BoxDecoration(color:  Color.fromARGB(255, 56, 2, 55)),
          child: MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthLogOutSuccess) {
                    GoRouter.of(context).goNamed("login");
                  }
                },
              ),
            ],
            child: BlocConsumer<BlogBloc, BlogState>(
              builder: (context, state) {
                if (state is BlogLoadingState) {
                  return Loader();
                } else if (state is BlogsSuccessState) {
                  // print("all blogs : ${state.blogs}");
                  for (var blog in state.blogs) {
                    if (blog.contentJson != null) {
                      print(blog);
                    }
                  }
                  final allTopics = state.availableTopics;

                  return Column(
                    children: [
                      Wrap(
                        children: allTopics.map((topic) {
                          final isSelected = state.selectedTopic == topic;
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ActionChip(
                              label: Text(topic),
                              backgroundColor: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              onPressed: () {
                                BlocProvider.of<BlogBloc>(context).add(
                                    BlogFilterByTopicEvent(isSelected ? null : topic));
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      Expanded(
                        child: ListView.builder(
                          
                          itemCount: state.blogs.length,
                          itemBuilder: (context, index) {
                            return NewBlogCard(
                              blog: state.blogs[index],
                              mainAppUser: user,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return Center(child: Container());
              },
              listener: (BuildContext context, BlogState state) {
                if (state is BlogFailureState) {
                  print(state.message);
                  showSnackBar(context, state.message);
                }
              },
            ),
          ),
        ));
  }
}

// final availableTopicsProvider = Provider<List<String>>((ref) {
//   BlocProvider.of<BlogBloc>(context);
//   if (blogState is BlogsSuccessState) {
//     return blogState.availableTopics;
//   }
//   return [];
// });

