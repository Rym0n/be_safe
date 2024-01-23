/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.deleteUser = functions.https.onCall(async (data, context) => {
  // Sprawdź, czy żądanie pochodzi od administratora-
  if (!context.auth || !context.auth.token.admin) {
    throw new functions.https.HttpsError("permission-denied",
        "Tylko administratorzy mogą usuwać użytkowników.");
  }
  const userId = data.userId;
  try {
    await admin.auth().deleteUser(userId);
    return {status: "success",
      message: "Użytkownik ${userId} został usunięty."};
  } catch (error) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
