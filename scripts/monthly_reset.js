const admin = require('firebase-admin');

// Initialize Firebase
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

const db = admin.firestore();

async function monthlyReset() {
    const now = new Date();
    const month = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;

    console.log(`Running monthly reset for: ${month}`);

    // جيب كل الـ memberships
    const membershipsSnap = await db.collection('memberships').get();

    if (membershipsSnap.empty) {
        console.log('No memberships found.');
        return;
    }

    const batch = db.batch();
    let count = 0;

    for (const doc of membershipsSnap.docs) {
        const { userId, groupId } = doc.data();

        // تأكد إن الجروب لسه active
        const groupSnap = await db.collection('groups').doc(groupId).get();
        if (!groupSnap.exists) continue;

        const group = groupSnap.data();
        const endDate = group.endDate?.toDate();
        if (endDate && endDate < now) continue; // الجروب خلص

        // ابحث لو في record موجود للشهر دا
        const existing = await db.collection('monthlyContributions')
            .where('userId', '==', userId)
            .where('groupId', '==', groupId)
            .where('month', '==', month)
            .get();

        if (!existing.empty) continue; // موجود خلاص

        // عمل record جديد بـ pending
        const newRef = db.collection('monthlyContributions').doc();
        batch.set(newRef, {
            userId,
            groupId,
            month,
            status: 'pending',
            amount: 0,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        count++;
    }

    await batch.commit();
    console.log(`✅ Created ${count} pending records for ${month}`);
}

monthlyReset().catch(console.error);