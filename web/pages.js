// These static pages (SaaS mobile, due diligence, blog, legal) are served
// next to the Flutter app but open in their own tab from the app's header
// links. A plain `<a href="/">` "Accueil" link would then reload the whole
// Flutter app from scratch just to show what the user already had open in
// the other tab. When this page was opened as a new tab (window.opener set,
// or it's the only entry in this tab's history), closing the tab returns
// instantly instead; otherwise the link behaves normally.
document.addEventListener('click', (event) => {
  const link = event.target.closest('a[href="/"]');
  if (!link) return;
  const openedAsNewTab = Boolean(window.opener) || window.history.length <= 1;
  if (!openedAsNewTab) return;
  event.preventDefault();
  window.close();
  // If the tab couldn't be closed (some browsers only allow closing tabs a
  // script itself opened), fall back to a normal navigation.
  setTimeout(() => {
    window.location.href = '/';
  }, 300);
});

// Light/dark toggle: applies a data-theme attribute that overrides the OS
// setting either way (see pages.css), and remembers the choice per visitor.
// Matching the main app's icon convention: the button shows the mode you'd
// switch *to*, not the current one (a moon in light mode, a sun in dark).
(() => {
  const STORAGE_KEY = 'theme';

  const prefersDark = () =>
    window.matchMedia('(prefers-color-scheme: dark)').matches;

  const currentTheme = () =>
    document.documentElement.getAttribute('data-theme') ||
    (prefersDark() ? 'dark' : 'light');

  const applyTheme = (theme) => {
    document.documentElement.setAttribute('data-theme', theme);
    const button = document.querySelector('.theme-toggle');
    if (button) {
      const isDark = theme === 'dark';
      button.textContent = isDark ? '☀️' : '🌙';
      button.setAttribute(
        'aria-label',
        isDark ? 'Activer le mode clair' : 'Activer le mode sombre'
      );
    }
  };

  const saved = localStorage.getItem(STORAGE_KEY);
  applyTheme(saved || currentTheme());

  document.addEventListener('click', (event) => {
    if (!event.target.closest('.theme-toggle')) return;
    const next = currentTheme() === 'dark' ? 'light' : 'dark';
    localStorage.setItem(STORAGE_KEY, next);
    applyTheme(next);
  });
})();
