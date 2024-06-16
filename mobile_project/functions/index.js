/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

exports.addLike = logger.firestore.document("/posts/{postId}/likes/{userId}")
    .onCreate((snap, context) => {
      return db
          .collection("posts")
          .doc(context.params.postId)
          .update(
              {
                like: admin.firestore.FieldValue.increment(1),
              });
    });


exports.delLike = logger.firestore.document("/posts/{postId}/likes/{userId}")
    .onDelete((snap, context) => {
      return db
          .collection("posts")
          .doc(context.params.postId)
          .update(
              {
                like: admin.firestore.FieldValue.increment(-1),
              });
    });
