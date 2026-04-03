// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/jhuri_base_screen.dart';
import '../../config/jhuri_constants.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          JhuriConstants.appName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'HindSiliguri',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Settings will be implemented in Phase 4
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: _buildEmptyState(colorScheme),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create list will be implemented in Phase 3
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create list coming soon')),
          );
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Empty State Icon ──────────────────────
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.shopping_basket_outlined,
                size: 60,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // ── Empty State Title ────────────────────
            Text(
              'বাজারের কোনো ফর্দ নেই',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                fontFamily: 'NotoSansBengali',
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // ── Empty State Message ──────────────────
            Text(
              '"+", বাটন চেপে নতুন ফর্দ তৈরি করুন',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontFamily: 'NotoSansBengali',
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 48),
            
            // ── Quick Start Tips ────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'দ্রুত শুরু করুন',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTipItem(
                    context,
                    icon: Icons.add_circle_outline,
                    title: 'নতুন ফর্দ তৈরি করুন',
                    description: '+ বাটনে ক্লিক করে নতুন ফর্দ শুরু করুন',
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem(
                    context,
                    icon: Icons.category_outlined,
                    title: 'বিভাগ নির্বাচন',
                    description: 'প্রয়োজনীয় আইটেমের বিভাগ বেছে নিন',
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem(
                    context,
                    icon: Icons.shopping_cart_outlined,
                    title: 'আইটেম যোগ করুন',
                    description: 'সহজেই আপনার বাজারের তালিকা তৈরি করুন',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
