import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/database_provider.dart';
import '../../l10n/jhuri_localizations.dart';

class CustomCategoryFormBottomSheet extends ConsumerStatefulWidget {
  const CustomCategoryFormBottomSheet({super.key});

  @override
  ConsumerState<CustomCategoryFormBottomSheet> createState() =>
      _CustomCategoryFormBottomSheetState();
}

class _CustomCategoryFormBottomSheetState
    extends ConsumerState<CustomCategoryFormBottomSheet> {
  final _banglaNameController = TextEditingController();
  final _englishNameController = TextEditingController();
  final _emojiController = TextEditingController();
  String _selectedEmoji = '🏷️';
  bool _showEmojiPicker = false;

  final List<String> _suggestedEmojis = [
    '🥬',
    '🐟',
    '🥩',
    '🍚',
    '🫘',
    '🧴',
    '🥛',
    '🍎',
    '🏠',
    '➕'
  ];

  @override
  void dispose() {
    _banglaNameController.dispose();
    _englishNameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.category,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      JhuriLocalizations.of(context).createNewCategoryForm,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Bangla Name (required)
              Text(
                JhuriLocalizations.of(context).categoryNameRequired,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _banglaNameController,
                decoration: InputDecoration(
                  hintText: JhuriLocalizations.of(context).categoryNameHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                textDirection: TextDirection.ltr,
              ),
              SizedBox(height: 16.h),

              // English Name (optional)
              Text(
                JhuriLocalizations.of(context).englishNameOptional,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _englishNameController,
                decoration: InputDecoration(
                  hintText: JhuriLocalizations.of(context).englishNameHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Emoji Icon
              Text(
                JhuriLocalizations.of(context).emojiIcon,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              if (!_showEmojiPicker) ...[
                // Emoji selection grid
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _suggestedEmojis.map((emoji) {
                    final isSelected = _selectedEmoji == emoji;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedEmoji = emoji;
                        });
                      },
                      child: Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8.r),
                          border: isSelected
                              ? Border.all(color: colorScheme.primary, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: TextStyle(
                              fontSize: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 8.h),
                // Custom emoji button
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showEmojiPicker = true;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: Text(JhuriLocalizations.of(context).addOtherEmoji),
                ),
              ] else ...[
                // Custom emoji input
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emojiController,
                        decoration: InputDecoration(
                          hintText: JhuriLocalizations.of(context).typeEmoji,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _selectedEmoji = value;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showEmojiPicker = false;
                          _emojiController.clear();
                        });
                      },
                      child: Text(JhuriLocalizations.of(context).cancel),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(JhuriLocalizations.of(context).cancel),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canSave() ? _saveCategory : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(JhuriLocalizations.of(context).save),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  bool _canSave() {
    return _banglaNameController.text.trim().isNotEmpty &&
        _selectedEmoji.isNotEmpty;
  }

  Future<void> _saveCategory() async {
    try {
      final categoryRepo = ref.read(categoryRepositoryProvider);

      await categoryRepo.createCustomCategory(
        nameBangla: _banglaNameController.text.trim(),
        nameEnglish: _englishNameController.text.trim().isEmpty
            ? _banglaNameController.text.trim()
            : _englishNameController.text.trim(),
        iconIdentifier: _selectedEmoji,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(JhuriLocalizations.of(context).categorySavedSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${JhuriLocalizations.of(context).errorWithSuffixDynamicCategory}$e')),
        );
      }
    }
  }
}
