# Install and run on a Google Pixel

This package is a complete Godot project. It can be opened, run, edited, and exported directly on a recent Android phone.

## Fastest route: run inside Godot on the Pixel

1. Install **Godot Engine 4.7.1** for Android from Google Play or the official Godot Android download page.
2. Download `PrehistoricSkies_Godot_Project.zip` to the phone and extract it with Files by Google.
3. Open Godot and grant file access when requested.
4. Select **Import**, browse to the extracted folder, and choose `project.godot`.
5. Select **Import & Edit**.
6. Tap the play triangle in the editor.
7. Hold the phone in landscape orientation.

The project has no external asset downloads and generates the world on launch. The first launch can pause briefly while the terrain collision and vegetation instances are created.

## Create a standalone APK on the Pixel

1. Open the project in the Android editor.
2. Open **Project → Export**.
3. Select the included **Android** preset.
4. Choose a debug export for personal testing.
5. Export to `build/PrehistoricSkies.apk`.
6. Approve Android's install-from-this-source permission if prompted, then install the APK.

If Godot requests an Android build environment for a Gradle export, install the official **Godot Android Build Environment (GABE)** companion. This project defaults to the simpler non-Gradle export path.

## Desktop-to-Pixel route

1. Install Godot 4.7.1 on Windows, macOS, or Linux.
2. Install matching Godot export templates, OpenJDK 17, and the Android SDK.
3. Open `project.godot` and run it once on desktop.
4. Connect the Pixel by USB with Developer Options and USB debugging enabled.
5. Use Godot's remote deploy button, or export `build/PrehistoricSkies.apk` and copy it to the phone.

## Troubleshooting

- **Black screen for several seconds:** allow the procedural terrain to finish generating. Close other heavy apps if memory is constrained.
- **No touch movement:** start the game in landscape and touch the lower-left region to place the movement joystick.
- **Camera will not move:** drag on an empty area on the right half of the screen, not over a button.
- **APK export unavailable:** install the matching export templates or GABE as requested by the Android editor.
- **Low frame rate:** reduce `resolution`, tree count, rock count, and creature counts in `scripts/terrain.gd` and `scripts/main.gd`.
