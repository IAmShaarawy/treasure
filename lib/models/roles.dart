enum Roles { USER, ADMIN,}

Roles roleFromString(String role) {
  Roles enumValue;
  Roles.values.forEach((item) {
    if (item.toString() == role) {
      enumValue = item;
    }
  });
  return enumValue;
}

String rolesLabel(Roles role) {
  switch (role) {
    case Roles.USER:
      return "Parent";
      break;
    case Roles.ADMIN:
      return "Admin";
      break;
  }
  return "NOT HANDLED";
}
