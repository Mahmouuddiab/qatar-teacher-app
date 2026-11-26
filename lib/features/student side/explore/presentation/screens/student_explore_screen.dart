import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../widgets/explore_course_card.dart';
import '../widgets/explore_empty_view.dart';
import '../widgets/explore_list_footer.dart';
import '../widgets/explore_search_bar.dart';
import '../widgets/explore_subject_chips.dart';
import '../widgets/explore_ui_models.dart';
import 'student_course_details_screen.dart';

class StudentExploreScreen extends StatefulWidget {
  const StudentExploreScreen({super.key});

  @override
  State<StudentExploreScreen> createState() => _StudentExploreScreenState();
}

class _StudentExploreScreenState extends State<StudentExploreScreen> {
  static const int _pageSize = 6;
  // Space for the floating bottom nav bar
  static const double _bottomSpace = 120;

  final _scroll = ScrollController();
  Timer? _debounce;

  final List<ExploreCourseUi> _items = [];
  String _query = '';
  String? _subject; // null = All
  int _page = 0;
  bool _loading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _loadMore();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  /// TODO: replace with GET /api/Student/courses?page=&pageSize=&search=&subject=
  Future<List<ExploreCourseUi>> _fetchPage(int page) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final q = _query.trim().toLowerCase();
    final filtered = sampleExploreCourses.where((c) {
      final matchesSubject = _subject == null || c.subject == _subject;
      final matchesQuery = q.isEmpty ||
          c.title.toLowerCase().contains(q) ||
          c.teacherName.toLowerCase().contains(q);
      return matchesSubject && matchesQuery;
    }).toList();
    final start = (page - 1) * _pageSize;
    if (start >= filtered.length) return [];
    return filtered.skip(start).take(_pageSize).toList();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);

    final next = _page + 1;
    final result = await _fetchPage(next);
    if (!mounted) return;

    setState(() {
      _items.addAll(result);
      _page = next;
      _hasMore = result.length == _pageSize;
      _loading = false;
    });
  }

  /// Starts again from page 1 (new search, new subject, pull-to-refresh).
  Future<void> _reload() async {
    setState(() {
      _items.clear();
      _page = 0;
      _hasMore = true;
      _loading = false;
    });
    await _loadMore();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _query = value;
      _reload();
    });
  }

  void _onSubjectChanged(String? subject) {
    if (subject == _subject) return;
    _subject = subject;
    _reload();
  }

  void _openDetails(ExploreCourseUi course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentCourseDetailsScreen(course: course),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstLoad = _items.isEmpty && _loading;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.primary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            'Explore',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: ExploreSearchBar(onChanged: _onSearchChanged),
            ),
            ExploreSubjectChips(
              subjects: sampleSubjects, // TODO: from GET /api/Student/subjects
              selected: _subject,
              onSelected: _onSubjectChanged,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: firstLoad
                  ? const Center(
                child:
                CircularProgressIndicator(color: AppColors.primary),
              )
                  : RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _reload,
                child: _items.isEmpty
                    ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [ExploreEmptyView()],
                )
                    : ListView.builder(
                  controller: _scroll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                      16, 4, 16, _bottomSpace),
                  itemCount: _items.length + 1,
                  itemBuilder: (_, i) {
                    if (i == _items.length) {
                      return ExploreListFooter(
                        loading: _loading,
                        hasMore: _hasMore,
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ExploreCourseCard(
                        key: ValueKey(_items[i].id),
                        course: _items[i],
                        onTap: () => _openDetails(_items[i]),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}