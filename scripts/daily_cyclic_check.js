const admin = require('firebase-admin');

const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
const db = admin.firestore();

// ── helpers ──────────────────────────────────────────────────────────────
function addMonths(date, n) {
  const d = new Date(date);
  d.setMonth(d.getMonth() + n);
  return d;
}

function isSameDay(a, b) {
  return (
    a.getFullYear() === b.getFullYear() &&
    a.getMonth() === b.getMonth() &&
    a.getDate() === b.getDate()
  );
}

// cycle identifier = the cycle's own start date, e.g. "2026-08-10"
// NOT the calendar month — this is the whole fix.
function cycleKey(date) {
  return date.toISOString().slice(0, 10);
}

// finds the start date of the cycle that "now" currently falls inside,
// based on this specific group's startDate (day-of-month may shift
// slightly around short months, which is fine — Date handles it).
function getCurrentCycleStart(startDate, now) {
  if (startDate > now) return null; // group hasn't started yet
  let cycleStart = new Date(startDate);
  while (true) {
    const next = addMonths(cycleStart, 1);
    if (next > now) break;
    cycleStart = next;
  }
  return cycleStart;
}

// ── main ─────────────────────────────────────────────────────────────────
async function runDailyCycleCheck() {
  const now = new Date();
  console.log(`Running daily cycle check for ${now.toISOString()}`);

  const groupsSnap = await db.collection('groups').get();
  if (groupsSnap.empty) {
    console.log('No groups found.');
    return;
  }

  let closedCount = 0;
  let openedCount = 0;
  let groupsRolledOver = 0;

  for (const groupDoc of groupsSnap.docs) {
    const group = groupDoc.data();
    const groupId = groupDoc.id;

    const startDate = group.startDate?.toDate();
    const endDate = group.endDate?.toDate();
    if (!startDate) continue;
    if (endDate && endDate < now) continue; // group already ended

    const cycleStart = getCurrentCycleStart(startDate, now);
    if (!cycleStart) continue; // group hasn't started yet

    // only act on the exact day a new cycle begins for THIS group
    if (!isSameDay(now, cycleStart)) continue;

    groupsRolledOver++;
    const currentKey = cycleKey(cycleStart);
    const previousCycleStart = addMonths(cycleStart, -1);
    const previousKey = cycleKey(previousCycleStart);

    // 1) close the previous cycle: any still-pending record becomes unpaid
    if (previousCycleStart >= startDate) {
      const pendingSnap = await db
        .collection('monthlyContributions')
        .where('groupId', '==', groupId)
        .where('month', '==', previousKey)
        .where('status', '==', 'pending')
        .get();

      if (!pendingSnap.empty) {
        const closeBatch = db.batch();
        pendingSnap.docs.forEach((doc) => {
          closeBatch.update(doc.ref, {
            status: 'unpaid',
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        });
        await closeBatch.commit();
        closedCount += pendingSnap.size;
      }
    }

    // 2) open the new cycle for every current member of this group
    const membershipsSnap = await db
      .collection('memberships')
      .where('groupId', '==', groupId)
      .get();

    if (membershipsSnap.empty) continue;

    const openBatch = db.batch();
    let batchHasWrites = false;

    for (const membershipDoc of membershipsSnap.docs) {
      const { userId } = membershipDoc.data();

      const existing = await db
        .collection('monthlyContributions')
        .where('userId', '==', userId)
        .where('groupId', '==', groupId)
        .where('month', '==', currentKey)
        .get();

      if (!existing.empty) continue; // already created for this cycle

      const newRef = db.collection('monthlyContributions').doc();
      openBatch.set(newRef, {
        userId,
        groupId,
        month: currentKey,
        status: 'pending',
        amount: 0,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      batchHasWrites = true;
      openedCount++;
    }

    if (batchHasWrites) await openBatch.commit();
  }

  console.log(
    `✅ ${groupsRolledOver} group(s) rolled over today — closed ${closedCount} unpaid record(s), opened ${openedCount} new pending record(s).`
  );
}

runDailyCycleCheck().catch(console.error);