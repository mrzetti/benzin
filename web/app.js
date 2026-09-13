const container = document.getElementById('game');
const status = document.getElementById('status');
let player;
const controls = createTouchControls({
  host: container, toggle: document.getElementById('touch-toggle'),
  keys: [['ArrowLeft', '← Left'], ['ArrowRight', 'Right →'], ['ArrowDown', '↓ Brake'], ['ArrowUp', '↑ Gas']],
  send(code, down, keyboardButton) {
    if (!player) return;
    if (down && !keyboardButton) player.focus({preventScroll:true});
    const keyCode = {ArrowLeft:37, ArrowUp:38, ArrowRight:39, ArrowDown:40}[code];
    player.dispatchEvent(new KeyboardEvent(down ? 'keydown' : 'keyup', {
      key:code, code, keyCode, which:keyCode, bubbles:true, cancelable:true,
    }));
  },
});
// Keep the toggle available in the compact view's toolbar too.
document.querySelector('.toolbar').append(document.getElementById('touch-toggle'));
const volume = document.getElementById('volume');
function applyVolume() {
  document.getElementById('volume-value').value = `${volume.value}%`;
  if (player) player.ruffle().volume = volume.value / 100;
}
volume.addEventListener('input', applyVolume);

async function startGame() {
  controls.releaseAll();
  status.hidden = false;
  status.textContent = 'Loading the game…';
  try {
    const session = await fetch('/api/session', { method: 'POST' });
    if (!session.ok) throw new Error('Could not initialize player profile');
    player = window.RufflePlayer.newest().createPlayer();
    document.getElementById('game-screen').replaceChildren(player);
    applyVolume();
    await player.ruffle().load({
      url: '/benzin-community-en-v2.swf',
      autoplay: 'on',
      unmuteOverlay: 'visible',
      backgroundColor: '#000000',
      letterbox: 'on',
      allowScriptAccess: false,
      openUrlMode: 'confirm',
      upgradeToHttps: true,
    });
    // Ruffle 0.6 chooses this SVG label from navigator.languages rather than
    // the page language. Its longer German label is clipped by the SVG bounds.
    const unmuteText = player.shadowRoot?.querySelector('#unmute-text');
    if (unmuteText) unmuteText.textContent = 'Click to unmute';
    status.hidden = true;
    applyVolume();
  } catch (error) {
    console.error('Unable to load Benzin', error);
    status.textContent = 'The game could not load. Please try restarting it or refreshing this page.';
  }
}

document.getElementById('restart').addEventListener('click', startGame);
document.getElementById('fullscreen').addEventListener('click', async () => {
  try {
    if (document.fullscreenElement) await document.exitFullscreen();
    else await container.requestFullscreen();
  } catch {
    status.hidden = false;
    status.textContent = 'Fullscreen is unavailable in this browser.';
  }
});
startGame();

async function refreshScores() {
  const list = document.getElementById('scores');
  const message = document.getElementById('scores-status');
  try {
    const response = await fetch('/api/leaderboard');
    if (!response.ok) throw new Error('Leaderboard request failed');
    const data = await response.json();
    list.replaceChildren();
    data.scores.forEach((entry, index) => {
      const row = document.createElement('tr');
      [index + 1, entry.nickname, entry.score.toLocaleString()].forEach(value => {
        const cell = document.createElement('td');
        cell.textContent = value;
        row.append(cell);
      });
      list.append(row);
    });
    message.textContent = data.players ? `${data.players} player${data.players === 1 ? '' : 's'} · Top 100 personal bests` : 'The leaderboard is open. Finish a round and be the first to submit a score!';
  } catch {
    message.textContent = 'The leaderboard could not load. Please try Refresh scores.';
  }
}
document.getElementById('refresh-scores').addEventListener('click', refreshScores);
if (!document.documentElement.classList.contains('embed')) refreshScores();
