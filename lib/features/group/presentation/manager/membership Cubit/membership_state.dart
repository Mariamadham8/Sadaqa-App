part of 'membership_cubit.dart';

class _Unset {
  const _Unset();
}

const _unset = _Unset();

@immutable
class MembershipState {
  final bool isLoadingMembers;
  final bool isLoadingRole;
  final bool isJoining;
  final bool isCheckingMembership;

  final List<MembershipModel>? members;
  final String? role;
  final bool? isMember;
  final bool joined;

  final String? membersError;
  final String? roleError;
  final String? joinError;
  final String? checkError;

  const MembershipState({
    this.isLoadingMembers = false,
    this.isLoadingRole = false,
    this.isJoining = false,
    this.isCheckingMembership = false,
    this.members,
    this.role,
    this.isMember,
    this.joined = false,
    this.membersError,
    this.roleError,
    this.joinError,
    this.checkError,
  });

  MembershipState copyWith({
    bool? isLoadingMembers,
    bool? isLoadingRole,
    bool? isJoining,
    bool? isCheckingMembership,
    List<MembershipModel>? members,
    String? role,
    bool? isMember,
    bool? joined,
    Object? membersError = _unset,
    Object? roleError = _unset,
    Object? joinError = _unset,
    Object? checkError = _unset,
  }) {
    return MembershipState(
      isLoadingMembers: isLoadingMembers ?? this.isLoadingMembers,
      isLoadingRole: isLoadingRole ?? this.isLoadingRole,
      isJoining: isJoining ?? this.isJoining,
      isCheckingMembership: isCheckingMembership ?? this.isCheckingMembership,
      members: members ?? this.members,
      role: role ?? this.role,
      isMember: isMember ?? this.isMember,
      joined: joined ?? this.joined,
      membersError: membersError == _unset ? this.membersError : membersError as String?,
      roleError: roleError == _unset ? this.roleError : roleError as String?,
      joinError: joinError == _unset ? this.joinError : joinError as String?,
      checkError: checkError == _unset ? this.checkError : checkError as String?,
    );
  }
}