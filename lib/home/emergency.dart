import 'package:aayu_mobile/services/recommend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Emergencyform extends StatefulWidget {
  Emergencyform({required this.hospital});
  final List hospital;
  @override
  _EmergencyformState createState() => _EmergencyformState();
}

class _EmergencyformState extends State<Emergencyform> {
  final _formKey = GlobalKey<FormState>();
  String hospitalname = "",
      hospital = "",
      name = "unidentified",
      age = "undetermined",
      sex = "optional",
      bloodGroup = "optional",
      guardianContact = "",
      emergency = "Choose an Emergency",
      requireddepart = "";
  List sexlist = ["male", "female"];
  List bloodgrouplist = ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"];
  List emergencylist = [
    "Cuts by object",
    "Fire Burn",
    "Head Injury",
    "Road Hit",
    "Vehicle Accident",
    "Machinery Accident",
    "Cardiac Arrest",
    "Sudden fanting",
    "Maternity related",
    "Children accident"
  ];
  bool expand1 = false,
      expand2 = false,
      expand3 = false,
      loading = false,
      sent = false;
  double hei = 200;

  @override
  void initState() {
    print(widget.hospital);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: Colors.lightBlue,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Name:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextFormField(
                      onChanged: (input) => name = input,
                      decoration: new InputDecoration(
                        hintText: "Optional",
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      keyboardType: TextInputType.name,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ]),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Sex:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (expand1 == true) {
                          expand1 = false;
                        } else {
                          expand1 = true;
                        }
                      });
                    },
                    child: Column(children: [
                      Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: Colors.black, width: 0.8)),
                          constraints: BoxConstraints(maxWidth: 500),
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Center(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                Expanded(
                                    child: Text(
                                  sex,
                                  style: TextStyle(fontSize: 14),
                                )),
                                Icon(expand1
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down)
                              ]))),
                      expand1
                          ? SingleChildScrollView(
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 500),
                                height: 55,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: ListView.builder(
                                    itemCount: sexlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            sex = sexlist[index];
                                            expand1 = false;
                                          });
                                        },
                                        child: Container(
                                          height: 20,
                                          margin: EdgeInsets.all(1),
                                          color: Colors.grey[100],
                                          child: Center(
                                            child: Text(
                                              sexlist[index],
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          : SizedBox()
                    ]),
                  )
                ]),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Age:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (input) => age = input,
                      decoration: new InputDecoration(
                        hintText: "Optional",
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ]),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Text(
                      "Blood Group:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (expand2 == true) {
                          expand2 = false;
                        } else {
                          expand2 = true;
                        }
                      });
                    },
                    child: Column(children: [
                      Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: Colors.black, width: 0.8)),
                          constraints: BoxConstraints(maxWidth: 500),
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Center(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                Expanded(
                                    child: Text(
                                  bloodGroup,
                                  style: TextStyle(fontSize: 14),
                                )),
                                Icon(expand2
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down)
                              ]))),
                      expand2
                          ? SingleChildScrollView(
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 500),
                                height: 150,
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: ListView.builder(
                                    itemCount: bloodgrouplist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            bloodGroup = bloodgrouplist[index];
                                            expand2 = false;
                                          });
                                        },
                                        child: Container(
                                          height: 20,
                                          margin: EdgeInsets.all(1),
                                          color: Colors.grey[100],
                                          child: Center(
                                            child: Text(
                                              bloodgrouplist[index],
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          : SizedBox()
                    ]),
                  )
                ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
              child: Text(
                "*Guardian Contact no:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 12),
              constraints: BoxConstraints(maxWidth: 500),
              height: 60,
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                //checks if the field is empty or not
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Provide a valid number';
                  } else
                    return null;
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (input) => guardianContact = input,
                decoration: new InputDecoration(
                  hintText: "Required",
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Text(
                "*Emergency:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (expand3 == true) {
                      expand3 = false;
                    } else {
                      expand3 = true;
                    }
                  });
                },
                child: Column(children: [
                  Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black, width: 0.8)),
                      constraints: BoxConstraints(maxWidth: 500),
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                            Expanded(
                                child: Text(
                              emergency,
                              style: TextStyle(fontSize: 14),
                            )),
                            Icon(expand3
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down)
                          ]))),
                  expand3
                      ? SingleChildScrollView(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 500),
                            height: 220,
                            color: Colors.red,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ListView.builder(
                                itemCount: emergencylist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        emergency = emergencylist[index];
                                        expand3 = false;
                                      });
                                    },
                                    child: Container(
                                      height: 20,
                                      margin: EdgeInsets.all(1),
                                      color: Colors.grey[100],
                                      child: Center(
                                        child: Text(
                                          emergencylist[index],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 24,
                  ),
                  hospital == ""
                      ? loading
                          ? CircularProgressIndicator()
                          : GestureDetector(
                              onTap: () async {
                                setState(() {
                                  loading = true;
                                });

                                hospital = await findHospital(
                                    widget.hospital, emergency);
                                hospitalname = hospital;
                                setState(() {});
                              },
                              child: Container(
                                  margin: EdgeInsets.all(12),
                                  constraints: BoxConstraints(maxWidth: 500),
                                  width:
                                      MediaQuery.of(context).size.height * 0.32,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search, color: Colors.white),
                                      SizedBox(width: 20),
                                      Text("Find Hospital",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ))
                                    ],
                                  )),
                            )
                      : sent
                          ? Text("Ambulance is Arriving from")
                          : GestureDetector(
                              onTap: () async {
                                setState(() {
                                  sent = true;
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.all(8),
                                  constraints: BoxConstraints(maxWidth: 500),
                                  width:
                                      MediaQuery.of(context).size.height * 0.32,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.save, color: Colors.white),
                                      SizedBox(width: 20),
                                      Text("Send to",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ))
                                    ],
                                  )),
                            ),
                  Text(
                    hospitalname,
                    style: TextStyle(color: Colors.lightBlue),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
