# Nilgiri College splash app

This Flutter app displays the Nilgiri College logo on a branded splash screen and
opens the college portal at `http://192.168.4.254:30013`.

## Download the logo with a terminal

From the repository root, run:

```bash
mkdir -p nilgiri/assets/images
curl -fL --output nilgiri/assets/images/nilgiri_college_logo.png \
	https://nilgiricollege.ac.in/images/nilgiri_college_logo.png
```

Then install dependencies and run the app:

```bash
cd nilgiri
flutter pub get
flutter run
```

The downloaded image is declared in `pubspec.yaml` and used by
`lib/main.dart`. The attribution is displayed on the splash screen as
**co-developed with Nihal PM**; edit that line in `_SplashScreenState` if you
want to change its wording or placement.

The portal address is defined near the top of `_SplashScreenState` as
`portalUri`. Change it there if the local server address changes.