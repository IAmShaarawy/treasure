enum Categories { ISLAMIC, COPTIC, PHARAONIC }

Categories categoryFromString(String role) {
  Categories enumValue;
  Categories.values.forEach((item) {
    if (item.toString() == role) {
      enumValue = item;
    }
  });
  return enumValue;
}

String categoryLabel(Categories role) {
  switch (role) {
    case Categories.ISLAMIC:
      return "Islamic";
      break;
    case Categories.COPTIC:
      return "Coptic";
      break;
    case Categories.PHARAONIC:
      return "Pharaonic";
      break;
    default:
      return "NOT HANDLED";
  }
}
