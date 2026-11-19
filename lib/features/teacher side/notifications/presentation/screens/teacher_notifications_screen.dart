import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/router/app_routes.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../../domain/entities/notification_entity.dart';
import '../providers/teacher_notifications_providers.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notifications_empty_view.dart';
import '../widgets/notifications_error_view.dart';
import '../widgets/notifications_filter_bar.dart';

class TeacherNotificationsScreen extends ConsumerStatefulWidget {
  const TeacherNotificationsScreen({super.key});

  @override
  ConsumerState<TeacherNotificationsScreen> createState() =>
      _TeacherNotificationsScreenState();
}

class _TeacherNotificationsScreenState
    extends ConsumerState<TeacherNotificationsScreen> {
  NotificationFilter _filter = NotificationFilter.all;

  bool get _unreadOnly => _filter == NotificationFilter.unread;

  Future<void> _refresh() async {
    ref.invalidate(notificationsProvider(_unreadOnly));
    await ref
        .read(notificationsProvider(_unreadOnly).future)
        .then((_) {}, onError: (_) {});
  }

  void _open(NotificationEntity n) {
    if (!n.isRead) {
      ref.read(notificationActionsProvider.notifier).markRead(n.id);
    }

    final bookingId = n.bookingId;
    if (bookingId == null) return;
    Navigator.pushNamed(
      context,
      AppRoutes.teacherBookingDetails,
      arguments: bookingId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(notificationsProvider(_unreadOnly));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          NotificationsFilterBar(
            selected: _filter,
            onSelected: (f) => setState(() => _filter = f),
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => NotificationsErrorView(
                message: e is Failure
                    ? e.message
                    : 'Failed to load notifications',
                onRetry: () =>
                    ref.invalidate(notificationsProvider(_unreadOnly)),
              ),
              data: (items) => RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _refresh,
                child: items.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          NotificationsEmptyView(unreadOnly: _unreadOnly),
                        ],
                      )
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => NotificationTile(
                          item: items[i],
                          onTap: () => _open(items[i]),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
