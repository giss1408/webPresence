// Loading screen behaviour, kept out of index.html so the CSP needs no
// 'unsafe-inline' for scripts. Loaded right after the #splash markup.
(function () {
  // Width of the typed brand text, for the splash typing animation.
  var brand = document.querySelector('#splash .text');
  document.querySelector('#splash .logo').style.setProperty('--w', brand.scrollWidth + 'px');
  var slowTimer = setTimeout(function () {
    document.getElementById('slow').classList.add('shown');
  }, 8000);
  window.addEventListener('flutter-first-frame', function () {
    clearTimeout(slowTimer);
    var splash = document.getElementById('splash');
    splash.classList.add('hidden');
    setTimeout(function () { splash.remove(); }, 400);
  });
})();
