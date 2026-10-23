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
