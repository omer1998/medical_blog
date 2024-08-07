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
import 'package:medical_blog_app/features/blog/presentation/pages/bloc/blog_bloc.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/profile_drawer.dart';
import 'package:medical_blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:medical_blog_app/features/case/pages/cases_page.dart';
import 'package:medical_blog_app/features/med_calc/med_calc_page.dart';
import 'package:medical_blog_app/init_dependencies.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class BlogPage extends StatefulWidget {
  // static route() => MaterialPageRoute(builder: (context) => const BlogPage());

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BlogBloc>(context).add(BlogFetchBlogsEvent());
  }
  // final pages = [

  //   MedCalcPage(),
  //   CasesPage()
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: ,
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CircleAvatar(
                radius: 5,
                
                child: IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Icon(Icons.person),
                  color: Colors.black,
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
                  Navigator.push(context, AddNewBlogPage.route());
                },
                icon: Icon(CupertinoIcons.add_circled))
          ],
        ),
        drawer: ProfileDrawer(),
        body: Container(
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
                  return ListView.builder(
                    itemCount: state.blogs.length,
                    itemBuilder: (context, index) {
                      return BlogCard(
                        backGroundColor: index % 3 == 0
                            ? AppPallete.gradient1
                            : index % 2 == 0
                                ? AppPallete.gradient2
                                : AppPallete.gradient3,
                        blog: state.blogs[index],
                      );
                    },
                  );
                }
                return Center(child: Container());
              },
              listener: (BuildContext context, BlogState state) {
                if (state is BlogFailureState){
                  print(state.message);
                  showSnackBar(context, state.message);
                }
              },
            ),
          ),
        ));
  }
}
