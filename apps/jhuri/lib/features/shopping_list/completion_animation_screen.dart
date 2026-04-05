import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ekush_core/ekush_core.dart';
import 'completion_animation_viewmodel.dart';
import '../../../l10n/jhuri_localizations.dart';

class CompletionAnimationScreen extends ConsumerStatefulWidget {
  final int listId;

  const CompletionAnimationScreen({super.key, required this.listId});

  @override
  ConsumerState<CompletionAnimationScreen> createState() =>
      _CompletionAnimationScreenState();
}

class _CompletionAnimationScreenState
    extends ConsumerState<CompletionAnimationScreen> {
  @override
  void initState() {
    super.initState();
    // Start completion animation after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(completionAnimationViewModelProvider.notifier)
          .completeListWithAnimation(widget.listId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(completionAnimationViewModelProvider);
    final viewModel = ref.read(completionAnimationViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      body: Stack(
        children: [
          // Confetti animation
          if (viewState is ViewStateSuccess && viewModel.isShowingCompletion)
            Positioned.fill(
              child: _buildConfettiAnimation(),
            ),

          // Completion overlay
          if (viewState is ViewStateSuccess && viewModel.isShowingCompletion)
            Center(
              child: Container(
                margin: EdgeInsets.all(32.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success icon
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Success text
                    Text(
                      JhuriLocalizations.of(context).congratulations,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Subtitle
                    Text(
                      JhuriLocalizations.of(context).yourListCompleted,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          JhuriLocalizations.of(context).okayLetsGo,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConfettiAnimation() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
    ];
    return Stack(
      children: List.generate(30, (index) {
        return Positioned(
          left: (index % 7) * 50.0.w,
          top: (index % 5) * 100.0.h,
          child: Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
