# Japan 👹 – cestovní appka

Osobní PWA pro cestu po Japonsku (23. 10. – 4. 11. 2026) pro dvě osoby. Hostuje se na GitHub Pages
z větve `main`, každý push se kamarádce po otevření appky sám načte (service worker `sw.js` je network-first).

## Plán (indexy dní 0–12)
0 přílet, noc 9h Hamamatsuchō · 1–3 Pegasus Hotel Yanagibashi (3 je volitelně Ōshima) ·
4–6 dvoudenní trek Nakasendō (Narai → Tsumago → Magome), noci 4 a 5 zatím bez ubytování ·
6–8 Guesthouse Sign Kjóto · 9–11 Ósaka (zatím nezarezervováno) · 12 odlet.
Data sdílená přes index dne (checks `i-j`, hidden `tl:i-k`, places.day) se po přeplánování mohou posunout.

## Struktura
- `index.html` – celá appka v jednom souboru (Three.js r128 z cdnjs, OrbitControls z jsDelivr).
  - `DAYS` – 13 dní (datum, region, přesuny, tipy, co ověřit)
  - `TL` + `TLREF` – časová timeline každého dne, odkazy na místa (`district:index`) nebo dotazy (`q:…`)
  - `CITIES_D` – čtvrti Tokia, Kjóta a Ósaky a jejich místa `[emoji, název, poznámka, [lon, lat]]`
  - `CT` – mapové vrstvy měst (řeky, parky, ulice, linky vlaků, dominanty)
  - `GEO` – pobřeží Japonska (dataofjapan/land) a tokijské linky (mini-tokyo-3d), zjednodušené
  - `STATE` – uživatelská data: vlastní místa, fotky (data URI), checklist, srdíčka (`likes`), wishlist (`wish`)
- `manifest.webmanifest`, `icons/` – instalace na plochu
- `sw.js` – service worker

## Profily
Dva profily bez jmen: `b` = 🧸 modré srdíčko, `p` = 🧜‍♀️ fialové srdíčko. Obě srdíčka = vínové (#722f37).
Aktuální profil je v `localStorage['japan-me']`.

## Stav ukládání – DŮLEŽITÉ
- Srdíčka (`likes`), wishlist (`wish`) a checklist (`checks`) se sdílí přes Supabase: `config.js`
  (URL + anon key), knihovna `vendor/supabase-2.117.2.js`, schéma `supabase-setup.sql`.
  Sync: `initSync()` → `pullAll()` + realtime odběr; zápisy přes `sbWrite()`; lokální cache v `localStorage['japan-state']`.
  Tečka na ikoně profilu: zelená = spojeno, oranžová = chyba/offline.
- Bez vyplněného `config.js` běží vše jen lokálně v telefonu.
- Vlastní místa (`places`, sloupec `who` = kdo přidal) a vyřazené body itineráře (`hidden`, klíče `tl:den-index`) se sdílí taky (krok 2 v `supabase-setup.sql`). Když tabulky chybí, `SB_PLACES=false` a místa zůstanou lokální.
- Fotky jsou zatím JEN lokální (localStorage).

## Další kroky
1. Sdílet fotky (Supabase Storage místo data URI).
2. Odstranit zbytky artifact režimu (`SKEL`, `buildDoc`, `ART`, přeposílání přes `trip-src`).
3. Skutečné fotky míst (např. Wikimedia Commons API) a volitelně skutečná mapa (MapLibre + OSM dlaždice).
4. Rozdělit `index.html` na moduly, až to bude potřeba.

## Pravidla
- Texty v appce česky, bez jmen (profily jen emoji a barvy).
- Mobil je hlavní zařízení; testuj šířku ~400 px a iPhone safe-area.
- Polohy míst jsou zadané ručně, ověřuj je.
