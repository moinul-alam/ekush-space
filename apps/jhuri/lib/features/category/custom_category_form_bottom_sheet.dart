import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/database_provider.dart';

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
  String _selectedEmoji = '';
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.category,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'নতুন বিভাগ তৈরি',
                      style: TextStyle(
                        fontSize: 20,
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
              const SizedBox(height: 24),

              // Bangla Name (required)
              Text(
                'বিভাগের নাম *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _banglaNameController,
                decoration: InputDecoration(
                  hintText: 'যেমন: ফলমূল',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 16),

              // English Name (optional)
              Text(
                'ইংরেজি নাম',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _englishNameController,
                decoration: InputDecoration(
                  hintText: 'যেমন: Fruits',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Emoji Icon
              Text(
                'ইমোজি আইকন',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              if (!_showEmojiPicker) ...[
                // Emoji selection grid
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _suggestedEmojis.map((emoji) {
                    final isSelected = _selectedEmoji == emoji;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedEmoji = emoji;
                        });
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: colorScheme.primary, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                // Custom emoji button
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showEmojiPicker = true;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('অন্য ইমোজি যোগ করুন'),
                ),
              ] else ...[
                // Custom emoji input
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emojiController,
                        decoration: InputDecoration(
                          hintText: 'ইমোজি টাইপ করুন',
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
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showEmojiPicker = false;
                          _emojiController.clear();
                        });
                      },
                      child: const Text('বাতিল'),
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('বাতিল'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canSave() ? _saveCategory : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('সংরক্ষণ করুন'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
          const SnackBar(content: Text('বিভাগ সংরক্ষণ হয়েছে')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ত্রুটি: $e')),
        );
      }
    }
  }
}
