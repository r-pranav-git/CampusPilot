class PlacementApplication {
  final String id;
  final String company;
  final String role;
  final String stage;
  final DateTime appliedOn;

  const PlacementApplication({
    required this.id,
    required this.company,
    required this.role,
    required this.stage,
    required this.appliedOn,
  });

  PlacementApplication copyWith(
          {String? company, String? role, String? stage}) =>
      PlacementApplication(
        id: id,
        company: company ?? this.company,
        role: role ?? this.role,
        stage: stage ?? this.stage,
        appliedOn: appliedOn,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'company': company,
        'role': role,
        'stage': stage,
        'appliedOn': appliedOn.toIso8601String(),
      };

  factory PlacementApplication.fromJson(Map<String, dynamic> json) =>
      PlacementApplication(
        id: json['id'] as String,
        company: json['company'] as String,
        role: json['role'] as String,
        stage: json['stage'] as String,
        appliedOn: DateTime.parse(json['appliedOn'] as String),
      );
}
