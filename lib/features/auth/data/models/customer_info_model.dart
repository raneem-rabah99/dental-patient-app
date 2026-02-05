import 'dart:io';

class CustomerInfoModel {
  final String birthdate;
  final File? patientRecordFile;
  final String? patientRecordText;

  CustomerInfoModel({
    required this.birthdate,
    this.patientRecordFile,
    this.patientRecordText,
  });

  Map<String, dynamic> toJson() {
    return {"birthdate": birthdate, "patient_record_text": patientRecordText};
  }
}
