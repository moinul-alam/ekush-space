import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'completion_animation_viewmodel.dart';

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
          .showCompletionAnimation();
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
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Success text
                    Text(
                      'অভিন্দোগ!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontFamily: 'NotoSansBengali',
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'আপনার সম্পন্ন হয়েছে',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontFamily: 'NotoSansBengali',
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          viewModel.hideCompletionAnimation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'ঠিকের ফিরুন',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'NotoSansBengali',
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
          left: (index % 7) * 50.0,
          top: (index % 5) * 100.0,
          child: Container(
            width: 8,
            height: 8,
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
