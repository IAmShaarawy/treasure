enum Categories {
  ISLAMIC,
  COPTIC,
  PHARAONIC,
  GRECIAN,
}

Categories categoryFromString(String role) {
  Categories enumValue;
  Categories.values.forEach((item) {
    if (item.toString() == role) {
      enumValue = item;
    }
  });
  return enumValue;
}

String categoryLabel(Categories cat) {
  switch (cat) {
    case Categories.ISLAMIC:
      return "Islamic";
      break;
    case Categories.COPTIC:
      return "Coptic";
      break;
    case Categories.PHARAONIC:
      return "Pharaonic";
      break;
    case Categories.GRECIAN:
      return "Grecian";
      break;

    default:
      return "NOT HANDLED";
  }
}

String categoryImage(Categories cat) {
  switch (cat) {
    case Categories.ISLAMIC:
      return "https://static.toiimg.com/photo/msid-52554705,width-96,height-65.cms";
      break;
    case Categories.COPTIC:
      return "https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Coptic_cross.svg/2000px-Coptic_cross.svg.png";
      break;
    case Categories.PHARAONIC:
      return "https://daily.jstor.org/wp-content/uploads/2014/09/pyramids.jpg";
      break;
    case Categories.GRECIAN:
      return "https://cdn.britannica.com/69/75569-050-7AB67C4B/herm-Socrates-half-original-Greek-Capitoline-Museums.jpg";
      break;
    default:
      return "NOT HANDLED";
  }
}
