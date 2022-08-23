Future findHospital(List hospital, String emergency) async {
  print(hospital);
  String requireddepart = "";
  if (emergency == "Fire Burn" || emergency == "Cuts by object") {
    requireddepart = "Plastic Surgery";
  }
  if (emergency == "Cardiac Arrest" || emergency == "Sudden fanting") {
    requireddepart = "Cardiomedicine";
  }
  if (emergency == "Road Hit" ||
      emergency == "Vehicle Accident" ||
      emergency == "Head Injury" ||
      emergency == "Machinery Accident") {
    requireddepart = "Orthopedics";
  }
  if (emergency == "Maternity related") {
    requireddepart = "Obstetrics and Gynaecology";
  }
  if (emergency == "Children accident") {
    requireddepart = "Pediatrics";
  }
  for (int i = 0; i < hospital.length; i++) {
    var hospitaldata = hospital[i][0];

    for (int k = 0; k < hospitaldata['department'].length; k++) {
      if (hospitaldata['department'][k]['department_name'] == requireddepart) {
        for (int l = 0;
            l < hospitaldata['department'][k]['doctor'].length;
            l++) {
          if (hospitaldata['department'][k]['doctor'][l]["status"] ==
              "active") {
            String selectedHospital = hospitaldata["hospital_name"];
            print(selectedHospital);
            break;
          }
        }
      }
    }
  }
  return hospital[0][0]["hospital_name"];
}
