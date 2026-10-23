// Offline-first pro jádro appky, síť s časovým limitem pro aktualizace.
const CACHE = 'japan-v19';
const CORE = ['./', 'index.html', 'config.js', 'manifest.webmanifest',
  'vendor/supabase-2.117.2.js', 'vendor/three-r128.min.js', 'vendor/OrbitControls-r128.js',
  'icons/icon-192.png', 'icons/apple-touch-icon.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(CORE.map(u => new Request(u, {cache: 'reload'})))).then(() => self.skipWaiting()));
});
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});

function withTimeout(p, ms) { return Promise.race([p, new Promise((_, rej) => setTimeout(() => rej(new Error('timeout')), ms))]); }

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  const same = url.origin === self.location.origin;
  const fonts = url.hostname.includes('fonts.g');
  if (!same && !fonts) return; // Supabase a ostatní nechat na prohlížeči
  const isVersionCheck = url.searchParams.has('v');
  e.respondWith((async () => {
    const cache = await caches.open(CACHE);
    try {
      const res = await withTimeout(fetch(same ? new Request(url.href, {cache: 'no-cache', credentials: 'same-origin'}) : req), req.mode === 'navigate' ? 4000 : 8000);
      if ((res.ok || res.type === 'opaque') && !isVersionCheck) {
        const key = req.mode === 'navigate' ? 'index.html' : req;
        cache.put(key, res.clone());
      }
      return res;
    } catch (err) {
      const hit = await cache.match(req, {ignoreSearch: true}) || (req.mode === 'navigate' || url.pathname.endsWith('/') ? await cache.match('index.html') : null);
      return hit || Response.error();
    }
  })());
});
