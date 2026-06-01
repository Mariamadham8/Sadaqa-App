const admin = require('firebase-admin');
const axios = require('axios');

const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

const db = admin.firestore();

const ONESIGNAL_APP_ID = process.env.ONESIGNAL_APP_ID;
const ONESIGNAL_API_KEY = process.env.ONESIGNAL_API_KEY;

async function sendReminder() {
    const now = new Date();
    const month = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;

    console.log(`Sending reminders for: ${month}`);


    const snap = await db.collection('monthlyContributions')
        .where('month', '==', month)
        .where('status', '==', 'pending')
        .get();

    if (snap.empty) {
        console.log('No pending members to remind.');
        return;
    }


    const groupIds = [...new Set(snap.docs.map(d => d.data().groupId))];
    const groupNames = {};
    for (const gId of groupIds) {
        const g = await db.collection('groups').doc(gId).get();
        if (g.exists) groupNames[gId] = g.data().name;
    }


    let reminderCount = 0;

    for (const doc of snap.docs) {
        const { userId, groupId } = doc.data();
        const groupName = groupNames[groupId] || 'الجروب';

        const userSnap = await db.collection('users').doc(userId).get();
        if (!userSnap.exists) continue;

        const { oneSignalPlayerId } = userSnap.data();
        if (!oneSignalPlayerId) continue;

        await axios.post('https://onesignal.com/api/v1/notifications', {
            app_id: ONESIGNAL_APP_ID,
            include_player_ids: [oneSignalPlayerId],
            headings: { en: 'تذكير 🔔', ar: 'تذكير 🔔' },
            contents: {
                en: `الشهر بيخلص! لسه مدفعتش صدقة ${groupName}`,
                ar: `الشهر بيخلص! لسه مدفعتش صدقة ${groupName}`,
            },
        }, {
            headers: {
                Authorization: `Basic ${ONESIGNAL_API_KEY}`,
                'Content-Type': 'application/json',
            },
        });

        reminderCount++;
    }

    console.log(`✅ Sent ${reminderCount} reminders`);
}

sendReminder().catch(console.error);