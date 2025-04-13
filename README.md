# MapManager – Godot Plugin



**MapManager** is a scene transition manager for [Godot Engine 4.4](https://godotengine.org/), designed to simplify and structure how your project moves between scenes using visual tools and custom nodes.

## Features

-   **ExitNode** – Handles exiting a scene.
-   **SpawnNode** – Manages where and how a new scene is entered.
-   **ConstantNode** – Keeps specific nodes between scene transitions.
-   **GraphEdit Map View** – Easily visualize and connect scene flow.
-   Minimal setup, no custom scripting required for basic usage.

## Installation

1.  Download or clone this repository.
2.  Move the `map_manager` folder into your project's `addons/` directory.
3.  Open your Godot project.
4.  Go to `Project > Project Settings > Plugins` and enable **MapManager**.

## Getting Started

1.  In the editor, open the **GraphEdit** panel and add a **MapNode**.
2.  Load your scene into the MapNode.
3.  MapManager will automatically scan for `ExitNode` and `SpawnNode` instances in the scene.
4.  Connect nodes visually in the graph to define transitions.
5.  Add `ConstantNodes` to mark nodes that should persist across scenes.

## Use Case Example

-   Use `Area2D` or a `Button` with an `ExitNode` child to define an exit point.
-   Define an entry `SpawnNode` in the target scene for where the player (or other object) will appear.
-   Use `ConstantNodes` to keep the player, inventory, or other persistent data between transitions.

## License

This plugin is released under the [MIT License](LICENSE).

## Demo

A demo project is included in the repository to showcase setup and usage.
