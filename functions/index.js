const functions = require("firebase-functions");
const firebase_tools = require("firebase-tools");
const admin = require("firebase-admin");
admin.initializeApp();

var database = admin.firestore();
var userCollection = database.collection("Users");
exports.scheduledMatcher = functions.pubsub
  // .schedule("* * * * *")
  .schedule("every 10 minutes")
  .onRun(async (context) => {
    try {
      var compareDate = new Date();
      // compareDate.setHours(compareDate.getHours() - 8);
      compareDate.setMinutes(compareDate.getMinutes() - 1);
      var starthour = admin.firestore.Timestamp.fromDate(compareDate);
      var rawmatches = await userCollection
        .where("lastMatchedTime", "<=", starthour)
        .get();
      let alreadyMatchedList = [];
      let matchCount = 0;

      if (rawmatches.docs.length != 0) {
        rawmatches.docs.sort(
          (a, b) => a.data()["lastMatchedTime"] - b.data()["lastMatchedTime"]
        );
        var matches = rawmatches.docs.filter(
          (item) => item.data()["noOfCurrentMatches"] < 6
        );
        if (matches.length != 0) {
          for (var a = matches.length - 1; a >= 0; a--) {
            const tempDoc = matches;
            var elem = tempDoc[a];
            const currentUser = elem.data();
            matchCount += 1;

            if (!alreadyMatchedList.includes(currentUser["uid"])) {
              var temp = tempDoc.filter((item) => {
                const itemData = item.data();
                return (
                  currentUser["uid"] !== itemData["uid"] &&
                  !alreadyMatchedList.includes(itemData["uid"]) &&
                  !alreadyMatchedList.includes(currentUser["uid"]) &&
                  currentUser["prefferedGender"] === itemData["gender"] &&
                  itemData["prefferedGender"] === currentUser["gender"] &&
                  !itemData["currentMatches"].includes(currentUser["uid"]) &&
                  !currentUser["blockedUsers"].includes(itemData["uid"])
                );
              });

              var matchedBefore = currentUser["previousMatches"];

              var tempNotMatched = temp.filter(
                (item) => !matchedBefore.includes(item.data()["uid"])
              );

              var matcher = [];

              alreadyMatchedList.push(currentUser["uid"]);
              for (let b = 0; b < tempNotMatched.length; b++) {
                const compareUser = tempNotMatched[b].data();
                const getDistance = getDistanceDiffBool(
                  currentUser["lat"],
                  currentUser["long"],
                  compareUser["lat"],
                  compareUser["long"],
                  25
                );
                const getUserAge = getAge(
                  currentUser["age"],
                  compareUser["age"],
                  3
                );
                if (getDistance && getUserAge) {
                  matcher.push(compareUser);
                }
              }

              if (matcher.length == 0) {
                for (let i = 0; i < tempNotMatched.length; i++) {
                  const compareUser = tempNotMatched[i].data();
                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    50
                  );
                  const getUserAge = getAge(
                    currentUser["age"],
                    compareUser["age"],
                    3
                  );
                  if (getDistance && getUserAge) {
                    matcher.push(compareUser);
                  }
                }
              }

              if (matcher.length == 0) {
                for (let i = 0; i < tempNotMatched.length; i++) {
                  const compareUser = tempNotMatched[i].data();
                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    50
                  );
                  const getUserAge = getAge(
                    currentUser["age"],
                    compareUser["age"],
                    5
                  );
                  if (getDistance && getUserAge) {
                    matcher.push(compareUser);
                  }
                }
              }
              if (matcher.length == 0) {
                for (let i = 0; i < tempNotMatched.length; i++) {
                  const compareUser = tempNotMatched[i].data();
                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    100
                  );
                  const getUserAge = getAge(
                    currentUser["age"],
                    compareUser["age"],
                    3
                  );
                  if (getDistance && getUserAge) {
                    matcher.push(compareUser);
                  }
                }
              }
              if (matcher.length == 0) {
                for (let i = 0; i < tempNotMatched.length; i++) {
                  const compareUser = tempNotMatched[i].data();
                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    100
                  );
                  const getUserAge = getAge(
                    currentUser["age"],
                    compareUser["age"],
                    5
                  );
                  if (getDistance && getUserAge) {
                    matcher.push(compareUser);
                  }
                }
              }
              if (matcher.length == 0 && matchedBefore.length != 0) {
                var matchedBeforeUser = [];

                for (let i = 0; i < temp.length; i++) {
                  const compareUser = temp[i].data();

                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    100
                  );
                  if (
                    matchedBefore.length != 0 &&
                    matchedBefore.includes(compareUser["uid"]) &&
                    getDistance
                  ) {
                    matchedBeforeUser.push(compareUser);
                  }
                }
                if (matchedBeforeUser.length != 0) {
                  const randomIndex = Math.floor(
                    Math.random() * matchedBeforeUser.length
                  );
                  var compare = matchedBeforeUser[randomIndex];
                  matcher.push(compare);
                }
              }
              if (matcher.length == 0) {
                for (let i = 0; i < tempNotMatched.length; i++) {
                  const compareUser = tempNotMatched[i].data();
                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    200
                  );
                  const getUserAge = getAge(
                    currentUser["age"],
                    compareUser["age"],
                    3
                  );
                  if (getDistance && getUserAge) {
                    matcher.push(compareUser);
                  }
                }
              }
              if (matcher.length == 0 && matchedBefore.length != 0) {
                var matchedBeforeUser = [];

                for (let i = 0; i < temp.length; i++) {
                  const compareUser = temp[i].data();

                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    200
                  );
                  if (
                    matchedBefore.length != 0 &&
                    matchedBefore.includes(compareUser["uid"]) &&
                    getDistance
                  ) {
                    matchedBeforeUser.push(compareUser);
                  }
                }
                if (matchedBeforeUser.length != 0) {
                  const randomIndex = Math.floor(
                    Math.random() * matchedBeforeUser.length
                  );
                  var compare = matchedBeforeUser[randomIndex];
                  matcher.push(compare);
                }
              }
              if (matcher.length == 0 && temp.length != 0) {
                const randomIndex = Math.floor(Math.random() * temp.length);

                var compare = temp[randomIndex].data();
                matcher.push(compare);
              }
              if (matcher.length > 1) {
                matcher.sort((a, b) =>
                  getDistanceDiff(b["lat"], b["long"], a["lat"], a["long"])
                );
                matcher.sort((a, b) => {
                  return new Date(b["age"]) - new Date(a["age"]);
                });
              }

              if (matcher.length != 0) {
                const [finalMatchedUser] = matcher;

                alreadyMatchedList.push(finalMatchedUser["uid"]);
                const deckRef = database.collection("Decks").doc();
                var currentid = currentUser["uid"];
                var finalid = finalMatchedUser["uid"];
                const now = admin.firestore.Timestamp.now();
                var newStatus = {};
                newStatus[currentid] = true;
                newStatus[finalid] = true;

                await deckRef.set({
                  timeMatched: now,
                  isNew: newStatus,
                  uid: deckRef.id,
                  users: [currentid, finalid],
                });

                currentUser["lastMatchedTime"] = now;
                currentUser["currentMatches"].push(finalid);
                currentUser["previousMatches"].push(finalid);
                currentUser["currentDeck"].push(deckRef.id);
                currentUser["noOfCurrentMatches"] =
                  currentUser["currentMatches"].length;
                if (!currentUser["previousMatches"].includes(finalid)) {
                  currentUser["previousMatches"].push(finalid);
                }

                finalMatchedUser["lastMatchedTime"] = now;
                finalMatchedUser["currentMatches"].push(currentid);
                finalMatchedUser["currentDeck"].push(deckRef.id);
                finalMatchedUser["noOfCurrentMatches"] =
                  finalMatchedUser["currentMatches"].length;
                if (!finalMatchedUser["previousMatches"].includes(currentid)) {
                  finalMatchedUser["previousMatches"].push(currentid);
                }

                await userCollection.doc(currentid).update(currentUser);

                await userCollection.doc(finalid).update(finalMatchedUser);
                const messageData = {};
                messageData["title"] = "The Deck";
                messageData["body"] = "You have a new match";

                if (currentUser["recieveMatchNotification"] === true) {
                  sendNotification(currentUser["fcmToken"], messageData);
                }
                if (finalMatchedUser["recieveMatchNotification"] === true) {
                  sendNotification(finalMatchedUser["fcmToken"], messageData);
                }
              }
            }
          }
        }
        console.log("function done", matchCount);
      }
    } catch (e) {
      console.log("Error ", e);
    }
  });

exports.helloWorld = functions
  .runWith({ timeoutSeconds: 500 })
  .https.onRequest(async (req, res) => {
    try {
      var compareDate = new Date();
      // compareDate.setHours(compareDate.getHours() - 8);
      compareDate.setMinutes(compareDate.getMinutes() - 1);
      var starthour = admin.firestore.Timestamp.fromDate(compareDate);
      console.log("starthour", starthour.toDate());
      var rawmatches = await userCollection
        .where("lastMatchedTime", "<=", starthour)
        .get();
      let alreadyMatchedList = [];
      let matchCount = 0;
      if (rawmatches.docs.length != 0) {
        rawmatches.docs.sort(
          (a, b) => a.data()["lastMatchedTime"] - b.data()["lastMatchedTime"]
        );
        var matches = rawmatches.docs.filter(
          (item) => item.data()["noOfCurrentMatches"] < 6
        );

        if (matches.length != 0) {
          for (var a = matches.length - 1; a >= 0; a--) {
            const tempDoc = matches;
            var elem = tempDoc[a];
            const currentUser = elem.data();
            // console.log("currentUser", currentUser);
            matchCount += 1;

            if (!alreadyMatchedList.includes(currentUser["uid"])) {
              console.log("currentUser", "not in list");
              var temp = tempDoc.filter((item) => {
                const itemData = item.data();
                return (
                  currentUser["uid"] !== itemData["uid"] &&
                  !alreadyMatchedList.includes(itemData["uid"]) &&
                  !alreadyMatchedList.includes(currentUser["uid"]) &&
                  currentUser["prefferedGender"] === itemData["gender"] &&
                  itemData["prefferedGender"] === currentUser["gender"] &&
                  !itemData["currentMatches"].includes(currentUser["uid"]) &&
                  !currentUser["blockedUsers"].includes(itemData["uid"])
                );
              });

              var matchedBefore = currentUser["previousMatches"];

              var tempNotMatched = temp.filter(
                (item) => !matchedBefore.includes(item.data()["uid"])
              );

              var matcher = [];

              alreadyMatchedList.push(currentUser["uid"]);
              for (let b = 0; b < tempNotMatched.length; b++) {
                const compareUser = tempNotMatched[b].data();
                const getDistance = getDistanceDiffBool(
                  currentUser["lat"],
                  currentUser["long"],
                  compareUser["lat"],
                  compareUser["long"],
                  25
                );
                const getUserAge = getAge(
                  currentUser["age"],
                  compareUser["age"],
                  3
                );
                if (getDistance && getUserAge) {
                  matcher.push(compareUser);
                }
              }

              if (matcher.length == 0) {
                for (let i = 0; i < tempNotMatched.length; i++) {
                  const compareUser = tempNotMatched[i].data();
                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    50
                  );
                  const getUserAge = getAge(
                    currentUser["age"],
                    compareUser["age"],
                    3
                  );
                  if (getDistance && getUserAge) {
                    matcher.push(compareUser);
                  }
                }
              }

              if (matcher.length == 0) {
                for (let i = 0; i < tempNotMatched.length; i++) {
                  const compareUser = tempNotMatched[i].data();
                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    50
                  );
                  const getUserAge = getAge(
                    currentUser["age"],
                    compareUser["age"],
                    5
                  );
                  if (getDistance && getUserAge) {
                    matcher.push(compareUser);
                  }
                }
              }
              if (matcher.length == 0) {
                for (let i = 0; i < tempNotMatched.length; i++) {
                  const compareUser = tempNotMatched[i].data();
                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    100
                  );
                  const getUserAge = getAge(
                    currentUser["age"],
                    compareUser["age"],
                    3
                  );
                  if (getDistance && getUserAge) {
                    matcher.push(compareUser);
                  }
                }
              }
              if (matcher.length == 0) {
                for (let i = 0; i < tempNotMatched.length; i++) {
                  const compareUser = tempNotMatched[i].data();
                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    100
                  );
                  const getUserAge = getAge(
                    currentUser["age"],
                    compareUser["age"],
                    5
                  );
                  if (getDistance && getUserAge) {
                    matcher.push(compareUser);
                  }
                }
              }
              if (matcher.length == 0 && matchedBefore.length != 0) {
                var matchedBeforeUser = [];

                for (let i = 0; i < temp.length; i++) {
                  const compareUser = temp[i].data();

                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    100
                  );
                  if (
                    matchedBefore.length != 0 &&
                    matchedBefore.includes(compareUser["uid"]) &&
                    getDistance
                  ) {
                    matchedBeforeUser.push(compareUser);
                  }
                }
                if (matchedBeforeUser.length != 0) {
                  const randomIndex = Math.floor(
                    Math.random() * matchedBeforeUser.length
                  );
                  var compare = matchedBeforeUser[randomIndex];
                  matcher.push(compare);
                }
              }
              if (matcher.length == 0) {
                for (let i = 0; i < tempNotMatched.length; i++) {
                  const compareUser = tempNotMatched[i].data();
                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    200
                  );
                  const getUserAge = getAge(
                    currentUser["age"],
                    compareUser["age"],
                    3
                  );
                  if (getDistance && getUserAge) {
                    matcher.push(compareUser);
                  }
                }
              }
              if (matcher.length == 0 && matchedBefore.length != 0) {
                var matchedBeforeUser = [];

                for (let i = 0; i < temp.length; i++) {
                  const compareUser = temp[i].data();

                  const getDistance = getDistanceDiffBool(
                    currentUser["lat"],
                    currentUser["long"],
                    compareUser["lat"],
                    compareUser["long"],
                    200
                  );
                  if (
                    matchedBefore.length != 0 &&
                    matchedBefore.includes(compareUser["uid"]) &&
                    getDistance
                  ) {
                    matchedBeforeUser.push(compareUser);
                  }
                }
                if (matchedBeforeUser.length != 0) {
                  const randomIndex = Math.floor(
                    Math.random() * matchedBeforeUser.length
                  );
                  var compare = matchedBeforeUser[randomIndex];
                  matcher.push(compare);
                }
              }
              if (matcher.length == 0 && temp.length != 0) {
                const randomIndex = Math.floor(Math.random() * temp.length);

                var compare = temp[randomIndex].data();
                matcher.push(compare);
              }
              if (matcher.length > 1) {
                matcher.sort((a, b) =>
                  getDistanceDiff(b["lat"], b["long"], a["lat"], a["long"])
                );
                matcher.sort((a, b) => {
                  return new Date(b["age"]) - new Date(a["age"]);
                });
              }

              if (matcher.length != 0) {
                const [finalMatchedUser] = matcher;

                alreadyMatchedList.push(finalMatchedUser["uid"]);
                const deckRef = database.collection("Decks").doc();
                var currentid = currentUser["uid"];
                var finalid = finalMatchedUser["uid"];
                const now = admin.firestore.Timestamp.now();
                var newStatus = {};
                newStatus[currentid] = true;
                newStatus[finalid] = true;

                await deckRef.set({
                  timeMatched: now,
                  isNew: newStatus,
                  uid: deckRef.id,
                  users: [currentid, finalid],
                });

                currentUser["lastMatchedTime"] = now;
                currentUser["currentMatches"].push(finalid);
                currentUser["previousMatches"].push(finalid);
                currentUser["currentDeck"].push(deckRef.id);
                currentUser["noOfCurrentMatches"] =
                  currentUser["currentMatches"].length;
                if (!currentUser["previousMatches"].includes(finalid)) {
                  currentUser["previousMatches"].push(finalid);
                }

                finalMatchedUser["lastMatchedTime"] = now;
                finalMatchedUser["currentMatches"].push(currentid);
                finalMatchedUser["currentDeck"].push(deckRef.id);
                finalMatchedUser["noOfCurrentMatches"] =
                  finalMatchedUser["currentMatches"].length;
                if (!finalMatchedUser["previousMatches"].includes(currentid)) {
                  finalMatchedUser["previousMatches"].push(currentid);
                }

                await userCollection.doc(currentid).update(currentUser);

                await userCollection.doc(finalid).update(finalMatchedUser);
                const messageData = {};
                messageData["title"] = "The Deck";
                messageData["body"] = "You have a new match";

                // if (currentUser["recieveMatchNotification"] === true) {
                //   sendNotification(currentUser["fcmToken"], messageData);
                // }
                // if (finalMatchedUser["recieveMatchNotification"] === true) {
                //   sendNotification(finalMatchedUser["fcmToken"], messageData);
                // }
              }
            }
          }
        }
        console.log("function done");
      }

      console.log("No error");
      res.send("done");
    } catch (e) {
      console.log("Error ", e);
    }
  });

exports.sendNewMessageAlert = functions
  .runWith({
    timeoutSeconds: 540,
    memory: "2GB",
  })
  .https.onCall(async (data, context) => {
    const path = data.path;
    const name = data.name;
    const messageData = {};
    messageData["title"] = "The Deck";
    messageData["body"] = "You have a new message from " + name;
    sendNotification(path, messageData);
    return {
      path: path,
    };
  });
function sendNotification(androidNotificationToken, data) {
  const message = {
    notification: data,
    token: androidNotificationToken,
  };

  admin
    .messaging()
    .send(message)
    .then((response) => {
      console.log("Successfully sent message:", response);
    })
    .catch((error) => {
      console.log("Error sending message:", error);
    });
}
function getAge(age1, age2, diff) {
  var date1 = new Date(age1);
  var date2 = new Date(age2);
  var age = date2.getFullYear() - date1.getFullYear();
  var m = date2.getMonth() - date1.getMonth();
  if (m < 0 || (m === 0 && date2.getDate() < date1.getDate())) {
    age--;
  }
  return age <= diff && age >= -diff;
}
function getDistanceDiffBool(lat1, lon1, lat2, lon2, num) {
  var d = getDistanceDiff(lat1, lon1, lat2, lon2);
  //TODO:Remove divided
  var dd = d / 500; // Distance in
  return dd <= num;
}
function getDistanceDiff(lat1, lon1, lat2, lon2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2 - lat1); // deg2rad below
  var dLon = deg2rad(lon2 - lon1);
  var a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(deg2rad(lat1)) *
      Math.cos(deg2rad(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c; // Distance in km
  return d;
}

function deg2rad(deg) {
  return deg * (Math.PI / 180);
}

exports.recursiveDeleteDeck = functions
  .runWith({
    timeoutSeconds: 540,
    memory: "2GB",
  })
  .https.onCall(async (data, context) => {
    const path = data.path;
    await doDelete(path);
    return {
      path: path,
    };
  });

exports.recursiveDeleteUser = functions
  .runWith({
    timeoutSeconds: 540,
    memory: "2GB",
  })
  .https.onCall(async (data, context) => {
    const path = data.path;
    const userCurrentMatches = data.currentMatches;
    const useCurrentDeck = data.currentDeck;

    for (const match of userCurrentMatches) {
      const deckIndex = userCurrentMatches.indexOf(match);

      var pathToRemove = {};
      pathToRemove["currentMatches"] =
        admin.firestore.FieldValue.arrayRemove(path);
      pathToRemove["currentDeck"] = admin.firestore.FieldValue.arrayRemove(
        useCurrentDeck[deckIndex]
      );
      pathToRemove["noOfCurrentMatches"] =
        admin.firestore.FieldValue.increment(-1);
      await userCollection.doc(match).update(pathToRemove);
    }

    var deckCollection = await database
      .collectionGroup("Decks")
      .where("users", "array-contains", path)

      .get();
    if (deckCollection.docs.length !== 0) {
      for (const deck of deckCollection.docs) {
        var deckId = deck.id;
        var deckpath = "Decks/" + deckId;

        await doDelete(deckpath);
      }
    }
    await userCollection.doc(path).delete();
    return {
      path: path,
    };
  });

function doDelete(path) {
  // Run a recursive delete on the given document or collection path.
  // The 'token' must be set in the functions config, and can be generated
  // at the command line by running 'firebase login:ci'.
  return firebase_tools.firestore.delete(path, {
    project: process.env.GCLOUD_PROJECT,
    recursive: true,
    yes: true,
    token: functions.config().fb.token,
  });
}
