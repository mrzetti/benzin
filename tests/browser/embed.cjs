const { chromium } = require('playwright');
const assert = require('node:assert/strict');
(async () => {
  const browser = await chromium.launch({executablePath:'/root/.cache/ms-playwright/chromium-1228/chrome-linux64/chrome', headless:true, args:['--no-sandbox']});
  try {
    const page = await browser.newPage();
    const errors = [];
    page.on('pageerror', error => errors.push(error.message));
    await page.route('https://embed-test.invalid/', route => route.fulfill({contentType:'text/html', body:'<body style="margin:0"><iframe title="Benzin" src="https://benzin.rammwiki.mrzetti.com/?embed=1" style="width:100%;height:100vh;border:0;display:block" allow="autoplay; fullscreen"></iframe>'}));
    await page.goto('https://embed-test.invalid/');
    await page.frameLocator('iframe').locator('#game').waitFor();
    const gameFrame = page.frames().find(f=>f.url().includes('?embed=1'));
    await gameFrame.waitForFunction(()=>document.getElementById('status').hidden && document.querySelector('ruffle-player'));
    for (const width of [820, 360]) {
      await page.setViewportSize({width,height:680});
      assert.equal(await gameFrame.locator('header').isVisible(), false);
      assert.equal(await gameFrame.locator('.leaderboard').isVisible(), false);
      assert.equal(await gameFrame.getByRole('button',{name:'Fullscreen',exact:true}).isVisible(), true);
      assert.ok(await gameFrame.evaluate(()=>document.documentElement.scrollWidth<=innerWidth && document.documentElement.scrollHeight<=innerHeight));
      await gameFrame.locator('#volume').fill('35');
      assert.ok(Math.abs(await gameFrame.evaluate(()=>document.querySelector('ruffle-player').ruffle().volume)-0.35)<0.001);
    }
    await page.screenshot({path:'/tmp/opencode/benzin-embed.png'});
    assert.deepEqual(errors, []);
    console.log('PASS: cross-site iframe loads, compact layout fits desktop/mobile, volume works. Score submission is not covered.');
  } finally {await browser.close();}
})();
