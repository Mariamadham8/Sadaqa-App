import 'package:flutter/material.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/welcome_card.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../data/models/group_model.dart';
import 'group_card.dart';

class GroupsListBody extends StatelessWidget {
    GroupsListBody({super.key});

  // ── static data (replace with real BLoC data later) ──────
  static final List<GroupModel> _mockGroups = [
    GroupModel(
      id: '1',
      adminId: 'admin1',
      adminName: 'Mariem Adham',
      name: 'Masjid Al-Noor Fund',
      discriptoin: 'Monthly fund for the local masjid maintenance.',
      monthlyAmount: 50,
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 12, 1),
      inviteLink: 'https://khairhub.app/join/masjid-alnoor',
      adminContact: '+20 100 000 0001',
      paymentMethod: 'Instapay — 010 0000 0001',
    ),
    GroupModel(
      id: '2',
      adminId: 'admin1',
      adminName: 'Mariem Adham',
      name: 'Orphan Sponsorship',
      discriptoin: 'Sponsoring 5 orphans monthly.',
      monthlyAmount: 30,
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 12, 1),
      inviteLink: 'https://khairhub.app/join/orphan',
      adminContact: '+20 100 000 0002',
      paymentMethod: 'Bank Transfer — CIB',
    ),
    GroupModel(
      id: '3',
      adminId: 'admin1',
      adminName: 'Mariem Adham',
      name: 'Community Food Bank',
      discriptoin: 'Weekly food basket for 10 families.',
      monthlyAmount: 25,
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 12, 1),
      inviteLink: 'https://khairhub.app/join/foodbank',
      adminContact: '+20 100 000 0003',
      paymentMethod: 'Vodafone Cash — 010 0000 0003',
    ),
  ];

  static const int _paidCount = 1;
        final groups = _mockGroups;
        final paidCount = _paidCount;
        final total = _mockGroups.length;
      
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
       slivers: [
       
       
              // ── welcome card ────────────────────────────
              SliverToBoxAdapter(
                child: WelcomeCard(paidCount: paidCount, total: total),
              ),

              // ── section title ────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
                  child: Text('Your Groups', style: AppTextStyles.headingLarge),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final group = groups[index];
                  final isPaid = index == 0; // replace with real paid logic
                  return GroupCard(
                    group: group,
                    isPaid: isPaid,
                    onPayPressed: isPaid
                        ? null
                        : () {
                            // TODO: handle payment navigation
                          },
                    onTap: () {
                      // TODO: navigate to GroupDetailsView(group)
                    },
                  );
                }, childCount: groups.length),
              ),

              // ── bottom padding for FAB ────────────────────
              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          );
  }
}
