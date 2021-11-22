const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

/*_________________________________ STORE NOTIFICATION _________________________________*/

exports.onCreateStoreNotifications = functions
    .region("asia-southeast1")
    .firestore.document("notifications/{userId}/storeNotifications/{productId}")
    .onCreate(async (snapshot, context) => {
        const userId = context.params.userId;
        const productId = context.params.productId;

        const userQuerySnapshot = await db.doc(`users/${userId}`).get();
        const productQuerySnapshot = await db.doc(`products/${productId}`).get();

        const notificationToken = userQuerySnapshot.data().androidNotificationToken;

        if (notificationToken != null) {
            sendNotification(notificationToken, snapshot.data());
        } else {
            console.log("no notification");
        }

        function sendNotification(notificationToken, document) {
            let body;
            switch (document.type) {
                case "product_ordered":
                    body = `Product ${productQuerySnapshot.name} have been ordered`;
                    break;
                default:
                    break;
            }
        }
    });


/*_________________________________ SEND MESSAGE _________________________________*/
exports.onNewMessageInConversation = functions.region("asia-southeast1")
    .firestore
    .document("conversations/{conversationID}")
    .onUpdate(async (change, context) => {
        const conversationUpdated = change.after.data();
        const conversationID = context.params.conversationID;


        const memberIDsArray = conversationUpdated.members;
        const lastMessage = conversationUpdated.messages[conversationUpdated.messages.length - 1];

        const senderDocument = await db.collection("users")
            .doc(lastMessage.senderID).get();

        for (const currUserID of memberIDsArray) {
            const otherUserIDsArray = memberIDsArray.filter((otherID) => {
                return otherID !== currUserID;
            });

            for (const otherUserID of otherUserIDsArray) {
                if (conversationUpdated.members.length > 2) {
                    await db.collection("users")
                        .doc(currUserID.toString())
                        .collection("GroupConversations")
                        .doc(conversationID)
                        .set({
                            "conversationID": conversationID,
                            "photoUrl": senderDocument.data().photoUrl,
                            "displayName": senderDocument.data().displayName,
                            "senderID": lastMessage.senderID,
                            "lastMessage_content": lastMessage.message_content,
                            "sentTime": lastMessage.sentTime,
                            "unseenCount": admin.firestore.FieldValue.increment(1),
                            "message_type": lastMessage.message_type,
                        });

                } else {
                    await db.collection("users")
                        .doc(currUserID.toString())
                        .collection("Conversations")
                        .doc(otherUserID)
                        .set({
                            "conversationID": conversationID,
                            "photoUrl": senderDocument.data().photoUrl,
                            "displayName": senderDocument.data().displayName,
                            "senderID": lastMessage.senderID,
                            "lastMessage_content": lastMessage.message_content,
                            "sentTime": lastMessage.sentTime,
                            "unseenCount": admin.firestore.FieldValue.increment(1),
                            "message_type": lastMessage.message_type,
                        });
                }

            }
        }
    });
