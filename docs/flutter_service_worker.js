'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "3cf509070087823a8b4db17fc723f6af",
"assets/assets/background/clouds/clouds0.jpg": "ab6e55271db5c415900126798f6cc6ae",
"assets/assets/background/clouds/clouds1.jpg": "86e3a09583a9f5f3e0c47bec0b6b2159",
"assets/assets/background/clouds/clouds1_alt.jpg": "e687f049c5e5cebaa838a85b2b6e1b57",
"assets/assets/background/clouds/clouds2.jpg": "aca2fbeb4eb09cc9bfe18e6b5694604b",
"assets/assets/background/clouds/clouds3.jpg": "267fe18d6750a34e3d3047354f71d338",
"assets/assets/background/clouds/clouds4.jpg": "98d5550fe693547d21c1abd927196796",
"assets/assets/background/clouds/clouds5.jpg": "7a95e97e9925900cba040038f358c715",
"assets/assets/background/clouds/clouds6.jpg": "bc86ff53068c04bd8b5a5499773659b3",
"assets/assets/icon/icon.png": "8fe0b0379815db161c63e00f1206b6c9",
"assets/assets/icon/icon_green.png": "062304451ebd8d069b2e89f8b8587bd4",
"assets/assets/icon/icon_orange.png": "732d9881e62d423740e42cf323255995",
"assets/assets/icon/icon_teal.png": "b0ffe50692a67977ff75e844e7553664",
"assets/assets/icon/icon_white.png": "322aacf3abf82dc0dd81462d630040ff",
"assets/assets/icon/icon_white_shadow.png": "0f60387f5b51d56ffaeb8be487c0c591",
"assets/assets/icon/ios_icon.png": "eb6d2172c0fd4577185ab77c6af73e93",
"assets/assets/svg/pausenkorrektur.svg": "f45b706347f24ec44ddcd3fa98e4b3de",
"assets/assets/svg/pausenkorrektur_klein.svg": "3d9325d9d6bfa2cb2810d4ccb1fbeebc",
"assets/assets/Toki/Toki_happy_1.svg": "0323eb3d010f3a45413612a2ada2bdc7",
"assets/assets/Toki/Toki_happy_1_white.svg": "009fdcc0537eb6a735ac668a3de49e49",
"assets/FontManifest.json": "27306406a6d7281aa19decd29bb23245",
"assets/fonts/BandeinsSansBold.otf": "bf0a6068df2b038b9eaa0dc2e504ee08",
"assets/fonts/BandeinsSansRegular.otf": "4d06ee2e54781edb08c4ff6dd9f68e16",
"assets/fonts/BandeinsSansSemiBold.otf": "1df521bd2f36fa680e4e892241ca19a5",
"assets/fonts/BandeinsStrangeBoldExtendedHalf.ttf": "2588dd57b7a4be8d920f5c3245800332",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/fonts/RobotoMono-Regular.ttf": "e5ca8c0ac474df46fe45840707a0c483",
"assets/fonts/RobotoMono-SemiBold.ttf": "2a12618b6d46fd798157e4b9d29cdf06",
"assets/NOTICES": "c2c9de22c42fb8814172ea4b78930cd4",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/day_night_time_picker/assets/moon.png": "71137650ab728a466a50fa4fa78fb2b9",
"assets/packages/day_night_time_picker/assets/sun.png": "5fd1657bcb73ce5faafde4183b3dab22",
"favicon.png": "3af8646e02d2b07be4239dd7b58ceb69",
"icons/Icon-192.png": "8d4cf2c26ecfd3905c3f07aa1ee2539b",
"icons/Icon-512.png": "3af8646e02d2b07be4239dd7b58ceb69",
"index%20copy.html": "eff8ef82daf90caa3800aeffe12c07ae",
"index.html": "e4082d94b0081b4513a1177a881a49e0",
"/": "e4082d94b0081b4513a1177a881a49e0",
"main.dart.js": "49003da960ec234abf751f2d78ea7dff",
"manifest.json": "1535c5c00829d1eac1697b8527884156",
"splash/img/dark-1x.png": "01c6947ab4b59d161c8266ab3c6d66ef",
"splash/img/dark-2x.png": "0efc66c8458e666336311a7867f5bde0",
"splash/img/dark-3x.png": "6c86d343ada7d185e8f07d08fe5755e0",
"splash/img/light-1x.png": "01c6947ab4b59d161c8266ab3c6d66ef",
"splash/img/light-2x.png": "0efc66c8458e666336311a7867f5bde0",
"splash/img/light-3x.png": "6c86d343ada7d185e8f07d08fe5755e0",
"splash/style.css": "ad60fc9fe23602f856d2763cf39d2004",
"version.json": "9ea432a23d53b855e92017f20cea5fe9"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
