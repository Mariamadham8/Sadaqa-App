import 'package:flutter/material.dart';
import 'package:sadaqa_app/core/widgets/custom_button.dart';
import 'package:sadaqa_app/core/widgets/custom_input_field.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
   TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      child: Column(
        children: [
          InputField(
            controller: amountController, 
            hint: 'Enter amount', 
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          AppButton(label: 'Change Status',
           onPressed: () {  
                
          },

          )
        ],
      ),
    );
  }
}