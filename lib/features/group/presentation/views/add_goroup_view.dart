import 'package:flutter/material.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/add_group_boody.dart';

class AddGoroupView extends StatelessWidget {
  const AddGoroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: AddGroupBoody()));
  }
}
