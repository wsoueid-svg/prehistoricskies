# Prehistoric Skies — vertical-slice design

## Core fantasy

The player is an otherwise ordinary human placed in an immense prehistoric ecosystem, with the unexplained ability to fly. Ground traversal provides scale and vulnerability; flight provides freedom, reconnaissance, and rapid movement.

## Current game loop

1. Explore the island on foot.
2. Observe herbivore herds without startling them.
3. Avoid or outfly hunting predators.
4. Toggle flight and survey the ecosystem from altitude.
5. Reach the mountainous interior and track circling pterosaurs.
6. Experience the environment across a dynamic day/night cycle.

## Runtime architecture

- `main.gd` assembles the complete world at runtime.
- `terrain.gd` creates the island mesh, collision, ocean, vegetation, and rocks.
- `player.gd` handles third-person ground/flight movement, camera collision, and procedural body animation.
- `touch_controls.gd` provides the mobile HUD, joystick, look input, and action buttons.
- `creature.gd` provides simple roaming, fleeing, and predator pursuit behavior.
- `flying_creature.gd` provides pterosaur flock movement and wing animation.
- `day_night.gd` advances the sun and lighting cycle.

## Production path to hyper-realism

The code and systems form a playable vertical slice. Photorealism is primarily an art-production and optimization problem. A production build should add:

- Scanned terrain materials with triplanar PBR blending.
- Rigged and motion-captured human locomotion.
- Licensed, anatomically accurate dinosaur and pterosaur models.
- Hierarchical LODs, impostors, chunk streaming, and occlusion volumes.
- Volumetric clouds, weather, water shaders, wetness, and foliage wind.
- Spatialized ecosystem audio and animation-driven footsteps.
- Quest, survival, combat, save, inventory, and world-streaming systems.
- Device quality tiers and frame-time-based dynamic resolution.

The current generated geometry intentionally avoids third-party licensing and keeps the package immediately runnable.
