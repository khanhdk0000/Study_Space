import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_space/CommonComponents/components.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/Home/view/side_menu.dart';
import 'package:study_space/constants.dart';
import 'package:study_space/Controller/sessionController.dart';
import 'package:study_space/Model/Session.dart';

class SummaryAllSessionsView extends StatefulWidget {
  const SummaryAllSessionsView({Key key}) : super(key: key);

  @override
  _SummaryAllSessionsViewState createState() => _SummaryAllSessionsViewState();
}

class _SummaryAllSessionsViewState extends State<SummaryAllSessionsView> {
  Future<List<Session>> futureSession;
  int _numView = 5;
  int _sortedBy = 0;
  String _username = 'Gwen';
  int _progress = 75;
  List<String> _numViewValue = ['1', '2', '5', '10', '25', '99'];
  List<String> _sortSelection = ['Score (H)', 'Score (L)', 'Name (A-Z)', 'Name (Z-A)', 'Time (H)', 'Time (L)'];

  @override
  void initState() {
    super.initState();
    futureSession = SessionController().getAllSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Column(
          children: [
            _topView(context),
            SizedBox(height: kDefaultPadding),
            _sortView(context),
            SizedBox(height: kDefaultPadding),
            _listView(context),
          ],
        ),
      ),
    );
  }

  Widget _topView(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
          child: Row(
            children: [
              Column(
                children: [
                  MenuButton(),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {},
                    child: Icon(Icons.refresh, color: Colors.black, size: 24.0),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05
              ),
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/img/portrait.png'),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _username,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(height: kDefaultPadding * 0.2),
                  Text(
                    "$_progress% study goal\ncompleted",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black38),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sortView(BuildContext context){
    return Container(
      color: Colors.black,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _whiteText('Your last study sessions:'),
            SizedBox(height: kDefaultPadding * 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _whiteText('Show'),
                _dropDownNumView(context),
                _whiteText('Sorted by:'),
                _dropDownSort(context),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _listView(BuildContext context){
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: FutureBuilder(future: futureSession, builder: (context, snapshot){
            if (snapshot.hasData){
              var numDisplay = snapshot.data.length > _numView ? _numView : snapshot.data.length;
              List<Widget> widLst = [];
              for(int i = 0; i < numDisplay; i++){
                widLst.add(_scheduleTile(snapshot.data[i].displaySession()));
              }
              return Column(
                children: widLst,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Text('Loading...');
          }),
        ),
      ),
    );
  }

  Widget _whiteText(String text){
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white),
    );
  }

  Widget _dropDownNumView(BuildContext context){
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
          borderRadius: new BorderRadius.all(Radius.circular(6.0))
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 5.0),
        child: DropdownButton(
          value: _numView.toString(),
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
          underline: Container(
            height: 2.0,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              _numView = int.parse(newValue);
            });
          },
          items: _numViewValue.map<DropdownMenuItem<String>>((String value){
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _dropDownSort(BuildContext context){
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
          borderRadius: new BorderRadius.all(Radius.circular(6.0))
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 5.0),
        child: DropdownButton(
          value: _sortSelection[_sortedBy],
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
          underline: Container(
            height: 2.0,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              _sortedBy = _sortSelection.indexOf(newValue);
            });
          },
          items: _sortSelection.map<DropdownMenuItem<String>>((String value){
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _scheduleTile(List<String> oneScheduleList){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        focusColor: Colors.grey,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        ),
        child: Container(
          width: double.infinity,
          height: 90.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 23,
                spreadRadius: -13,
                color: kShadowColor.withOpacity(0.24),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      oneScheduleList[0],
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                      ),
                    ),
                    Text(
                      oneScheduleList[1],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      oneScheduleList[2],
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black54,
                      )
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: _circleColor(int.parse(oneScheduleList[3])),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    oneScheduleList[3],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white,
                    )
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  MaterialAccentColor _circleColor(int score){
    if (score == 100.0){
      return Colors.greenAccent;
    }
    else if (score >= 70.0){
      return Colors.orangeAccent;
    }
    else {
      return Colors.redAccent;
    }
  }

}
