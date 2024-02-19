// Import function triggers from their respective submodules:
// const {onCall} = require("firebase-functions/v2/https");
// const {onDocumentWritten} = require("firebase-functions/v2/firestore");
//
// See a full list of supported triggers at https://firebase.google.com/docs/functions

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.deleteUser = functions.https.onCall(async (data, context) => {
  const userId = data.userId;
  console.log("Już wewnątrz " + userId);
  try {
    await admin.auth().deleteUser(userId);
    await admin.firestore().collection("users").doc(userId).delete();
    return {
      status: "success",
      message: `Użytkownik ${userId} został usunięty.`,
    };
  } catch (error) {
    console.log(error);
    throw new functions.https.HttpsError("internal", error.message);
  }
});

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   console.log("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
