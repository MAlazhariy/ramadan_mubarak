enum UserRole {
  user,
  moderator,
  admin,
}


extension GetUserRole on String? {
  UserRole toUserRole () {
    if(this == UserRole.user.name) {
      return UserRole.user;
    } else if(this == UserRole.moderator.name) {
      return UserRole.moderator;
    } else if(this == UserRole.admin.name) {
      return UserRole.admin;
    }

    return UserRole.user;
  }
}