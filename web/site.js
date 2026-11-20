// Regisse static site behaviour: theme toggle, scroll reveals, count-up
// numbers, hero chat demo, timeline. Loaded synchronously in <head> so the
// "js" class exists before first paint (CSS only hides .reveal under .js).
(() => {
  const root = document.documentElement;
  root.classList.add('js');

  const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const fr = (root.lang || 'fr').startsWith('fr');

  // ── Theme ──
  const KEY = 'theme';
  const prefersDark = () => window.matchMedia('(prefers-color-scheme: dark)').matches;
  const current = () => root.getAttribute('data-theme') || (prefersDark() ? 'dark' : 'light');
  const applyTheme = (theme) => {
    root.setAttribute('data-theme', theme);
    const b = document.querySelector('.theme-toggle');
    if (!b) return;
    const dark = theme === 'dark';
    b.textContent = dark ? '☀️' : '🌙';
    b.setAttribute('aria-label', fr
      ? (dark ? 'Activer le mode clair' : 'Activer le mode sombre')
      : (dark ? 'Switch to light mode' : 'Switch to dark mode'));
  };
  let saved = null;
  try { saved = localStorage.getItem(KEY); } catch (_) {}
  applyTheme(saved || current());

  document.addEventListener('click', (e) => {
    if (!e.target.closest('.theme-toggle')) return;
    const next = current() === 'dark' ? 'light' : 'dark';
    try { localStorage.setItem(KEY, next); } catch (_) {}
    applyTheme(next);
  });

  const observe = (els, cb, threshold) => {
    if (!('IntersectionObserver' in window)) { els.forEach((el) => cb(el)); return; }
    const io = new IntersectionObserver((entries) => {
      entries.forEach((en) => {
        if (!en.isIntersecting) return;
        io.unobserve(en.target);
        cb(en.target);
      });
    }, { threshold });
    els.forEach((el) => io.observe(el));
  };

  // ── Count-up ──
  const countUp = (el) => {
    const target = parseInt(el.dataset.count, 10);
    if (!Number.isFinite(target)) return;
    const start = performance.now();
    const dur = 1200;
    const tick = (now) => {
      const t = Math.min(1, (now - start) / dur);
      el.textContent = String(Math.round(target * (1 - Math.pow(1 - t, 3))));
      if (t < 1) requestAnimationFrame(tick);
    };
    el.textContent = '0';
    requestAnimationFrame(tick);
  };

  // ── Hero chat demo ──
  const runDemo = (demo) => {
    const bubbles = [...demo.querySelectorAll('.bubble')];
    const typing = demo.querySelector('.typing');
    const wait = (ms) => new Promise((r) => setTimeout(r, ms));
    const loop = async () => {
      bubbles.forEach((b) => b.classList.remove('show'));
      for (const [i, b] of bubbles.entries()) {
        if (!b.classList.contains('me') && typing) {
          typing.classList.add('on');
          demo.appendChild(typing);
          await wait(900);
          typing.classList.remove('on');
        } else {
          await wait(500);
        }
        b.classList.add('show');
        demo.insertBefore(b, typing || null);
        if (i === bubbles.length - 1) break;
      }
      await wait(6000);
      loop();
    };
    loop();
  };

  document.addEventListener('DOMContentLoaded', () => {
    applyTheme(saved || current());
    if (reduced) return; // CSS shows the final state of everything.

    observe([...document.querySelectorAll('.reveal')], (el) => el.classList.add('in'), 0.15);
    observe([...document.querySelectorAll('[data-count]')], countUp, 0.5);
    observe([...document.querySelectorAll('.timeline')], (el) => el.classList.add('in'), 0.3);
    observe([...document.querySelectorAll('[data-demo]')], runDemo, 0.3);
  });
})();
