import 'dart:convert';
import 'package:creative_mobile/config.dart';
import 'package:creative_mobile/models/list_spk.dart';
import 'package:creative_mobile/services/shared_service.dart';
import 'package:creative_mobile/services/spkdb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final List<String> faulty = [
  'General',
  'Engine',
  'Electric',
  'Transmission',
  'Brake',
  'Steering',
  'Frame & Suspension',
  'Cabin',
  'Hydraulic',
  'Normal Condition'
];

final List<String> serviceStatusList = [
  'Waiting For Part',
  'Finished',
  'Open',
];

final List<String> afterService = [
  'Breakdown',
  'Idle',
  'Running',
];

String? faultyValue;
String? serviceStatusValue;
String? statusAfterServiceValue;
bool isChecked = false;

final _formKey = GlobalKey<FormState>();

class ServiceReportPage extends StatefulWidget {
  const ServiceReportPage({super.key});
  @override
  State<ServiceReportPage> createState() => _ServiceReportPageState();
}

class _ServiceReportPageState extends State<ServiceReportPage> {
  //harus ditambahkan disetiap inputan
  TextEditingController spkNumberController = TextEditingController();
  TextEditingController serviceCategoryController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController unitSiteController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController unitSnController = TextEditingController();
  TextEditingController unitBrandController = TextEditingController();
  TextEditingController unitModelController = TextEditingController();
  TextEditingController unitHmController = TextEditingController();
  TextEditingController unitKmController = TextEditingController();
  TextEditingController complaintsController = TextEditingController();
  TextEditingController faultyGroupController = TextEditingController();
  TextEditingController reportCreatorController = TextEditingController();
  TextEditingController unitStatusAfterController = TextEditingController();
  TextEditingController unitStatusBeforeController = TextEditingController();
  TextEditingController needSparepartsController = TextEditingController();
  TextEditingController serviceStatusController = TextEditingController();

  HtmlEditorController analysisController = HtmlEditorController();
  HtmlEditorController serviceNoteController = HtmlEditorController();
  HtmlEditorController actionController = HtmlEditorController();

  SpkDBServices svc = SpkDBServices();

  String faultydropdownValue = faulty.first;
  String serviceStatusdropdownValue = serviceStatusList.first;
  String statusAfterdropdownValue = afterService.first;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  tabs: [
                    Tab(icon: Icon(Icons.maps_home_work_rounded)),
                    Tab(icon: Icon(Icons.supervised_user_circle)),
                    Tab(icon: Icon(Icons.design_services)),
                    Tab(icon: Icon(Icons.analytics_outlined)),
                  ]),
              title: Text("Service Report"),
              elevation: 0,
              actions: [
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                    //pushName berguna untuk memanggil nama route yang telah kita buat di main dart
                  },
                  label: Text('Back'),
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (() {
                    SharedService.logout(context);
                  }),
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: Container(
              child: Form(
                child: TabBarView(children: [
                  ServiceFormTab1(context),
                  ServiceFormTab2(context),
                  ServiceFormTab3(context),
                  ServiceFormTab4(context),
                ]),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget ServiceFormTab1(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: spkNumberController,
              onTap: () {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return FutureBuilder<ListSpk>(
                        future: svc.getSpk(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Failed load API Data with error : ' +
                                        snapshot.error.toString()));
                          } else {
                            var listSPK = snapshot.data!.results;
                            return Material(
                              color: Colors.grey[200],
                              child: ListView.builder(
                                  padding: EdgeInsets.only(bottom: 24),
                                  itemCount: listSPK.length,
                                  itemBuilder: (context, index) {
                                    var spk = listSPK[index];
                                    var id = spk.spk_id;
                                    return InkWell(
                                      onTap: () {
                                        spkNumberController.text =
                                            spk.spk_number;
                                        serviceCategoryController.text =
                                            spk.service_category;
                                        customerNameController.text =
                                            spk.customer_name;
                                        unitSiteController.text = spk.unit_site;
                                        provinceController.text =
                                            spk.assignment_province;
                                        unitSnController.text = spk.unit_sn;
                                        unitBrandController.text =
                                            spk.unit_brand;
                                        unitModelController.text =
                                            spk.unit_model;
                                        unitStatusBeforeController.text =
                                            spk.unit_status_before_service;
                                        Navigator.of(context).pop();
                                      },
                                      child: ListView(
                                        physics: BouncingScrollPhysics(),
                                        padding: const EdgeInsets.all(3),
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: ListTile(
                                              leading: Icon(Icons.circle),
                                              title: Text(spk.spk_number),
                                              subtitle: Text(spk.customer_name +
                                                  '\t-\t' +
                                                  spk.unit_sn),
                                              textColor: Colors.white,
                                              tileColor: Colors.blue[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          }
                        },
                      );
                    }));
              },
              decoration: new InputDecoration(
                hintText: "Spk Number",
                labelText: "SPK",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                suffixIcon: GestureDetector(
                  child: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(
                      Icons.search,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: serviceCategoryController,
              decoration: new InputDecoration(
                hintText: "Service Category",
                labelText: "Category",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Working Start Date",
                labelText: "Start Date",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
              controller: startDateController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2050));
                if (pickedDate != null) {
                  startDateController.text =
                      DateFormat('dd MMMM yyyy').format(pickedDate);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ServiceFormTab2(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: customerNameController,
              decoration: new InputDecoration(
                hintText: "Customer",
                labelText: "Customer",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: unitSiteController,
              decoration: new InputDecoration(
                hintText: "Unit Site",
                labelText: "Site",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: provinceController,
              decoration: new InputDecoration(
                hintText: "Province",
                labelText: "Province",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: unitSnController,
              decoration: new InputDecoration(
                hintText: "Unit SN",
                labelText: "SN",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: unitBrandController,
              decoration: new InputDecoration(
                hintText: "Unit Brand",
                labelText: "Brand",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: unitModelController,
              decoration: new InputDecoration(
                hintText: "Unit Model",
                labelText: "Model",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: unitHmController,
              decoration: new InputDecoration(
                hintText: "Unit HM",
                labelText: "HM",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: unitKmController,
              decoration: new InputDecoration(
                hintText: "Unit KM",
                labelText: "KM",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: unitStatusBeforeController,
              decoration: new InputDecoration(
                hintText: "Unit Status Before Service",
                labelText: "Status Before",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 15, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: complaintsController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: new InputDecoration(
                hintText: "Complaints",
                labelText: "Complaints",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ServiceFormTab3(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: DropdownButtonFormField2(
              searchController: faultyGroupController,
              // value: faultydropdownValue,
              decoration: InputDecoration(
                //Add isDense true and zero Padding.
                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                //Add more decoration as you want here
                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
              ),
              isExpanded: false,
              hint: const Text(
                'Faulty Group',
                style: TextStyle(fontSize: 16),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 30,
              buttonHeight: 60,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              items: faulty
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Choose Faulty Group.';
                }
              },
              value: faultyValue,
              onChanged: (value) {
                setState(() {
                  faultyValue = value as String;
                });
              },
              onSaved: (value) {
                faultyValue = value.toString();
              },
              // value: dropdownValue,
              // icon: const Icon(Icons.arrow_downward),
              // style: const TextStyle(color: Colors.deepPurple),
              // onChanged: (String? value) {
              //   // This is called when the user selects an item.
              //   setState(() {
              //     dropdownValue = value!;
              //   });
              // },
              // items: faulty.map<DropdownMenuItem<String>>((String value) {
              //   return DropdownMenuItem<String>(
              //     value: value,
              //     child: Text(value),
              //   );
              // }).toList(),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: DropdownButtonFormField2(
              searchController: serviceStatusController,
              // value: serviceStatusdropdownValue,
              decoration: InputDecoration(
                //Add isDense true and zero Padding.
                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                //Add more decoration as you want here
                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
              ),
              isExpanded: false,
              hint: const Text(
                'Service Status',
                style: TextStyle(fontSize: 16),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 30,
              buttonHeight: 60,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              items: serviceStatusList
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Choose Service Status';
                }
              },
              value: serviceStatusValue,
              onChanged: (value) {
                setState(() {
                  serviceStatusValue = value as String;
                });
              },
              onSaved: (value) {
                serviceStatusValue = value.toString();
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "End Date",
                labelText: "Working End Date",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
              controller: endDateController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2050));
                if (pickedDate != null) {
                  endDateController.text =
                      DateFormat('dd MMMM yyyy').format(pickedDate);
                }
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              controller: reportCreatorController,
              decoration: new InputDecoration(
                hintText: "Creator",
                labelText: "Report Creator",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: DropdownButtonFormField2(
              searchController: unitStatusAfterController,
              // value: statusAfterdropdownValue,
              decoration: InputDecoration(
                //Add isDense true and zero Padding.
                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                //Add more decoration as you want here
                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
              ),
              isExpanded: false,
              hint: const Text(
                'Unit Status After Service',
                style: TextStyle(fontSize: 16),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 30,
              buttonHeight: 60,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              items: afterService
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Choose Status After Service';
                }
              },
              value: statusAfterServiceValue,
              onChanged: (value) {
                setState(() {
                  statusAfterServiceValue = value as String;
                });
              },
              onSaved: (value) {
                statusAfterServiceValue = value.toString();
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 10),
            child: CheckboxListTile(
              title: Text("Need Spareparts Recommendation?"),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
          ),
        ],
      ),
    );
  }

  Widget ServiceFormTab4(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 5, top: 10, right: 15, left: 15),
              child: HtmlEditor(
                controller: analysisController,
                htmlEditorOptions: HtmlEditorOptions(
                  hint: "Analysis",
                ),
                htmlToolbarOptions: HtmlToolbarOptions(defaultToolbarButtons: [
                  FontButtons(),
                  ListButtons(),
                  FontSettingButtons(),
                  ParagraphButtons(),
                ]),
                otherOptions: OtherOptions(
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 5, top: 10, right: 15, left: 15),
              child: HtmlEditor(
                controller: actionController, //required
                htmlEditorOptions: HtmlEditorOptions(
                  hint: "Action",
                ),
                htmlToolbarOptions: HtmlToolbarOptions(defaultToolbarButtons: [
                  FontButtons(),
                  ListButtons(),
                  FontSettingButtons(),
                  ParagraphButtons(),
                ]),
                otherOptions: OtherOptions(
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 5, top: 10, right: 15, left: 15),
              child: HtmlEditor(
                controller: serviceNoteController, //required
                htmlEditorOptions: HtmlEditorOptions(
                  hint: "Service Note",
                ),
                htmlToolbarOptions: HtmlToolbarOptions(defaultToolbarButtons: [
                  FontButtons(),
                  ListButtons(),
                  FontSettingButtons(),
                  ParagraphButtons(),
                ]),
                otherOptions: OtherOptions(
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 5, top: 10, right: 15, left: 15),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Submit"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue[800],
                    textStyle: const TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ]),
    );
  }
}
