const { chromium } = require('playwright');
const assert = require('node:assert/strict');

(async () => {
  const browser = await chromium.launch({
    executablePath: '/root/.cache/ms-playwright/chromium-1228/chrome-linux64/chrome',
    headless: true,
    args: ['--no-sandbox', '--autoplay-policy=user-gesture-required'],
  });
  try {
    const page = await browser.newPage({ locale: 'de-DE', viewport: { width: 1000, height: 1000 } });
    await page.goto('https://benzin.rammwiki.mrzetti.com/');
    await page.waitForFunction(() => {
      const player = document.querySelector('ruffle-player');
      return document.getElementById('status').hidden && player?.shadowRoot?.querySelector('#unmute-text');
    });
    const label = page.locator('ruffle-player #unmute-text');
    // Autoplay decisions differ in headless Chromium. Reveal the real overlay
    // to measure its SVG text, independently of the browser's audio policy.
    await page.locator('ruffle-player #unmute-overlay').evaluate(el => el.style.display = 'block');
    assert.equal(await label.textContent(), 'Click to unmute');
    assert.ok(await label.evaluate(el => {
      const box = el.getBBox();
      const view = el.ownerSVGElement.viewBox.baseVal;
      return box.x >= view.x && box.x + box.width <= view.x + view.width;
    }), 'Sound prompt must fit within the SVG');
    await page.screenshot({path:'/tmp/opencode/benzin-unmute-en.png'});
    console.log('German browser: English sound prompt fits within its SVG');
  } finally { await browser.close(); }
})();
