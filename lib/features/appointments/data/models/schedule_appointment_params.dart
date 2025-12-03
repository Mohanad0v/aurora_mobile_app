class ScheduleAppointmentParams {
  final String propertyId;
  final String date;
  final String time;
  final String visitType;
  final String? notes;
  final String? vrCity;

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
