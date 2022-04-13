class CMSText {
  final int? id;
  final String? cmsText;

  CMSText({
    this.id,
    this.cmsText,
  });

  factory CMSText.fromJson(Map<String, dynamic> json) {
    return CMSText(
      id: json['id'],
      cmsText: json['cmsText'],
    );
  }
}
