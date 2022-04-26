import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
User loggedinUser;
FirebaseFirestore fs= FirebaseFirestore.instance;
String username;
String hostname;
int conversationId;
List<LocalUser> systemNames= List.empty(growable: true);
List<LocalUser> partners = List.empty(growable: true);
List<Partner> activePartners= List.empty(growable: true);
List<ChatUser> chatUser= List.empty(growable: true);
SystemUser systemUser;
List<int> conIds=List.empty(growable: true);
List<int> toConIds= List.empty(growable: true);
List<int> systemConIds= List.empty(growable: true);
List<DocumentSnapshot> userInboundMessages= List.empty(growable: true);
List<DocumentSnapshot> userSentMessages= List.empty(growable: true);
List<ChatMessage> allMessage= List.empty(growable: true);
String chatName;
Partner selectedPartner;
DocumentSnapshot activeDoc;


class ConversationScreen extends StatefulWidget{
	@override
	_ConversationScreenState createState()=> _ConversationScreenState();
	}
class _ConversationScreenState extends State<ConversationScreen>{
	final _auth = FirebaseAuth.instance;
	
	void initState(){
	super.initState();
	getCurrentUser();
	}
	
	 void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  
   
  @override
  Widget build(BuildContext context){
	bool cont= true;
	final user= _auth.currentUser;
	final String id= user.uid;
	return StreamBuilder<QuerySnapshot>(
		stream: fs.collection('users').snapshots(),
		builder: (context, snapshot){
			if(!snapshot.hasData){
				
			return Scaffold();
			}
			
			else if(snapshot.hasData){
			List<DocumentSnapshot> documents= snapshot.data.docs;
			for(DocumentSnapshot doc in documents){
				LocalUser newUser= LocalUser(doc.get("name"), doc.get("convoId"));
				systemNames.add(newUser);
				if(doc.get("uid") == id){
					username=doc.get("username");
					hostname= doc.get("name");
					conversationId= doc.get("convoId");
				}
			}
			return MaterialApp(
					title: 'UserScreen',
					theme: ThemeData(
					primarySwatch: Colors.blue,
					),
				debugShowCheckedModeBanner: false,
				home: UserScreen(),
				);
		}
			
			
			print(username + " " + conversationId.toString());
			
			return Scaffold();
			}
			);
			}
  
  }

class UserScreen extends StatefulWidget{
	@override
	_UserScreenState createState()=> _UserScreenState();
	}

class _UserScreenState extends State<UserScreen>{
	Widget build(BuildContext context) {
	   final _auth = FirebaseAuth.instance;
	 return StreamBuilder<QuerySnapshot>(
    stream: fs.collection('conversations').snapshots(),
		builder: (context, snap){
			if(!snap.hasData){
				return Scaffold(
					
				);
   			}
			else{
				List<DocumentSnapshot> documents= snap.data.docs;
					
			for(DocumentSnapshot doc in documents){
				if(doc.get("primaryUserNum") == conversationId){
					conIds.add(doc.get("conversationId"));
					
									
				}
					if(doc.get("toUserNum") == conversationId){
					toConIds.add(doc.get("conversationId"));
					for(var localUser in systemNames){
							if(doc.get("primaryUserNum")== localUser.id){
							LocalUser __user= LocalUser(localUser.name,
							 doc.get("conversationId"));
							partners.add(__user);
						}
						
												}
					
				}
			
			}
			return MaterialApp(
					title: 'Message Screen',
					theme: ThemeData(
					primarySwatch: Colors.blue,
					),
				debugShowCheckedModeBanner: false,
				home: MessScreen(),
				);
			return Scaffold();
			}
		}
		);
	}
}

class MessScreen extends StatefulWidget{
	@override
	_MessScreenState createState()=> _MessScreenState();
	}

class _MessScreenState extends State<MessScreen>{
	Widget build(BuildContext context) {
		List<int>senderIds = List.empty(growable: true);
		List<int>recIds = List.empty(growable: true);
	   final _auth = FirebaseAuth.instance;
	 return StreamBuilder<QuerySnapshot>(
    stream: fs.collection('messages').snapshots(),
		builder: (context, snap){
			
			if(!snap.hasData){
				return Scaffold(
					
				);
   			}
			else{
				
				List<DocumentSnapshot> documents= snap.data.docs;
				
			for(DocumentSnapshot doc in documents){
				systemConIds.add(doc.get("conversationId"));
				}
				
			for(DocumentSnapshot doc in documents){
				for(var i in toConIds ){
					
					if(doc.get("conversationId")== i){
						userInboundMessages.add(doc);
						senderIds.add(doc.get("conversationId"));
						for(var partner in partners){
							
							if(partner.id== doc.get("conversationId")){
								
								List<MessageInfo> outMessages = List.empty(growable: true);
								for(var output in doc.get("inputMessages")){
									DateTime dateTime = output["timestamp"].toDate();
									MessageInfo messageInfo = MessageInfo(output["message"], DateFormat.yMMMd().format(dateTime), output["timestamp"].toDate(), output["messageId"]);
									outMessages.add(messageInfo);
								}
								Partner _partner= Partner(partner.name, partner.id, outMessages);
								activePartners.add(_partner);
							}
							
						}	
						
					}
				}
				for(var i in conIds){
					
					if(doc.get("conversationId")== i){
						userSentMessages.add(doc);
						recIds.add(doc.get("conversationId"));
						
					}
				}	
			}
				systemUser= SystemUser(hostname, senderIds, recIds);
		}
		return MaterialApp(
					title: 'Interaction Screen',
					theme: ThemeData(
					primarySwatch: Colors.blue,
					),
				debugShowCheckedModeBanner: false,
				home: InteractionScreen(),
				);
			
			return Scaffold();
			}
		
		);
	}
}

class InteractionScreen extends StatefulWidget{
	@override
	_InteractionScreenState createState()=> _InteractionScreenState();
	}
	
class _InteractionScreenState extends State<InteractionScreen>
	with SingleTickerProviderStateMixin, RestorationMixin{
	TabController _controller;
	
	final RestorableInt tabIndex= RestorableInt(0);
	
	@override
	String get restorationId =>
	'interactionScreen';
	
	@override
	void restoreState(RestorationBucket oldBucket, bool initialRestore){
		registerForRestoration(tabIndex, 'tab_index');
		_controller.index= tabIndex.value;
	}
	
	@override
	void initState(){
		_controller = TabController(
			initialIndex: 0,
			length: 2,
			vsync: this,
		);
		_controller.addListener((){
			setState((){
				tabIndex.value= _controller.index;
			});
		});
		super.initState();
	}
	
	@override
	void dispose(){
		_controller.dispose();
		tabIndex.dispose();
		super.dispose();
	}
	
	@override
	Widget build(BuildContext context) {
		final _auth = FirebaseAuth.instance;
		
				return Scaffold(
						appBar: AppBar(
							automaticallyImplyLeading: false,
							flexibleSpace: SafeArea(
								child: Container(
									padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Conversations",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                    Container(
                      padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
									child: Row(
                        children: <Widget>[
                          Icon(Icons.add,color: Colors.pink,size: 20,),
                          SizedBox(width: 2,),
                          Text("Add New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
						),
						],
						),
								),
							),
							bottom: TabBar(
								controller: _controller,
								isScrollable: true,
								tabs: [
									Tab(text:"Chats", icon: Icon(Icons.message)),
									Tab(text:"Calls", icon: Icon(Icons.group_work)),
								],
							),
						),
							body: TabBarView(
								controller: _controller,
								children:[
									Center(
										child: 
											ListView.builder(
												itemCount : partners.length,
												itemBuilder: (context, index){
													return SizedBox(
														height: 100.0,
													
													child: Card(
														child: GestureDetector(
															onTap:(){
																selectedPartner= activePartners[index];
																chatName= partners[index].name;
																 Navigator.push(context, MaterialPageRoute(builder: (context){
          															return PeerScreen();
        																}));
															},
															child: Container(
														
															height:50.0,
															color: Colors.white,
															child: Row(
																children:[
																	Expanded(
																		child: Container(
																			alignment: Alignment.topLeft,
																			child: Column(
																			children: [
																				Expanded(
																					flex: 5,
																					child: ListTile(
																						title: Text(partners[index].name),
																						
																					),
																				),
																			],
																	
																		),
																		),
																	),
																],
															),
															
														),
														),
														
														clipBehavior: Clip.antiAlias,
														elevation: 9,
														shape: BeveledRectangleBorder(
															borderRadius: BorderRadius.circular(15)
														),
														
													),
													
												);
												},
											),
												
												
									),
									Center(
										child: Text("Coming Soon"),
									),
								],
							),
			);
		}
	}
	
	class PeerScreen extends StatefulWidget{
	@override
	_PeerScreenState createState()=> _PeerScreenState();
	}
	
class _PeerScreenState extends State<PeerScreen>{
	@override
	TextEditingController messageController = TextEditingController();
  String newMessage = '';
	Widget build(BuildContext context) {
		List<LocalMessage> peerMessages= List.empty(growable: true);
		List<LocalMessage> myMessages= List.empty(growable: true);
		for(var id in systemUser.senderIds){
			for(var _message in selectedPartner.sentMessages){
				LocalMessage local= LocalMessage(_message.message, _message.timestamp);
				peerMessages.add(local);
			}
			
				
				for(var userSentMessage in userSentMessages){
					try{
						
						if(selectedPartner.id == userSentMessage.get("peerConversationId")){
							activeDoc= userSentMessage;
						for(var map in userSentMessage.get("inputMessages")){
							LocalMessage local= LocalMessage(map["message"], map["timestamp"].toDate());
							myMessages.add(local);
						}
						
						
					}
					}
					catch(e){
						
						}
				}
				}
		
		List<ChatMessage> chatMessages= List.empty(growable: true);
		for(var _message in peerMessages){
			ChatMessage chatMessage= ChatMessage(_message.message, "receiver", _message.timestamp);
			chatMessages.add(chatMessage);
		}
		for(var _message in myMessages){
			ChatMessage chatMessage= ChatMessage(_message.message, "sender", _message.timestamp);
			chatMessages.add(chatMessage);
		}
		chatMessages.sort((a,b)=> a.timestamp.compareTo(b.timestamp));
	return Scaffold(
     
	  appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
          															return InteractionScreen();
					}));
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                ),
                SizedBox(width: 2,),
                CircleAvatar(
                  backgroundImage: NetworkImage("<https://randomuser.me/api/portraits/men/5.jpg>"),
                  maxRadius: 20,
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(chatName,style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                      SizedBox(height: 6,),
                    ],
                  ),
                ),
                Icon(Icons.settings,color: Colors.black54,),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
	ListView.builder(
            itemCount: chatMessages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10,bottom: 10),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                child: Align(
        alignment: (chatMessages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (chatMessages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.blue[200]),
          ),
          padding: EdgeInsets.all(16),
          child: Text(chatMessages[index].messageContent, style: TextStyle(fontSize: 15),),
        ),
      ),
    );
  },
),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
					  controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none
                      ),
						onChanged: (text){
							setState((){
								newMessage= text;
								
							});
						}
						),
                    ),
                 
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){
					addMessage(newMessage);
					setState(() {
                  newMessage = "";
                  Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => super.widget));
                });
					 
	
},
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
                
              ),
            ),
          ),
        ],
      ),
    );
}
Future<void> addMessage(String valueText) {
				
				 var inputMap= {'message': valueText, 'timestamp': DateTime.now()};
				
				var map = activeDoc.get("inputMessages");
				int max= 0;
				for(var _map in map){
					max++;
				}
				
				var arr= new List(max+1);
				int count= 0;
				while(count < max){
					print(count);
					arr[count]= map[count];
					count++;
				}
				arr[max]= inputMap;
				print(arr);
				fs.collection('messages').doc(activeDoc.id).update({
					'inputMessages': FieldValue.arrayUnion(arr)
				});
				 
				// Call the admin-messages CollectionReference to add a new message
					
		  }
}
	
class LocalUser{
	String name;
	int id;
	LocalUser(this.name, this.id);
}
class LocalMessage{
	String message;
	DateTime timestamp;
	LocalMessage(this.message, this.timestamp);
}
class MessageInfo{
	String message;
	String date;
	DateTime timestamp;
	int id;
	MessageInfo(this.message, this.date, this.timestamp, this.id);
}

class SystemUser{
	String name;
	List<int> senderIds;
	List<int> recIds;
	SystemUser(this.name, this.senderIds, 
	this.recIds);
}

class Partner{
	String name;
	int id;
	List<MessageInfo> sentMessages;
	Partner(this.name, this.id, this.sentMessages);
}


class ChatMessage{
  String messageContent;
  String messageType;
  DateTime timestamp;
	ChatMessage(this.messageContent, this.messageType, this.timestamp);
}
	
class ChatUser{
	String name;
	String messageText;
	String time;

	ChatUser(this.name, this.messageText,
	this.time);
}


