import 'package:flutter/material.dart';
import 'package:smart_taal_system/forms/fields/dropdown_field.dart';
import 'package:smart_taal_system/forms/fields/output_text_field.dart';
import 'package:smart_taal_system/forms/input/form_page_two.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:smart_taal_system/forms/lists/fishing_gear_list.dart';
import 'package:smart_taal_system/forms/output/form_preview.dart';
import 'package:smart_taal_system/widgets/warnings/back_warning.dart';
import 'package:sqflite/sqflite.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../backend/user_db.dart';
import '../../widgets/buttons/add_button.dart';
import '../fields/text_input_field.dart';
import '../lists/landing_center_list.dart';
import 'arguments.dart';

class NewActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewActivityState();
}

class _NewActivityState extends State<NewActivity> {
  TextEditingController landingCenterController = TextEditingController();
  TextEditingController fishingGroundController = TextEditingController();
  TextEditingController totalLandingsController = TextEditingController();
  TextEditingController boatNameController = TextEditingController();
  TextEditingController fishingGearController = TextEditingController();
  TextEditingController fishingEffortController = TextEditingController();
  TextEditingController totalBoatCatchController = TextEditingController();
  TextEditingController sampleSerialNumberController = TextEditingController();
  TextEditingController totalSampleWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  static final RegExp numericRegExp = RegExp(r'^[0-9]+$');
  DateTime dateTime = DateTime.now();

  Future<bool?> showWarning(BuildContext context) async =>
      showDialog<bool>(context: context, builder: (context) => BackWarning());

  Future<void> _selectDate(BuildContext context, passedDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: passedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null &&
        picked != passedDate &&
        (picked.isBefore(DateTime.now()))) {
      setState(() {
        passedDate = picked;
      });
    } else {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Paalala", style: TextStyle(fontSize: 30)),
                content: Text(
                    "Maaaring wala kang napili o hindi pa kasi nakalilipas ang araw na pinili mo.",
                    style: TextStyle(fontSize: 20)),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as FormOneArguments;
    TextEditingController enumeratorController =
        TextEditingController(text: '${args.firstName} ${args.lastName}');
    // void _setUser() async {
    //   setState(() {
    //     enumeratorController.text = "${args.firstName} ${args.lastName}";
    //   });
    // }
    showPreview(BuildContext context, passedDate) => showDialog<String>(
        context: context,
        builder: (BuildContext context) => FormPreview(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Detalye ng Lugar",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        Icon(Icons.location_on, color: Colors.black)
                      ],
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    SizedBox(height: 20),
                    OutputTextField(
                        label: Text("Pangalan ng Enumerator"),
                        content: "${enumeratorController.text}"),
                    SizedBox(height: 20),
                    OutputTextField(
                        label: Text("Lugar ng Pinangisdaan"),
                        content: "${fishingGroundController.text}"),
                    SizedBox(height: 20),
                    OutputTextField(
                        label: Text("Lugar ng Daungan"),
                        content: "${landingCenterController.text}"),
                    SizedBox(height: 20),
                    OutputTextField(
                        label: Text("Bilang ng Lahat ng Dumaong"),
                        content: "${totalLandingsController.text}"),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Detalye ng Dumaong",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        Icon(Icons.directions_boat, color: Colors.black)
                      ],
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    SizedBox(height: 20),
                    OutputTextField(
                        label: Text("Pangalan ng Bangka"),
                        content: "${boatNameController.text}"),
                    SizedBox(height: 20),
                    OutputTextField(
                        label: Text("Gear na Ginamit"),
                        content: "${fishingGearController.text}"),
                    SizedBox(height: 20),
                    OutputTextField(
                        label: Text("Tagal ng Pangingisda"),
                        content: "${fishingEffortController.text} oras"),
                    SizedBox(height: 20),
                    OutputTextField(
                        label: Text("Timbang ng Nahuli ng Bangka"),
                        content: "${totalBoatCatchController.text} kg"),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Detalye ng Sample",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        Icon(Icons.inbox, color: Colors.black)
                      ],
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    SizedBox(height: 20),
                    OutputTextField(
                        label: Text("Sample Serial Number"),
                        content: "${sampleSerialNumberController.text}"),
                    SizedBox(height: 20),
                    OutputTextField(
                        label: Text("Timbang ng Sample"),
                        content: "${totalSampleWeightController.text}"),
                  ],
                ),
              ],
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  NewSpecies.routeName,
                  arguments: FormTwoArguments(
                    passedDate,
                    enumeratorController.text,
                    fishingGroundController.text,
                    landingCenterController.text,
                    totalLandingsController.text,
                    boatNameController.text,
                    fishingGearController.text,
                    fishingEffortController.text,
                    totalBoatCatchController.text,
                    sampleSerialNumberController.text,
                    totalSampleWeightController.text,
                  ),
                ).then((_) => setState(() {}));
              },
            ));
    return WillPopScope(
        onWillPop: () async {
          print('Ikaw ay bumalik');
          final shouldPop = await showWarning(context);
          return shouldPop ?? false;
        },
        child: Scaffold(
            body: Container(
                margin: EdgeInsets.all(20),
                child: Container(
                    child: RawScrollbar(
                        thumbColor: Color.fromARGB(139, 76, 175, 79),
                        radius: Radius.circular(10),
                        child: SingleChildScrollView(
                            reverse: false,
                            physics: BouncingScrollPhysics(),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 20, bottom: 10),
                                              child: Text(
                                                  "LANDED CATCH AND EFFORT MONITORING",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w800))),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(children: [
                                                  Text(
                                                      DateFormat('MM/dd/yyyy')
                                                          .format(
                                                              args.passedDate),
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                  TextButton(
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.purple,
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          5))),
                                                          height: 30,
                                                          width: 50,
                                                          child: Center(
                                                            child: Text(
                                                                "I-edit",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          )),
                                                      onPressed: () {
                                                        _selectDate(context,
                                                            args.passedDate);
                                                      })
                                                ]),
                                                Text(
                                                    "Tala ni: ${enumeratorController.text}",
                                                    style:
                                                        TextStyle(fontSize: 18))
                                              ]),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 30, bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Detalye ng Lugar',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w800)),
                                                  Icon(Icons.location_on,
                                                      color: Colors.black)
                                                ],
                                              )),
                                          TextInputField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Walang sagot; ilagay ang pangalan';
                                              }
                                              return null;
                                            },
                                            controller: enumeratorController,
                                            labelText: "Pangalan ng Enumerator",
                                            keyboardType: TextInputType.name,
                                          ),
                                          // TextInputField(
                                          //   validator: (value) {
                                          //     if (value == null ||
                                          //         value.isEmpty) {
                                          //       return 'Walang sagot; pumili ng lugar';
                                          //     }
                                          //     return null;
                                          //   },
                                          //   controller: fishingGroundController,
                                          //   labelText: "Lugar ng Pinangisdaan",
                                          //   keyboardType: TextInputType.name,
                                          // ),
                                          DropDownField(
                                            items: ['Municipal', 'Commercial'],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Walang sagot; pumili ng lugar';
                                              }
                                              return null;
                                            },
                                            labelTextOne:
                                                "Lugar ng Pinangisdaan",
                                            labelTextTwo:
                                                "Anong klasipikasyon ng lugar?",
                                            icon: Icon(Icons.location_on),
                                            onChanged: (String? value) {
                                              setState(() {
                                                fishingGroundController.text =
                                                    value!;
                                              });
                                            },
                                          ),
                                          DropDownField(
                                            items: landingCentersList,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Walang sagot; pumili ng lugar';
                                              }
                                              return null;
                                            },
                                            labelTextOne: "Lugar ng Daungan",
                                            labelTextTwo:
                                                "Hanapin ang Lugar ng Dinaungan",
                                            icon: Icon(Icons.location_on),
                                            onChanged: (String? value) {
                                              setState(() {
                                                landingCenterController.text =
                                                    value!;
                                              });
                                            },
                                          ),
                                          TextInputField(
                                            validator: (value) => value.isEmpty
                                                ? 'Walang sagot; Ilagay ang bilang ng dumaong'
                                                : (numericRegExp.hasMatch(value)
                                                    ? null
                                                    : 'Hindi ito pwede. Siguraduhing mga numero (0 - 9)\nlang ang nilagay mo.'),
                                            // if (value == null ||
                                            //     value.isEmpty) {
                                            //   return 'Walang sagot; ilagay ang dami ng dumaong';
                                            // }
                                            // return null;

                                            controller: totalLandingsController,
                                            labelText:
                                                "Bilang ng Lahat ng Dumaong",
                                            keyboardType: TextInputType.number,
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 30, bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Detalye ng Dumaong',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w800)),
                                                  Icon(Icons.directions_boat,
                                                      color: Colors.black)
                                                ],
                                              )),
                                          TextInputField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Walang sagot; ilagay ang pangalan ng bangka';
                                              }
                                              return null;
                                            },
                                            controller: boatNameController,
                                            labelText: "Pangalan ng Bangka",
                                            keyboardType: TextInputType.name,
                                          ),
                                          DropDownField(
                                              items: fishingGearList,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Walang sagot; pumili ng gear';
                                                }
                                                return null;
                                              },
                                              labelTextOne: "Gear na Ginamit",
                                              labelTextTwo:
                                                  "Hanapin ang Gear na Ginamit",
                                              icon: Icon(Icons.directions_boat),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  fishingGearController.text =
                                                      value!;
                                                });
                                              }),
                                          TextInputField(
                                            validator: (value) => value.isEmpty
                                                ? 'Walang sagot; Ilagay ang tagal ng pangingisda'
                                                : (numericRegExp.hasMatch(value)
                                                    ? null
                                                    : 'Hindi ito pwede. Siguraduhing mga numero (0 - 9)\nlang ang nilagay mo.'),
                                            controller: fishingEffortController,
                                            labelText:
                                                "Tagal ng Pangingisda (oras)",
                                            keyboardType: TextInputType.number,
                                          ),
                                          TextInputField(
                                            validator: (value) => value.isEmpty
                                                ? 'Walang sagot; Ilagay ang timbang ng nahuli'
                                                : (numericRegExp.hasMatch(value)
                                                    ? null
                                                    : 'Hindi ito pwede. Siguraduhing mga numero (0 - 9)\nlang ang nilagay mo.'),
                                            controller:
                                                totalBoatCatchController,
                                            labelText:
                                                "Kabuuang Timbang ng Nahuli (kg)",
                                            keyboardType: TextInputType.number,
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 30, bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Detalye ng Sample',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w800)),
                                                  Icon(Icons.inbox,
                                                      color: Colors.black)
                                                ],
                                              )),
                                          TextInputField(
                                            validator: (value) {
                                              (value) => value.isEmpty
                                                  ? 'Walang sagot; Ilagay ang SSN'
                                                  : (numericRegExp
                                                          .hasMatch(value)
                                                      ? null
                                                      : 'Hindi ito pwede. Siguraduhing mga numero (0 - 9)\nlang ang nilagay mo.');
                                            },
                                            controller:
                                                sampleSerialNumberController,
                                            labelText:
                                                "Sample Serial Number (SSN)",
                                            keyboardType: TextInputType.number,
                                          ),
                                          TextInputField(
                                            validator: (value) => value.isEmpty
                                                ? 'Walang sagot; Ilagay ang bigat ng sample.'
                                                : (numericRegExp.hasMatch(value)
                                                    ? null
                                                    : 'Hindi ito pwede. Siguraduhing mga numero (0 - 9)\nlang ang nilagay mo.'),
                                            controller:
                                                totalSampleWeightController,
                                            labelText: "Timbang ng Sample (kg)",
                                            keyboardType: TextInputType.number,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(),
                                              AddButton(
                                                  icon: FaIcon(
                                                      FontAwesomeIcons
                                                          .arrowCircleRight,
                                                      color: Colors.white),
                                                  text: 'MAGPATULOY',
                                                  function: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      showPreview(context,
                                                          args.passedDate);
                                                    } else {
                                                      showTopSnackBar(
                                                          context,
                                                          CustomSnackBar.error(
                                                            message:
                                                                "May kulang o mali pa sa iyong tala. I-double check kung may laman na lahat.",
                                                          ));
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ])))))))));
  }
}
