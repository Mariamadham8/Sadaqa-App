import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadaqa_app/core/utils/validators.dart';
import 'package:sadaqa_app/core/widgets/custom_button.dart';
import 'package:sadaqa_app/core/widgets/custom_input_field.dart';
import 'package:sadaqa_app/features/group/presentation/manager/contribution%20Cubit/contribution_cubit.dart';


class PaymentDialog extends StatefulWidget {
  const PaymentDialog({
    super.key,
    required this.groupId,
    required this.month,
  });

  /// الجروب اللي الدفعة دي بتاعته.
  final String groupId;

  /// cycle key الحالي للجروب (زي "2026-08-10") — لازم يجي من
  /// CycleUtils.currentCycleKeyForGroup(group.startDate) في الصفحة اللي
  /// بتفتح الديالوج. متحسبيهوش تاني هنا بطريقة مختلفة.
  final String month;

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to confirm a payment')),
      );
      return;
    }

    context.read<ContributionCubit>().updatePayment(
      userId: userId,
      groupId: widget.groupId,
      amount: double.parse(_amountController.text.trim().replaceAll(',', '.')),
      month: widget.month,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContributionCubit, ContributionState>(
      listener: (context, state) {
        if (state is PaymentUpdated) {
          Navigator.of(context).pop(true);
        }
        if (state is ContributionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ContributionLoading;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confirm Payment',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    controller: _amountController,
                    hint: 'Enter amount',
                    keyboardType: TextInputType.number,
                    validator: FieldValidators.amount,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: 'Confirm Payment',
                    isLoading: isLoading,
                    fullWidth: true,
                    onPressed: isLoading ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}