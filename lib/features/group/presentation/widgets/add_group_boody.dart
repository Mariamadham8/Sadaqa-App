import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadaqa_app/core/widgets/custom_button.dart';
import 'package:sadaqa_app/core/widgets/custom_datepicker_field.dart';
import 'package:sadaqa_app/core/widgets/custom_input_field.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../manager/group_cubit.dart';

class AddGroupBoody extends StatefulWidget {
  const AddGroupBoody({super.key});

  @override
  State<AddGroupBoody> createState() => _AddGroupBoodyState();
}

class _AddGroupBoodyState extends State<AddGroupBoody> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _paymentCtrl = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _amountCtrl.dispose();
    _contactCtrl.dispose();
    _paymentCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? now : (_startDate ?? now).add(const Duration(days: 30)),
      firstDate: now,
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end dates')),
      );
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to create a group')),
      );
      return;
    }

    context.read<GroupCubit>().createGroup(
      adminId: currentUser.uid,
      adminName: currentUser.displayName ?? 'Unknown',
      name: _nameCtrl.text.trim(),
      monthlyAmount: double.parse(_amountCtrl.text.trim()),
      startDate: _startDate!,
      endDate: _endDate!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state is GroupCreated) {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId != null) {
            context.read<GroupCubit>().loadUserGroups(userId);
          }
          Navigator.of(context).pop();
        }
        if (state is GroupFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      },
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── header ──────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.group_add_rounded,
                        color: AppColors.primaryDark,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Create New Group', style: AppTextStyles.displaySmall),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.textMuted,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── hint banner ──────────────────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline_rounded,
                          color: AppColors.primaryDark, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Groups let you collect monthly donations with your community easily.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── group name ────────────────────────────────
                _FieldLabel('Group Name'),
                InputField(
                  controller: _nameCtrl,
                  hint: 'e.g. Masjid Al-Noor Fund',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),

                const SizedBox(height: 14),

                // ── description ───────────────────────────────
                _FieldLabel('Description (optional)'),
                InputField(
                  controller: _descCtrl,
                  hint: 'What is this group collecting for?',
                  maxLines: 3,
                ),

                const SizedBox(height: 14),

                // ── monthly amount ────────────────────────────
                _FieldLabel('Monthly Amount (\$)'),
                InputField(
                  controller: _amountCtrl,
                  hint: '50',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Amount is required';
                    if (double.tryParse(v.trim()) == null) return 'Enter a valid number';
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // ── dates row ─────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel('Start Date'),
                          DatePickerField(
                            date: _startDate,
                            hint: 'Select',
                            onTap: () => _pickDate(isStart: true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel('End Date'),
                          DatePickerField(
                            date: _endDate,
                            hint: 'Select',
                            onTap: () => _pickDate(isStart: false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ── admin contact ─────────────────────────────
                _FieldLabel('Admin Contact'),
                InputField(
                  controller: _contactCtrl,
                  hint: 'e.g. +20 100 000 0001',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 14),

                // ── payment method ────────────────────────────
                _FieldLabel('Payment Method'),
                InputField(
                  controller: _paymentCtrl,
                  hint: 'e.g. Instapay — 010 0000 0001',
                ),

                const SizedBox(height: 24),

                // ── submit ────────────────────────────────────
                BlocBuilder<GroupCubit, GroupState>(
                  builder: (context, state) {
                    final isLoading = state is GroupLoading;
                    return AppButton(
                      label: 'Create Group',
                      onPressed: _submit,
                      isLoading: isLoading,
                      fullWidth: true,
                      size: AppButtonSize.large,
                      icon: Icons.check_rounded,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── helpers ───────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          letterSpacing: 0.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}