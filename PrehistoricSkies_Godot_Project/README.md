# Prehistoric Skies

A self-contained Godot 4 mobile open-world vertical slice. You control a human who can walk, sprint, jump and freely fly across a procedural prehistoric island.

## Included

- Approximately 960 × 960 metre procedural island
- Ground movement, sprinting, jumping and toggleable free flight
- Third-person orbit camera with terrain collision, mouse look and touchscreen look
- Mobile virtual joystick and flight / altitude controls
- Physically modeled sky, dynamic day/night sun, atmospheric fog, ocean and ACES tonemapping
- Procedural vegetation and rocks using MultiMesh for mobile efficiency
- Roaming herbivores, hunting predators and circling pterosaurs built from editable primitive meshes
- Android arm64 export preset suitable for modern Pixel devices
- Desktop keyboard controls for rapid testing

## Controls

### Android / touchscreen
- Left thumb: movement joystick
- Drag right side: camera look
- FLY / LAND: switch movement mode
- UP / DOWN: change altitude during flight
- JUMP: jump while grounded
- BOOST: sprint or high-speed flight

### Desktop
- WASD / arrows: move
- Mouse: look
- Shift: sprint / flight boost
- Space: jump
- F: toggle flight
- E / Q: ascend / descend
- Escape: release or capture mouse

## Open and run

1. Install Godot 4.7.1 or another recent Godot 4 release.
2. Open `project.godot`.
3. Press F6/F5 to run.

The project uses only generated geometry and built-in Godot resources. There are no external asset dependencies.

## Export to Android

1. Install OpenJDK 17 and the Android SDK command-line tools.
2. In Godot, install the matching export templates.
3. Open **Editor → Editor Settings → Export → Android** and set the Java SDK and Android SDK paths.
4. Open **Project → Export → Android**.
5. Export to `build/PrehistoricSkies.apk`.
6. Copy the APK to the Pixel, allow installation from the selected file manager, then install.

For USB deployment, enable Developer Options and USB debugging, connect the phone, then use Godot's one-click remote deploy after the device appears in the editor.

## Realism upgrade path

The gameplay layer is complete for a vertical slice. For photoreal presentation, replace the runtime primitive meshes and flat materials with licensed assets:

- Nanite-style or mobile-optimized scanned cliffs, trees and ground materials
- Rigged human and dinosaur models with animation state machines
- 2K/4K PBR textures compressed to ASTC
- GPU instanced grass and distance impostors
- Spatial audio, creature calls, footsteps and ambient biomes
- Chunk streaming for maps larger than the current one-kilometre island

Keep mobile triangle counts, texture memory, overdraw and shadow distance constrained. A Pixel-class device is capable, but “hyper-realistic” art requires a dedicated asset and optimization pass rather than code alone.
