import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_clinic_app/screens/auth_screen.dart';

class MessagesScreen extends StatefulWidget {
  final bool isDoctorMode;
  final String? patientId;

  const MessagesScreen({
    Key? key, 
    this.isDoctorMode = false, 
    this.patientId
  }) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _messageController = TextEditingController();
  String? _currentUserId;
  String? _chatRoomId;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      _showAuthorizationDialog();
      return;
    }

    setState(() {
      _currentUserId = currentUser.uid;
    });

    if (widget.isDoctorMode && widget.patientId != null) {
      // Для врача: создаем чат с конкретным пациентом
      _chatRoomId = _generateChatRoomId(currentUser.uid, widget.patientId!);
    } else {
      // Для пациента: создаем или находим чат с врачом
      _chatRoomId = await _findOrCreateChatRoom(currentUser.uid);
    }
  }

  String _generateChatRoomId(String userId1, String userId2) {
    return userId1.compareTo(userId2) > 0 
      ? '${userId1}_${userId2}' 
      : '${userId2}_${userId1}';
  }

  Future<String> _findOrCreateChatRoom(String userId) async {
    // Логика поиска или создания чат-комнаты
    QuerySnapshot chatRooms = await _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: userId)
        .limit(1)
        .get();

    if (chatRooms.docs.isNotEmpty) {
      return chatRooms.docs.first.id;
    } else {
      // Создаем новую чат-комнату
      DocumentReference newChatRoom = await _firestore.collection('chat_rooms').add({
        'participants': [userId],
        'createdAt': FieldValue.serverTimestamp(),
      });
      return newChatRoom.id;
    }
  }

  void _sendMessage() async {
    if (_chatRoomId == null || _currentUserId == null) return;

    String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    await _firestore.collection('messages').add({
      'chatRoomId': _chatRoomId,
      'senderId': _currentUserId,
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  void _showAuthorizationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Требуется авторизация'),
        content: Text('Для доступа к чату необходимо войти в аккаунт.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
            child: Text('Войти'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_chatRoomId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Чат')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isDoctorMode 
          ? 'Чат с пациентом' 
          : 'Чат с врачом'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                .collection('messages')
                .where('chatRoomId', isEqualTo: _chatRoomId)
                .orderBy('timestamp')
                .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData = messages[index].data() as Map<String, dynamic>;
                    return _buildMessageItem(
                      messageData['text'], 
                      messageData['senderId'] == _currentUserId
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Введите сообщение',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
