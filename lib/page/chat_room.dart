
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passion_factory/model/message.dart';
import 'package:passion_factory/provider/chat_room_provider.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatelessWidget {
  static const routePath = "/chatRoom";
  ChatRoomPage({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return ChangeNotifierProvider(
      create: (context) => ChatRoomProvider(yourUid: args['uid'], roomId: args['roomId']),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${args['nickname']}'),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
                child: messageArea()
            ),
            bottomArea(),
          ],
        ),
      ),
    );
  }



  Widget messageArea() {
    return Consumer<ChatRoomProvider>(
      builder: (_, state, __) => StreamBuilder(
        stream: state.stream,
        builder: (BuildContext  context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError){
            return Container();
          }

          if(snapshot.connectionState ==ConnectionState.waiting){
            return Container();
          }

          if(snapshot.data == null) {
            return Container();
          }

          final messages = snapshot.data!.docs.map((e) => Message.fromJson(e.data())).toList();
          return ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index){
                final Message message =
                messages[index];
                // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment:  message.sendUser != state.myUid ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: message.sendUser != state.myUid ? Colors.blue : Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text(message.message)
                      ),
                    ],
                  ),
                );
              }
          );

        }
      ),
    );
  }

  /*
  * 하단부 UI
  * */
  Widget bottomArea() {
    return Builder(
      builder: (context) => Container(
        height: 50,
        color: Colors.blue,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        border: InputBorder.none
                      ),
                    ),
                  )
              ),
              const SizedBox(width: 10,),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    if(_controller.text != '') {
                      context.read<ChatRoomProvider>().sendMessage(_controller.text);
                    }
                    _controller.text = '';
                  },
                  child: const Text(
                    '보내기',
                    style: TextStyle(color: Colors.blue),
                  ),
                  style: ElevatedButton.styleFrom(primary: CupertinoColors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
