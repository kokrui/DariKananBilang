import 'package:flutter/material.dart';
import 'dart:math';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:auto_size_text/auto_size_text.dart';



var personnelButtonList = new List<Widget>();
var personnelList = ["Kok Rui","Sujith Harirajan","PTE Ian","ayyylmao","okalrightok"];

void main() => runApp(SignUpApp());

enum StatusType {

  none,
  permEx,
  tempEx,
  bothEx,
  mc
}

class Personnel {

  final int id;
  final String name;
  final StatusType status;
  final String permStatusDetails;
  final String tempStatusDetails;
  final String mcDetails;
  final int groupId;

  Personnel({this.id,this.name,this.status,this.permStatusDetails,this.tempStatusDetails,this.mcDetails,this.groupId});
}

class PersonnelGroup {
  final int id;
  final int groupName;

  PersonnelGroup({this.id,this.groupName});
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

      )
    );
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

/*class GroupCard extends StatefulWidget{
  @override
  _GroupState createState() => _GroupState();

  const GroupCard(
      Key key,
      this.
      ) : super(key:key);

  final bool showTot;
  final bool showCur;
}

class _GroupState extends State<GroupCard>{

}*/

class PersonnelCard extends StatefulWidget{
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


}) : super(key:key);

  final StatusType status;
  final String name;
  final String permStatusDetails;
  final String tempStatusDetails;
  final String mcDetails;
  final int groupId;

}

class _PersonnelState extends State<PersonnelCard>{
  bool pressed=false;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: ((){
        switch(widget.status){
          case StatusType.mc:return Colors.red;break;
          case StatusType.tempEx: return Colors.orange;break;
          case StatusType.none: return Colors.green;break;

          default: return Colors.amber; // amber border for perm and both
        }
      }()),
      padding: EdgeInsets.zero,
      onPressed: (){
        setState((){
          pressed = !pressed;
        });
      },
      child: AnimatedContainer(
        padding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
        width: 150.0,
        height: pressed ? 150.0:75.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: Container(
          padding: pressed ? EdgeInsets.symmetric(vertical: 3.0,horizontal: 3.0):null,
          width: double.infinity,
          color: ((){
            switch(widget.status){
              case StatusType.mc:return Colors.red;break;
              case StatusType.tempEx: return Colors.orange;break;
              case StatusType.bothEx: return Colors.orange;break;

              default: return Colors.green; // green for none and perm
            }
          }()),
          child: pressed ?
          Wrap(
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: ((){
              List<Widget> initclist = [
                Container(padding:EdgeInsets.only(bottom: 3.0),child: AutoSizeText(widget.name,style: TextStyle(fontSize: 14.0),)),
              ];
              if (widget.status == StatusType.tempEx || widget.status == StatusType.bothEx){
                initclist.add(AutoSizeText("Temp Ex Details:",style: TextStyle(fontSize: 12.0)));
                initclist.add(AutoSizeText(widget.tempStatusDetails ?? "None Given",style: TextStyle(fontSize: 8.0)));
              }
              if (widget.status == StatusType.permEx || widget.status == StatusType.bothEx){
                initclist.add(AutoSizeText("Perm Ex Details:",style: TextStyle(fontSize: 12.0)));
                initclist.add(AutoSizeText(widget.permStatusDetails ?? "None Given",style: TextStyle(fontSize: 8.0)));
              }
              if (widget.status == StatusType.mc){
                initclist.add(AutoSizeText("MC Details:",style: TextStyle(fontSize: 12.0)));
                initclist.add(AutoSizeText(widget.mcDetails ?? "None Given",style: TextStyle(fontSize: 8.0)));
              }
              return initclist;
            }()),direction: Axis.vertical,clipBehavior: Clip.antiAlias,
            ):
          Center(child:AutoSizeText(widget.name,style: TextStyle(fontSize: 26.0),textAlign: TextAlign.center,))
        )
      )
    );
  }
}

class StrengthScreen extends StatefulWidget{
  @override
  _StrengthState createState() => _StrengthState();
}

class _StrengthState extends State<StrengthScreen>  {

  var strengthStateButtons = new List<Widget>();

  void populatePersonnel(){
    for (var val in personnelList) {
      personnelButtonList.add(new PersonnelCard(
        name:val,
        groupId: 0,
        status: StatusType.values[new Random().nextInt(5)],
      ));
    }
    setState((){
      strengthStateButtons=personnelButtonList;
      print(strengthStateButtons);
    });
  }

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
      children: [
        Text("DARI KANAN BILANG"),
        FlatButton(
          onPressed:populatePersonnel,
          child:Text("POPULATE (testing only)!")
        ),
        Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: strengthStateButtons,
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
          Text('Sign up', style: Theme
              .of(context)
              .textTheme
              .headline4),
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
