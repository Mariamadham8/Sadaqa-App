const admin = require('firebase-admin');

const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

const db = admin.firestore();

async function markUnpaid() {
    const now = new Date();
    const month = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;

    console.log(`Marking unpaid for: ${month}`);

    // جيب كل الـ pending records للشهر الحالي
    const snap = await db.collection('monthlyContributions')
        .where('month', '==', month)
        .where('status', '==', 'pending')
        .get();

    if (snap.empty) {
        console.log('No pending records found.');
        return;
    }

    const batch = db.batch();

    snap.docs.forEach(doc => {
        batch.update(doc.ref, {
            status: 'unpaid',
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    });

    await batch.commit();
    console.log(`✅ Marked ${snap.size} records as unpaid`);
}

markUnpaid().catch(console.error);