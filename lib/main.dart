import 'package:flutter/material.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


const personnelBox = 'PersonnelBox';
const groupBox = 'GroupBox';

var personnelButtonList = new List<Widget>();
var personnelList = [
  "Jon Doe",
  "Much Longer Name",
  "Jane Doe",
  "lolololol",
  "ha ha ha ha ha"
];

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(personnelBox);
  await Hive.openBox(groupBox);
  runApp(SignUpApp());
}

enum StatusType { none, permEx, tempEx, bothEx, mc }


class Personnel {
  final int id;
  final String name;
  final StatusType status;
  final String permStatusDetails;
  final String tempStatusDetails;
  final String mcDetails;
  final int groupId;

  Personnel(
      {this.id,
      this.name,
      this.status,
      this.permStatusDetails,
      this.tempStatusDetails,
      this.mcDetails,
      this.groupId});
}

class PersonnelGroup {
  final int id;
  final int groupName;

  PersonnelGroup({this.id, this.groupName});
}

class SignUpApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/': (context) => StrengthScreen(),
          '/welcome': (context) => WelcomeScreen(),
        },
        theme: ThemeData(
          buttonTheme: ButtonThemeData(
            minWidth: 150.0,
            height: 75.0,
          ),
        ));
  }
}

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class GroupCard extends StatefulWidget {
  @override
  _GroupState createState() => _GroupState();

  const GroupCard({
    Key key,
    this.showStrength = true,
    @required this.childrenPersonnel,
    this.spacing = 8.0,
    this.runSpacing = 4.0,
    @required this.groupName,
  }) : super(key: key);

  final bool showStrength;
  final List<Widget> childrenPersonnel;
  final double spacing;
  final double runSpacing;
  final String groupName;
}

class _GroupState extends State<GroupCard> {
  bool selectmode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 5.0),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(widget.groupName,
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontSize: 22),
                              textAlign: TextAlign.center))),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: AutoSizeText(
                            "Current Strength:\n7/10",
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 25),
                            textAlign: TextAlign.center,
                          ))),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Material(
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        AutoSizeText("Select Participating:",
                                            style: TextStyle(
                                                fontFamily: 'monospace',
                                                color: Colors.black,
                                                decoration: TextDecoration.none,
                                                fontSize: 18),
                                            textAlign: TextAlign.center),
                                        Switch(
                                          value: selectmode,
                                          onChanged: (value) {
                                            setState(() {
                                              selectmode = value;
                                              print(selectmode);
                                            });
                                          },
                                          activeColor: Colors.green,
                                          activeTrackColor: Colors.greenAccent,
                                        ),
                                      ]),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(flex:4,child:OutlineButton(child: Text("Select None"),
                                          onPressed: (() {
                                            print(1 + 1);
                                          }),
                                          borderSide: BorderSide(color: Colors.green,width:9.0),)),
                                        Spacer(flex:1),
                                        Expanded(flex:4,child: OutlineButton(child: Text("Select All but MC"),
                                          onPressed: (() {
                                            print(1 + 1);
                                          }),
                                          borderSide: BorderSide(color: Colors.green,width:9.0),
                                        )),
                                       /* OutlineButton(
                                          child: Text("Select All but Status/MC"),
                                          onPressed: (() {
                                            print(1 + 1);
                                          }),
                                          borderSide: BorderSide(color: Colors.green),
                                        ),*/
                                        Spacer(flex:1),
                                        Expanded(flex:4,child:OutlineButton(

                                          child: Text("Select All"),
                                          onPressed: (() {
                                            print(1 + 1);
                                          }),
                                          borderSide: BorderSide(color: Colors.green,width:9.0),
                                        )),
                                      ]),
                                ],
                              ))))
                ],
              ),
              Padding(padding: EdgeInsets.only(top:15.0),child:Wrap(
                children: widget.childrenPersonnel,
                spacing: widget.spacing,
                runSpacing: widget.runSpacing,
              )),
            ])));
  }
}

class PersonnelCard extends StatefulWidget {
  @override
  _PersonnelState createState() => _PersonnelState();

  const PersonnelCard({
    Key key,
    this.status = StatusType.none,
    this.name = "noname",
    this.tempStatusDetails,
    this.permStatusDetails,
    this.mcDetails,
    @required this.groupId,
    @required this.participating,
  }) : super(key: key);

  final StatusType status;
  final String name;
  final String permStatusDetails;
  final String tempStatusDetails;
  final String mcDetails;
  final int groupId;
  final bool participating;
}

class _PersonnelState extends State<PersonnelCard> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: (() {
          switch (widget.status) {
            case StatusType.mc:
              return Colors.red;
              break;
            case StatusType.tempEx:
              return Colors.orange;
              break;
            case StatusType.none:
              return Colors.green;
              break;

            default:
              return Colors.amber; // amber border for perm and both
          }
        }()),
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            pressed = !pressed;
          });
        },
        child: AnimatedContainer(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            width: 150.0,
            height: pressed ? 150.0 : 75.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child: Container(
                padding: pressed
                    ? EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0)
                    : null,
                width: double.infinity,
                color: (() {
                  switch (widget.status) {
                    case StatusType.mc:
                      return Colors.red;
                      break;
                    case StatusType.tempEx:
                      return Colors.orange;
                      break;
                    case StatusType.bothEx:
                      return Colors.orange;
                      break;

                    default:
                      return Colors.green; // green for none and perm
                  }
                }()),
                child: pressed
                    ? Wrap(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: (() {
                          List<Widget> initclist = [
                            Container(
                                padding: EdgeInsets.only(bottom: 3.0),
                                child: AutoSizeText(
                                  widget.name,
                                  style: TextStyle(fontSize: 14.0),
                                )),
                          ];
                          if (widget.status == StatusType.tempEx ||
                              widget.status == StatusType.bothEx) {
                            initclist.add(AutoSizeText("Temp Ex Details:",
                                style: TextStyle(fontSize: 12.0)));
                            initclist.add(AutoSizeText(
                                widget.tempStatusDetails ?? "None Given",
                                style: TextStyle(fontSize: 8.0)));
                          }
                          if (widget.status == StatusType.permEx ||
                              widget.status == StatusType.bothEx) {
                            initclist.add(AutoSizeText("Perm Ex Details:",
                                style: TextStyle(fontSize: 12.0)));
                            initclist.add(AutoSizeText(
                                widget.permStatusDetails ?? "None Given",
                                style: TextStyle(fontSize: 8.0)));
                          }
                          if (widget.status == StatusType.mc) {
                            initclist.add(AutoSizeText("MC Details:",
                                style: TextStyle(fontSize: 12.0)));
                            initclist.add(AutoSizeText(
                                widget.mcDetails ?? "None Given",
                                style: TextStyle(fontSize: 8.0)));
                          }
                          return initclist;
                        }()),
                        direction: Axis.vertical,
                        clipBehavior: Clip.antiAlias,
                      )
                    : Center(
                        child: AutoSizeText(
                        widget.name,
                        style: TextStyle(fontSize: 26.0),
                        textAlign: TextAlign.center,
                      )))));
  }
}

class StrengthScreen extends StatefulWidget {
  @override
  _StrengthState createState() => _StrengthState();
}

class _StrengthState extends State<StrengthScreen> {
  var strengthStateButtons = new List<Widget>();

  void populatePersonnel() {
    for (var val in personnelList) {
      personnelButtonList.add(new PersonnelCard(
        name: val,
        groupId: 0,
        status: StatusType.values[new Random().nextInt(5)],
        permStatusDetails: "RMJ + Heavy Load",
        mcDetails: "chaokeng prolly",
        tempStatusDetails: "LD, ends 290920\n",
      ));
    }
    setState(() {
      strengthStateButtons = personnelButtonList;
      print(strengthStateButtons);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("DARI KANAN BILANG",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black)),
          Text(
            "wgt count strength?",
            style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.none,
                fontSize: 30),
          ),
          FlatButton(
              onPressed: populatePersonnel,
              child: Text("POPULATE BUTTON (testing only)!")),
          GroupCard(
            spacing: 8.0,
            runSpacing: 4.0,
            childrenPersonnel: strengthStateButtons,
            groupName: "Cat Company Platoon 420",
          )
        ],
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  double _formProgress = 0;

  void _showWelcomeScreen() {
    Navigator.of(this.context).pushNamed('/welcome');
  }

  void _updateFormProgress() {
    var progress = 0.0;
    var controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _usernameTextController
    ];

    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          Text('Sign up', style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: InputDecoration(hintText: 'First name'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: InputDecoration(hintText: 'Last name'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: InputDecoration(hintText: 'Username'),
            ),
          ),
          FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: _formProgress == 1 ? _showWelcomeScreen : null,
            child: Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome!', style: Theme.of(context).textTheme.headline2),
      ),
    );
  }
}
