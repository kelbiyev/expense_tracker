
String normalizeAz(String input) {
  const replacements = {
    'ə': 'e', 'Ə': 'E',
    'ı': 'i', 'I': 'i',
    'ö': 'o', 'Ö': 'O',
    'ü': 'u', 'Ü': 'U',
    'ş': 's', 'Ş': 'S',
    'ç': 'c', 'Ç': 'C',
    'ğ': 'g', 'Ğ': 'G',
  };

  var result = input;
  replacements.forEach((from, to) {
    result = result.replaceAll(from, to);
  });
  return result.toLowerCase().trim();
}