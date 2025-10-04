class ScheduleAppointmentParams {
  final String propertyId; // 24-char mongo id
  final String date;       // YYYY-MM-DD
  final String time;       // HH:mm (24h)
  final String visitType;  // property | online | office_vr
  final String? notes;     // optional
  final String? vrCity;    // required only if office_vr

  ScheduleAppointmentParams({
    required this.propertyId,
    required this.date,
    required this.time,
    required this.visitType,
    this.notes,
    this.vrCity,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "propertyId": propertyId,
      "date": date,
      "time": time,
      "visitType": visitType,
    };
    if (notes != null && notes!.isNotEmpty) map["notes"] = notes;
    if (visitType == "office_vr" && vrCity != null && vrCity!.isNotEmpty) {
      map["vrCity"] = vrCity;
    }
    return map;
  }
}
