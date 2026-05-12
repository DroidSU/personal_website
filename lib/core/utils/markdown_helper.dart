class MarkdownHelper {
  static String getExcerpt(String content, [int length = 150]) {
    // Remove markdown characters for plain text excerpt
    final plainText = content.replaceAll(RegExp(r'[*#_~`\[\]()]'), '');
    if (plainText.length <= length) return plainText;
    return '${plainText.substring(0, length)}...';
  }
}
