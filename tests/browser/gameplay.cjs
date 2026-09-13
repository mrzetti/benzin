const { chromium } = require('playwright');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const artifacts = path.join(__dirname, 'artifacts');
fs.mkdirSync(artifacts, { recursive: true });

(async () => {
  const browser = await chromium.launch({
    executablePath: process.env.BROWSER_PATH || undefined,
    headless: true,
    args: ['--no-sandbox'],
  });
  const page = await browser.newPage({ viewport: { width: 1100, height: 1000 } });
  const nickname = 'Verify' + Date.now().toString().slice(-10);
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  const screenshot = name => page.screenshot({ path: path.join(artifacts, name + '.png') });
  const click = async (x, y) => {
    await page.mouse.move(x, y);
    await page.waitForTimeout(300);
    await page.mouse.click(x, y, { delay: 150 });
  };
  try {
    await page.goto(process.env.BENZIN_URL || 'https://benzin.rammwiki.mrzetti.com');
    await page.waitForTimeout(7000);
    await page.context().storageState({ path: path.join(artifacts, 'profile.json') });
    await click(550, 420);
    await page.waitForTimeout(1500);
    await click(875, 688);
    await page.waitForTimeout(1000);
    await click(875, 688);
    await page.waitForTimeout(2000);
    await click(310, 525);
    await page.waitForTimeout(1500);
    await screenshot('instructions');
    const startResponse = page.waitForResponse(r => r.url().endsWith('/acces/start.php'));
    await click(790, 687);
    assert.equal((await startResponse).status(), 200);
    await page.waitForTimeout(2500);
    await page.keyboard.down('ArrowUp');
    await page.waitForTimeout(3000);
    await page.keyboard.down('ArrowLeft');
    await page.waitForTimeout(1500);
    await page.keyboard.up('ArrowLeft');
    await page.keyboard.up('ArrowUp');
    await screenshot('gameplay');
    await page.waitForTimeout(87000);
    await screenshot('end');
    await click(340, 542);
    await page.waitForTimeout(1500);
    await screenshot('form');
    await click(300, 393);
    await page.keyboard.type(nickname, { delay: 60 });
    const saveResponse = page.waitForResponse(r => r.url().endsWith('/acces/enregistrement_score.php'));
    await click(350, 660);
    const saved = await saveResponse;
    assert.equal(new URLSearchParams(await saved.text()).get('checkInsertion'), 'insertion');
    await page.waitForTimeout(1000);
    await screenshot('saved');
    const rankingResponse = page.waitForResponse(r => r.url().includes('/acces/classement_scores.php'));
    await click(730, 660);
    const ranking = new URLSearchParams(await (await rankingResponse).text()).get('classement');
    assert.ok(ranking.includes(nickname + '#'));
    await page.waitForTimeout(1500);
    await screenshot('hiscores');
    await page.getByRole('button', { name: 'Refresh scores' }).click();
    await page.waitForFunction(name => document.getElementById('scores').textContent.includes(name), nickname);
    assert.deepEqual(errors, []);
    console.log('Verified real round, nickname submission, Flash HISCORES and HTML leaderboard:', nickname);
    const leaderboard = await (await page.request.get(new URL('/api/leaderboard', page.url()).href)).json();
    const entry = leaderboard.scores.find(row => row.nickname === nickname);
    assert.ok(entry && entry.score > 0);
    fs.writeFileSync(path.join(artifacts, 'result.json'), JSON.stringify(entry));
  } finally {
    await browser.close();
  }
})();
