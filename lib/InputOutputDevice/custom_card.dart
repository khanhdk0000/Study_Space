import '../devicesize.dart';
import 'package:flutter/material.dart';
import 'package:sliding_card/sliding_card.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    Key key,
    this.slidingCardController,
    @required this.onTapped,
    @required this.device,
    @required this.state,
    @required this.message,
    @required this.connect,
    @required this.disconnect,
    @required this.imgPath,
  }) : super(key: key);

  final SlidingCardController slidingCardController;
  final Function onTapped;
  final String device;
  final String state;
  final String message;
  final Function connect;
  final Function disconnect;
  final String imgPath;

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return SlidingCard(
      slidingAnimmationForwardCurve: Curves.easeIn,
      slimeCardElevation: 0.5,
      slidingAnimationReverseCurve: Curves.easeOut,
      cardsGap: DeviceSize.safeBlockVertical,
      controller: widget.slidingCardController,
      slidingCardWidth: DeviceSize.horizontalBloc * 90,
      visibleCardHeight: DeviceSize.safeBlockVertical * 30,
      hiddenCardHeight: DeviceSize.safeBlockVertical * 15,
      frontCardWidget: CustomFrontCard(
        state: widget.state,
        device: widget.device,
        message: widget.message,
        connect: widget.connect,
        disconnect: widget.disconnect,
        imgPath: widget.imgPath,
        onInfoTapped: () {
          print('info pressed');
          widget.slidingCardController.expandCard();
        },
        onCloseButtonTapped: () {
          widget.slidingCardController.collapseCard();
        },
      ),
      backCardWidget:
          CustomBackCard(onPhoneTapped: () {}, companyInfo: widget.message),
    );
  }
}

class CustomFrontCard extends StatefulWidget {
  final String device;
  final String state;
  final String message;
  final Function connect;
  final Function disconnect;
  final Function onInfoTapped;
  final Function onCloseButtonTapped;
  final String imgPath;

  const CustomFrontCard({
    Key key,
    @required this.state,
    @required this.device,
    @required this.onInfoTapped,
    @required this.onCloseButtonTapped,
    @required this.message,
    @required this.connect,
    @required this.disconnect,
    @required this.imgPath,
  }) : super(key: key);
  @override
  _CustomFrontCardState createState() => _CustomFrontCardState();
}

class _CustomFrontCardState extends State<CustomFrontCard> {
  bool isInfoPressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xFF3e9ee7),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.only(top: 0, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.devices_other_rounded,
                          size: DeviceSize.safeBlockHorizontal * 5,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.device,
                          style: TextStyle(
                              fontSize: DeviceSize.safeBlockHorizontal * 4.7,
                              color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: DeviceSize.safeBlockHorizontal * 90,
                      //color: Colors.pink,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: DeviceSize.safeBlockHorizontal * 15,
                              height: DeviceSize.safeBlockVertical * 8,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(widget.imgPath)),
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 9,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Current State',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize:
                                          DeviceSize.safeBlockHorizontal * 4.7,
                                      color: Colors.black87),
                                ),
                                Text(
                                  widget.state,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize:
                                          DeviceSize.safeBlockHorizontal * 4.7,
                                      color: Colors.black87),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                if (isInfoPressed == true) {
                                  isInfoPressed = false;
                                  widget.onCloseButtonTapped();
                                  setState(() {});
                                } else {
                                  isInfoPressed = true;
                                  widget.onInfoTapped();
                                  setState(() {});
                                }
                              },
                              child: Container(
                                //color: Colors.red,
                                child: isInfoPressed
                                    ? Transform.rotate(
                                        angle: 0.7777,
                                        child: Icon(
                                          Icons.add_circle,
                                          size: DeviceSize.safeBlockHorizontal *
                                              9,
                                          color: Colors.blue,
                                        ),
                                      )
                                    : Icon(
                                        Icons.info,
                                        size:
                                            DeviceSize.safeBlockHorizontal * 9,
                                        color: Color(0xFF031D44),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        width: DeviceSize.safeBlockHorizontal * 90,
                        //color: Colors.indigo,
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: DeviceSize.safeBlockVertical * 6,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: widget.state ==
                                            'Disconnected'
                                        ? Colors.greenAccent
                                        : Colors.greenAccent.withOpacity(0.35),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  child: Text(
                                    'Connect',
                                    style: TextStyle(
                                        fontSize:
                                            DeviceSize.safeBlockHorizontal *
                                                5.5,
                                        color: Colors.black87),
                                  ),
                                  onPressed: () {
                                    if (widget.state == 'Disconnected') {
                                      // TODO
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: DeviceSize.safeBlockVertical * 6,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: widget.state == 'Connected'
                                        ? Colors.redAccent
                                        : Colors.redAccent.withOpacity(0.35),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  child: Text(
                                    'Disconnect',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          DeviceSize.safeBlockHorizontal * 5,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (widget.state == 'Connected') {
                                      // TODO
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CustomBackCard extends StatelessWidget {
  final String companyInfo;
  final Function onPhoneTapped;
  const CustomBackCard({
    Key key,
    @required this.companyInfo,
    @required this.onPhoneTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: DeviceSize.horizontalBloc * 90,
          height: DeviceSize.safeBlockVertical * 15,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Text(
                      'Message :',
                      style: TextStyle(
                        fontSize: DeviceSize.safeBlockHorizontal * 4,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      width: DeviceSize.safeBlockHorizontal * 80,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: SingleChildScrollView(
                                child: Text(
                                  companyInfo,
                                  style: TextStyle(
                                      fontSize:
                                          DeviceSize.safeBlockHorizontal * 4,
                                      color: Colors.black),
                                  // overflow: TextOverflow.ellipsis,
                                  // maxLines: 4,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: onPhoneTapped,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue[300],
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Icon(
                                      Icons.info_outline_rounded,
                                      size: DeviceSize.safeBlockHorizontal * 9,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
