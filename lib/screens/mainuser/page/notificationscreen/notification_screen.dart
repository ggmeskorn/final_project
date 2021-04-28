import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:final_project/model/chat_item.dart';
import 'package:final_project/model/com_ments.dart';
import 'package:final_project/model/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../my_constant.dart';
import 'components/conversation.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  List<CommentsModel> commentsModels = List();

  bool status = true;
  bool loadstatus = true;

  Future updateNotification(String id) async {
    var url = "${MyConstant().domain}/homestay/updateNofitication.php";
    var res = await http.post(url, body: {"id": id});
    if (res.statusCode == 200) {
      print('od');
    }
  }

  List chatdata = List();

  Future showAllchat() async {
    var url = '${MyConstant().domain}/homestay/getchat.php';
    var response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        chatdata = jsonData;
      });
      print(jsonData);
    }
  }

  @override
  void initState() {
    super.initState();
    // totalComments();
    getTotalUnSeenNotification();
    // getunseenNotification();
    //
    readComments();
    showAllchat();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showContent() {
    return status
        ? showListComments()
        : Center(
            child: Text('ยังไม่มีข้อมูล'),
          );
  }

  // Future<Null> totalComments() async {
  //   if (commentsModels.length != 0) {
  //     commentsModels.clear();
  //   }
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String username = preferences.getString('username');
  //   print('username = $username');
  //   var url =
  //       '${MyConstant().domain}/homestay/selectCommentsNotification.php?isAdd=true&author_post=$username';
  //   // String url =
  //   //     '${MyConstant().domain}/homestay/testing.php?isAdd=true&author_post=$username';
  //   await Dio().get(url).then((value) {
  //     setState(() {
  //       loadstatus = false;
  //     });
  //     if (value.toString() != 'null') {
  //       print('value ==>> $value');
  //       var result = json.decode(value.data);
  //       print('result => $result');
  //       for (var map in result) {
  //         CommentsModel commentsModel = CommentsModel.fromJson(map);
  //         setState(() {
  //           commentsModels.add(commentsModel);
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         status = false;
  //       });
  //     }
  //   });
  // }
  bool editMode = false;
  var total;
  Future getTotalUnSeenNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String username = preferences.getString('username');
    var url =
        '${MyConstant().domain}/homestay/selectCommentsNotification.php?author_post=$username';
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      setState(() {
        total = jsonData;
      });
    }
    print(total);
  }

  Future<Null> readComments() async {
    if (commentsModels.length != 0) {
      commentsModels.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String username = preferences.getString('username');
    print('username = $username');

    String url =
        '${MyConstant().domain}/homestay/testing.php?isAdd=true&author_post=$username';
    await Dio().get(url).then((value) {
      setState(() {
        loadstatus = false;
      });
      if (value.toString() != 'null') {
        print('value ==>> $value');
        var result = json.decode(value.data);
        print('result => $result');
        for (var map in result) {
          CommentsModel commentsModel = CommentsModel.fromJson(map);
          setState(() {
            commentsModels.add(commentsModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  // List allUnSeenNotification = List();
  // Future getunseenNotification() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String username = preferences.getString('username');
  //   var url =
  //       '${MyConstant().domain}/homestay/testing.php?isAdd=true&author_post=$username';
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       allUnSeenNotification = response.body;
  //     });
  //   }

  //   print(allUnSeenNotification);
  // }

  @override
  Widget build(BuildContext context) {
    bool isSeen = true;

    super.build(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: TextField(
      //     decoration: InputDecoration.collapsed(
      //       hintText: 'ค้นหา',
      //     ),
      //   ),
      appBar: AppBar(
        title: Text('การแจ้งเตือน', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // showSearch(
              //     context: context, delegate: SearchPost(list: searchList));
            },
          ),
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Theme.of(context).textTheme.caption.color,
          isScrollable: false,
          tabs: <Widget>[
            Tab(
              text: "แชต",
            ),
            isSeen
                ? Badge(
                    badgeContent: Text(
                      '$total',
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Tab(
                      text: "แจ้งเตือน",
                    ),
                  )
                : Badge(
                    badgeContent: Text(
                      '0',
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Tab(
                      text: "แจ้งเตือน",
                    ),
                  ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ListView.separated(
            padding: EdgeInsets.all(10),
            separatorBuilder: (BuildContext context, int index) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 0.5,
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Divider(),
                ),
              );
            },
            itemCount: chatdata.length,
            itemBuilder: (BuildContext context, int index) {
              Map chat = chatdata[index];
              return Container();
              // return ChatItems(
              //   // // pathimagepets:
              //   //     '${MyConstant().domain}/homestay/Pets/${chat['pathimage']}',
              //   namepets: chat['namepets'],
              //   userimage:
              //       '${MyConstant().domain}/homestay/Users/${chat['pathImage']}',

              //   msg: chat['msg'],

              //   // dp: chat['dp'],
              //   // name: chat['name'],
              //   // isOnline: chat['isOnline'],
              //   // counter: chat['counter'],
              //   // msg: chat['msg'],
              //   // time: chat['time'],
              // );
            },
          ),

          // loadstatus ? showProgress() : showContent(),
          // ListView.builder(
          //     itemCount: allUnSeenNotification.length,
          //     itemBuilder: (context, index) {
          //       var list = allUnSeenNotification[index];
          //       return ListTile(
          //         title: Text(list['comments']),
          //       );
          //     })
          Stack(
            children: [
              // showListComments()
              loadstatus ? showProgress() : showContent(),

              // loadstatus
              //     ? showProgress()
              //     : ListView.separated(
              //         padding: EdgeInsets.all(10),
              //         separatorBuilder: (BuildContext context, int index) {
              //           return Align(
              //             alignment: Alignment.centerRight,
              //             child: Container(
              //               height: 0.5,
              //               width: MediaQuery.of(context).size.width / 1.3,
              //               child: Divider(),
              //             ),
              //           );
              //         },
              //         itemCount: allUnSeenNotification.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           var list = allUnSeenNotification[index];

              //           return Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: ListTile(
              //               leading: CircleAvatar(
              //                 backgroundImage:
              //                     AssetImage('assets/images/pawprints.png'),
              //                 radius: 25,
              //               ),
              //               contentPadding: EdgeInsets.all(0),
              //               title: Text(list['user_email']),
              //               subtitle: Text(list['comments']),
              //               trailing: Text(
              //                 list['comments_date'],
              //                 style: TextStyle(
              //                   fontWeight: FontWeight.w300,
              //                   fontSize: 11,
              //                 ),
              //               ),
              //               onTap: () {
              //                 updateNotification(list['id'])
              //                     .whenComplete(() => getunseenNotification());
              //               },
              //             ),
              //           );
              //         },
              //       )
            ],
          ),
        ],
      ),
    );
  }

  Widget showListComments() => ListView.separated(
        padding: EdgeInsets.all(10),
        separatorBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Divider(),
            ),
          );
        },
        itemCount: commentsModels.length,
        itemBuilder: (BuildContext context, int index) {
          var list = commentsModels[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/pawprints.png'),
                radius: 25,
              ),
              contentPadding: EdgeInsets.all(0),
              title: Text('${list.authorpost}'),
              subtitle: Text('${list.comments}'),
              trailing: Text(
                '${list.commentsdate}',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
              onTap: () {
                updateNotification(list.id).whenComplete(() => readComments());
              },
            ),
          );
        },
      );

  @override
  bool get wantKeepAlive => true;
}

class ChatItems extends StatefulWidget {
  final id;
  final pathimagepets;
  final namepets;
  final userimage;
  final isOnline;
  final msg;

  ChatItems({
    Key key,
    this.id,
    this.pathimagepets,
    this.namepets,
    this.isOnline,
    this.msg,
    this.userimage,
  }) : super(key: key);

  @override
  _ChatItemsState createState() => _ChatItemsState();
}

class _ChatItemsState extends State<ChatItems> {
  @override
  Widget build(BuildContext context) {
    bool editMode = false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Stack(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(widget.pathimagepets),
              radius: 25,
            ),
            Positioned(
              bottom: 0.0,
              left: 6.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                height: 11,
                width: 11,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    height: 7,
                    width: 7,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          '${widget.namepets}',
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${widget.msg}',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        // trailing: Column(
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   children: <Widget>[
        //     SizedBox(height: 10),
        //     Text(
        //       "${widget.time}",
        //       style: TextStyle(
        //         fontWeight: FontWeight.w300,
        //         fontSize: 11,
        //       ),
        //     ),
        //     SizedBox(height: 5),
        //     widget.counter == 0
        //         ? SizedBox()
        //         : Container(
        //             padding: EdgeInsets.all(1),
        //             decoration: BoxDecoration(
        //               color: Colors.red,
        //               borderRadius: BorderRadius.circular(6),
        //             ),
        //             constraints: BoxConstraints(
        //               minWidth: 11,
        //               minHeight: 11,
        //             ),
        //             child: Padding(
        //               padding: EdgeInsets.only(top: 1, left: 5, right: 5),
        //               child: Text(
        //                 "${widget.counter}",
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 10,
        //                 ),
        //                 textAlign: TextAlign.center,
        //               ),
        //             ),
        //           ),
        //   ],
        // ),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return Conversation();
              },
            ),
          );
        },
      ),
    );
  }
}
