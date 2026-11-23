import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'package:qatar_teachers/core/widgets/app_snackbar.dart';
import 'package:qatar_teachers/features/teacher%20side/notifications/domain/entities/notification_entity.dart';
import 'package:qatar_teachers/features/teacher%20side/notifications/presentation/widgets/notification_tile.dart';
import 'package:qatar_teachers/features/teacher%20side/notifications/presentation/widgets/notifications_empty_view.dart';
import 'package:qatar_teachers/features/teacher%20side/notifications/presentation/widgets/notifications_error_view.dart';
import 'package:qatar_teachers/features/teacher%20side/notifications/presentation/widgets/notifications_filter_bar.dart';
import '../providers/student_notifications_providers.dart';

class StudentNotificationsScreen extends ConsumerStatefulWidget {
  const StudentNotificationsScreen({super.key});

  @override
  ConsumerState<StudentNotificationsScreen> createState() =>
      _StudentNotificationsScreenState();
}

class _StudentNotificationsScreenState
    extends ConsumerState<StudentNotificationsScreen> {
  NotificationFilter _filter = NotificationFilter.all;

  bool get _unreadOnly => _filter == NotificationFilter.unread;

  Future<void> _refresh() async {
    ref.invalidate(studentNotificationsProvider(_unreadOnly));
    ref.invalidate(studentUnreadCountProvider);
    await ref
        .read(studentNotificationsProvider(_unreadOnly).future)
        .then((_) {}, onError: (_) {});
  }

  void _open(NotificationEntity n) {
    // Fire and forget: navigation shouldn't wait for this request
    if (!n.isRead) {
      ref.read(studentNotificationActionsProvider.notifier).markRead(n.id);
    }
    // TODO: open student booking details with n.bookingId
  }

  Future<void> _markAllRead() async {
    final error = await ref
        .read(studentNotificationActionsProvider.notifier)
        .markAllRead();
    if (error != null) {
      AppSnackBar.error(error);
    } else {
      AppSnackBar.success('All notifications marked as read');
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(studentNotificationsProvider(_unreadOnly));
    final busy = ref.watch(studentNotificationActionsProvider);
    final unread = ref.watch(studentUnreadCountProvider).value ?? 0;

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
        actions: [
          if (busy)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          else if (unread > 0)
            IconButton(
              tooltip: 'Mark all as read',
              icon: const Icon(Icons.done_all_rounded),
              onPressed: _markAllRead,
            ),
        ],
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
                    ref.invalidate(studentNotificationsProvider(_unreadOnly)),
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
