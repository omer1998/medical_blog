import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/common/widgets/loader.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/blog/controllers/blog_controllers.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/add_new_blog_page_section.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/bloc/blog_bloc.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/profile_drawer.dart';
import 'package:medical_blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:medical_blog_app/features/blog/presentation/widgets/blog_search_delegate.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class BlogPage extends ConsumerStatefulWidget {
  const BlogPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlogPageState();
}

class _BlogPageState extends ConsumerState<BlogPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BlogBloc>(context).add(BlogFetchBlogsEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels > 100 && _showFab) {
      setState(() => _showFab = false);
    } else if (_scrollController.position.pixels <= 100 && !_showFab) {
      setState(() => _showFab = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId =
        (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState)
            .user
            .id;
    final user =
        (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState)
            .user;
    List<String> allAvailableBlogTags = [];
    return Scaffold(
      key: _scaffoldKey,
      drawer: ProfileDrawer(user: user),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text("Medical Blog"),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: InkWell(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: ClipRRect(
                  
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: user.img_url!,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.white,
                      child: Image.asset(
                          "assets/images/profile_images/doctor_logo_3.jpg"),
                    ),
                    placeholder: (context, url) {
                      return Container(
                      color: Colors.white,
                      child: Image.asset(
                          "assets/images/profile_images/doctor_logo_3.jpg"),
                    );
                    },
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    
                  ),
                ),
              ),
            ),
            actions: [
            //   TextButton(onPressed: ()async{
            //  try {
            //   List<String> casesId = ["81755775-4468-47c4-98cb-1ecfb36a45e6","a4b044e4-53a2-422e-b96e-aeb84e4387f3", 
            //   "f1781249-8b95-4ead-a1a2-d0266cb27501", "f9d97437-15cd-4049-8c3b-d29d9988bba8"
            //   ];
            //   casesId.forEach((e) async {
            //      await  ref.read(supabaseClientProvider).from("blogs").delete().eq("id",e );
             
            
            //   });
             
            //  } catch (e) {
            //    print(e.toString());
            //  } }, child: Text("delete cases")),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: BlogSearchDelegate(mainAppUser: user),
                  );
                },
              ),
            ],
          ),
          BlocBuilder<BlogBloc, BlogState>(
            builder: (context, state) {
              if (state is BlogLoadingState) {
                return const SliverFillRemaining(
                  child: Center(child: Loader()),
                );
              }

              if (state is BlogFailureState) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              }

              if (state is BlogsSuccessState) {
                allAvailableBlogTags = state.availableTopics;
                return SliverPadding(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final blog = state.blogs[index];
                        final color = Colors.primaries[
                            Random().nextInt(Colors.primaries.length)];
                        return BlogCard(
                          blog: blog,
                          backGroundColor: color,
                          mainUser: user,
                        );
                      },
                      childCount: state.blogs.length,
                    ),
                  ),
                );
              }

              return const SliverFillRemaining(
                child: Center(
                  child: Text('No blogs found'),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showFab ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _showFab ? 1 : 0,
          child: FloatingActionButton.extended(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => AddNewBlogSection(userId: userId),
              //   ),
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddNewBlogPage(availableTags: allAvailableBlogTags),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.add),
            label: const Text('New Blog'),
          ),
        ),
      ),
    );
  }
}
