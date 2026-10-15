// Offline play (#624): register the service worker that precaches the game
// shell. A failure only means no offline copy; the game itself is unaffected.
if ('serviceWorker' in navigator && location.protocol !== 'file:') {
  navigator.serviceWorker.register('sw.js').catch(() => {});
}
