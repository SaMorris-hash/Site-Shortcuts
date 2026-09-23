# Site Shortcuts

A simple, highly accessible Flutter app for saving website shortcuts as large
buttons and opening them in your default browser.

## What's in this folder

This is just the `lib/` source code and `pubspec.yaml` — not a full Flutter
project (no `android/`, `ios/` folders etc). You'll generate those with the
`flutter create` command below, then drop this code in.

## Setup (on your Linux Mint machine)

1. Create a new empty Flutter project and copy these files in:

```bash
cd ~/projects/Flutter
flutter create site_shortcuts
```

2. Delete the generated placeholder files and copy this project's files over:

```bash
rm -rf ~/projects/Flutter/site_shortcuts/lib
cp -r /path/to/downloaded/site_shortcuts/lib ~/projects/Flutter/site_shortcuts/
cp /path/to/downloaded/site_shortcuts/pubspec.yaml ~/projects/Flutter/site_shortcuts/
```

(Replace `/path/to/downloaded/site_shortcuts` with wherever you extracted the
zip I gave you.)

3. **Important — Android 11+ browser fix.** Open
   `android/app/src/main/AndroidManifest.xml` and add this `<queries>` block
   as a direct child of `<manifest>` (a sibling of `<application>`, not
   inside it). Without this, `url_launcher` can silently fail to find a
   browser on newer Android versions:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <queries>
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data android:scheme="https" />
        </intent>
    </queries>

    <application ...>
        ...
    </application>
</manifest>
```

4. Fetch dependencies:

```bash
cd ~/projects/Flutter/site_shortcuts
flutter pub get
```

## Building the APK

```bash
flutter build apk --release
```

The APK will be produced at:

```
build/app/outputs/flutter-apk/app-release.apk
```

Transfer that file to your Nokia C2 (USB cable, email to yourself, cloud
drive, etc.), then tap it on the phone to install. You'll likely need to
allow "install unknown apps" for whichever app you use to open the file
(Settings → Apps → Special access → Install unknown apps).

## Accessibility notes

- Shortcuts are shown as large, high-contrast tappable tiles (not a small
  list), each at least 2x2 finger-width.
- Text sizes are all large by default, and the app does **not** override the
  phone's own font-size / display-size accessibility setting — so if you
  bump up "Large text" in Android's accessibility settings, this app's text
  scales up too.
- Every tile has a screen-reader label ("Open X in browser") for TalkBack
  users.
- Tap the pencil icon (top right) to enter Edit mode, which reveals a red
  remove button on each tile and switches tapping a tile to editing its
  name/address instead of opening it — so accidental deletes/edits can't
  happen while browsing normally.
