import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../backend/sqlfite_local_primary_db.dart';
import '../forms/output/stored_form.dart';

class ActivitiesList extends StatefulWidget {
  final refreshList;
  ActivitiesList({this.refreshList});
  @override
  State<ActivitiesList> createState() => _ActivitiesListState();
}

class _ActivitiesListState extends State<ActivitiesList> {
  late StreamSubscription subscription;
  late StreamSubscription internetSubscription;
  bool hasInternet = false;
  ConnectivityResult result = ConnectivityResult.none;
  String dateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(5, 5, 5, 20),
        height: 410,
        child: Card(
            elevation: 20,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white, width: 5)),
            child: Container(
                width: double.infinity,
                child: Column(children: [
                  Container(
                      color: Colors.purple,
                      height: 70,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Mga Naitala Ngayon",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.w800,
                                              fontSize: 25))
                                    ]),
                                FaIcon(FontAwesomeIcons.fish,
                                    color: Color.fromARGB(255, 255, 255, 255))
                              ]))),
                  Container(
                      height: 5,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [])),
                  Container(
                      height: 325,
                      decoration: BoxDecoration(
                        boxShadow: [
                          const BoxShadow(
                            color: Color.fromARGB(129, 0, 0, 0),
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            spreadRadius: -5.0,
                            blurRadius: 8.0,
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                      ),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: RawScrollbar(
                        thumbColor: Colors.green,
                        radius: Radius.circular(10),
                        thickness: 15,
                        child: RefreshIndicator(
                            onRefresh: () {
                              return Future.delayed(Duration(seconds: 1), () {
                                setState(() {});
                                widget.refreshList;
                              });
                            },
                            child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                child: FutureBuilder<List<enumeratorLocal>>(
                                    future: DatabaseHelperOne.instance
                                        .getEnumeratorLocalDate(dateTime),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<enumeratorLocal>>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                            child: Text('Loading...'));
                                      }
                                      return snapshot.data!.isEmpty
                                          ? Container(
                                              height: 325,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text('MAGTALA NG AKTIBIDAD',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.purple,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 25)),
                                                  Text(''),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .do_not_disturb_alt,
                                                                size: 40,
                                                                color:
                                                                    Colors.red),
                                                            SizedBox(
                                                                height: 40),
                                                            Icon(Icons.refresh,
                                                                size: 40,
                                                                color: Colors
                                                                    .blue),
                                                            SizedBox(
                                                                height: 10),
                                                          ]),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                'Wala ka pang itinatala para\nsa araw na ito. Pindutin ang\nkulay berdeng butones sa\nilalim para magsimula.',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .purple,
                                                                    fontSize:
                                                                        15)),
                                                            Text(
                                                                '\nKung may natala ka na pero di pa\nlumalabas, mangyaring i-refresh\nang pahina sa pamamagitan ng\npaghila nito pababa.',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .purple,
                                                                    fontSize:
                                                                        15)),
                                                          ]),
                                                    ],
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: []),
                                                ],
                                              ),
                                            )
                                          : ListView(
                                              reverse: true,
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              children: snapshot.data!
                                                  .map((enumeratorLocal) {
                                                return Center(
                                                    child: Container(
                                                  height: 100,
                                                  child: Card(
                                                      elevation: 5,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              15, 0, 15, 10),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) => storedForm(
                                                                  context:
                                                                      context,
                                                                  uuid: enumeratorLocal
                                                                      .uuid,
                                                                  speciesName:
                                                                      enumeratorLocal
                                                                          .speciesName,
                                                                  commonName:
                                                                      enumeratorLocal
                                                                          .commonName,
                                                                  speciesPic:
                                                                      enumeratorLocal
                                                                          .image,
                                                                  enumerator:
                                                                      enumeratorLocal
                                                                          .enumerator,
                                                                  date: enumeratorLocal
                                                                      .date,
                                                                  fishingGround:
                                                                      enumeratorLocal
                                                                          .fishingGround,
                                                                  landingCenter:
                                                                      enumeratorLocal
                                                                          .landingCenter,
                                                                  totalLandings:
                                                                      enumeratorLocal
                                                                          .totalLandings,
                                                                  boatName: enumeratorLocal
                                                                      .boatName,
                                                                  fishingGear:
                                                                      enumeratorLocal
                                                                          .fishingGear,
                                                                  fishingEffort:
                                                                      enumeratorLocal
                                                                          .fishingEffort,
                                                                  totalBoatCatch:
                                                                      enumeratorLocal
                                                                          .totalBoatCatch,
                                                                  sampleSerialNumber:
                                                                      enumeratorLocal
                                                                          .sampleSerialNumber,
                                                                  sampleWeight:
                                                                      enumeratorLocal
                                                                          .totalSampleWeight,
                                                                  weight:
                                                                      enumeratorLocal
                                                                          .weight,
                                                                  length: enumeratorLocal
                                                                      .length));
                                                        },
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    5,
                                                                    10,
                                                                    10),
                                                            child: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  60,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 10,
                                                                    child: Wrap(
                                                                      children: [
                                                                        Text(
                                                                          '${enumeratorLocal.commonName}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            fontSize:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text("Haba: ${enumeratorLocal.length} cm | Bigat: ${enumeratorLocal.weight} g"),
                                                                            Text('${enumeratorLocal.landingCenter}')
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                      flex: 3,
                                                                      child: Image.asset(
                                                                          '${enumeratorLocal.image}',
                                                                          width:
                                                                              80))
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ));
                                              }).toList(),
                                            );
                                    }))),
                      ))
                ]))));
  }
}
