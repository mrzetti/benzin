const {chromium}=require('playwright');
const assert=require('node:assert/strict');
(async()=>{
const browser=await chromium.launch({executablePath:'/root/.cache/ms-playwright/chromium-1228/chrome-linux64/chrome',headless:true,args:['--no-sandbox','--autoplay-policy=no-user-gesture-required']});
try {
const page=await browser.newPage({viewport:{width:1000,height:1000}});
const errors=[];page.on('pageerror',e=>errors.push(e.message));
await page.goto('https://benzin.rammwiki.mrzetti.com/');
await page.waitForTimeout(7000);
const rect=await page.locator('#game').boundingBox();
async function click(x,y){await page.mouse.click(rect.x+x*rect.width/600,rect.y+y*rect.height/450);await page.waitForTimeout(1000)}
await page.screenshot({path:'/tmp/opencode/benzin-intro-en.png'});
await click(540,420);
await click(520,420);
await page.screenshot({path:'/tmp/opencode/benzin-menu-en.png'});
await click(150,300);
await page.screenshot({path:'/tmp/opencode/benzin-instructions-en.png'});
await click(460,422);
await page.keyboard.down('ArrowUp');
await page.waitForTimeout(1500);
await page.keyboard.up('ArrowUp');
await page.screenshot({path:'/tmp/opencode/benzin-playing-en.png'});
await page.waitForTimeout(92000);
await page.screenshot({path:'/tmp/opencode/benzin-gameover-en.png'});
assert.deepEqual(errors,[]);
}finally{await browser.close()}
})();
