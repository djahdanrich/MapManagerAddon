# MapManager – Godot Plugin
buy me a coffee
[ko-fi](https://ko-fi.com/djahdanrich)

**MapManager** is a scene transition manager for [Godot Engine 4.4](https://godotengine.org/), designed to simplify and structure how your project moves between scenes using a flow chart and custom nodes.

no frills no fancy animations. Just simple game logic. Utilising nodes as children/components of the things you want to control.

## Features
-   **GraphEdit Map View** – Easily visualize and connect scene flow.
-   **ExitNode** – Handles exiting a scene by using the exit_map() function
-   **SpawnNode** – Manages where and how a new scene is entered, choose to have its parents position broadcasted to constants.
-   **ConstantNode** – Keeps specific nodes parents between scene transitions.

-   Minimal setup, no custom scripting required for basic usage.

## Installation

1.  Download or clone this repository.
2.  Move the `MapManager` folder into your project's `addons/` directory.
3.  Open your Godot project.
4.  Go to `Project > Project Settings > Plugins` and enable **MapManager**.

## Getting Started

1.  In the editor, open the **Map Editor** panel by using the tab in the main interface and add a **MapNode**.
2.  Load your scene into the MapNode.
3.  MapManager will automatically scan for `ExitNode` and `SpawnNode` instances in the scene.
4.  Connect nodes visually in the graph to define transitions.
5.  Add `ConstantNodes` to mark nodes that should persist across scenes.
6.  Your graph will auto save on leaving the manager. There are loading and saving popups and a delete data if an error occurs.

## Use Case Example

-   Use any standard way to trigger tested, use an`Area2D` or a `Button` with an `ExitNode` as a child to define an exit point.
-   Define an entry `SpawnNode` in the target scene for where the player (or other object) will appear.
-   Use `ConstantNodes` to keep the player, inventory, or other persistent data between transitions.

## License

This plugin is released under the [MIT License](LICENSE).

## Demo

A demo project is included in the repository to showcase setup and usage.

buy me a coffee
[ko-fi](https://ko-fi.com/djahdanrich)
