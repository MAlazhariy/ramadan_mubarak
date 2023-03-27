enum UserStatus {
  newMember,
  approved,
  rejected,
  blocked,
}


extension GetUserStatus on String {
  UserStatus toUserStatus () {
    if(this == UserStatus.newMember.name) {
      return UserStatus.newMember;
    } else if(this == UserStatus.approved.name) {
      return UserStatus.approved;
    } else if(this == UserStatus.rejected.name) {
      return UserStatus.rejected;
    } else if(this == UserStatus.blocked.name) {
      return UserStatus.blocked;
    }

    return UserStatus.newMember;
  }
}