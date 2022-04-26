Widget buildMessage() {
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(convoID)
            .collection(convoID)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) =>
                  buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }