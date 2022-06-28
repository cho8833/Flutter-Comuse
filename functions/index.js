const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.writeEnterHistory = functions.firestore
    .document("Entered/{uid}")
    .onCreate((snap, context) => {
      const user = snap.data();
      const date = new Date();
      const year = date.getFullYear();
      const month = date.getMonth() + 1;
      const day = date.getDate();
      const epoch = date.getTime();
      const now = year + "/" + month + "/" + day + "/" + epoch;
      return admin.database()
          .ref("/Entered_history/"+now)
          .set({
            isEntered: true,
            name: user.name,
            email: user.email,
            epoch: epoch,
          });
    });
exports.writeOutHistory = functions.firestore
    .document("Entered/{uid}")
    .onDelete((snap, context) => {
      const user = snap.data();
      const date = new Date();
      const year = date.getFullYear();
      const month = date.getMonth() + 1;
      const day = date.getDate();
      const epoch = date.getTime();
      const now = year + "/" + month + "/" + day + "/" + epoch;
      return admin.database()
          .ref("Entered_history/"+now)
          .set({
            isEntered: false,
            name: user.name,
            email: user.email,
            epoch: epoch,
          });
    });
exports.onDataUpdate = functions.firestore
    .document("Members/{uid}")
    .onUpdate((change, context) => {
      const newValue = change.after.data();
      return admin.firestore().collection("Entered").doc(newValue.uid).update({
        name: newValue.name,
        position: newValue.position, permission: newValue.permission,
      });
    });
