// 양수 및 음수에 따라 앞에 +/- 또는 ▲/▼ 붙이기

// + 또는 - 붙이기 
String formatPositiveValue(dynamic value) {
  return '${value > 0 ? '+' : ''}$value%';
}

// ▲ 또는 ▼ 붙이기
String formatArrowIndicator(dynamic value) {
  if (value > 0) {
    return '▲ ${value}';
  } else if (value < 0) {
    return '▼ ${value.abs()}';
  } else {
    return '$value'; 
  }
}
