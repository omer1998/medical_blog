import 'package:hive/hive.dart';
import 'package:medical_blog_app/features/blog/data/models/blog_model.dart';

abstract interface class BlogLocalDataSource {
  void uploadBlogs(List<BlogModel> blogs);
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;

  BlogLocalDataSourceImpl({required this.box});
  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    for (int i = 0; i < box.length; i++) {
      print(box.get(i.toString()));
      blogs.add(BlogModel.fromJson(box.get(i.toString())));
    }
    print("my blogs");
    print(blogs);
    return blogs;
  }

  @override
  void uploadBlogs(List<BlogModel> blogs) {
    box.clear();

    for (var i = 0; i < blogs.length; i++) {
      box.put(i.toString(), blogs[i].toMap());
    }
  }
}
