# Context Menu Positioning Fix

## The Problem

Right-clicking nodes or the canvas background in the flow editor shows context
menus at the **wrong screen position** — shifted to the right by the width of
the app sidebar (~260 px).

## Root Cause

**go_router's `ShellRoute` creates a nested `Navigator`.**

The app uses a `ShellRoute` in `app_router.dart` to wrap all main routes
(including `/flow-editor`) inside `RiveShell`, which renders the sidebar +
content area.  `ShellRoute` internally creates its **own** `Navigator` for child
routes — this Navigator only covers the **content area**, not the full screen.

```
MaterialApp.router
  └─ Router
       └─ Root Navigator  (full screen)
            └─ ShellRoute page
                 └─ RiveShell
                      ├─ Sidebar  (260 px)
                      └─ Shell Navigator  ← covers content area only
                           └─ FlowEditorScreen
                                └─ FlNodeEditorWidget
```

The `fl_nodes` package (and `flutter_context_menu`) shows context menus by
calling:

```dart
Navigator.push(context, PageRouteBuilder(...))
```

where `context` is from inside the editor widget.  `Navigator.of(context)` walks
up and finds the **Shell Navigator**, not the Root Navigator.  The pushed route
only covers the content area.

Meanwhile, `event.position` on a `PointerDownEvent` is always in **global
screen coordinates**.  The menu is rendered with:

```dart
Positioned(left: event.position.dx, top: event.position.dy)
```

inside a `Stack` that fills the Shell Navigator's area.  Since the Stack starts
at x=260 on screen but the position value assumes x=0 is the screen edge, the
menu appears shifted right by 260 px.

### Why it affects ALL fl_nodes menus

`fl_nodes` uses the same `createAndShowContextMenu` helper (in
`fl_nodes/src/widgets/context_menu.dart`) for:

| Menu type       | Triggered by                     | Source file                     |
|-----------------|----------------------------------|---------------------------------|
| Node menu       | Right-click on a node            | `default_node.dart`             |
| Editor menu     | Right-click on canvas background | `node_editor_data_layer.dart`   |
| Port menu       | Right-click near a port          | `node_editor_data_layer.dart`   |
| Create sub-menu | Dragging a link to empty space   | `node_editor_data_layer.dart`   |

All of them call `Navigator.push(context, ...)` with a context inside the Shell
Navigator → all are mis-positioned.

## The Fix (no fork required)

File: `flow_editor_screen.dart`

### 1. Block fl_nodes' menus — `isContextMenuVisible` flag

`fl_nodes` exposes a **top-level global** `bool isContextMenuVisible` in
`package:fl_nodes/src/widgets/context_menu.dart`.  Every
`createAndShowContextMenu` call checks this flag first:

```dart
if (isContextMenuVisible) return;   // bail out
```

We import it as `fl_ctx` and set it to `true` before fl_nodes' handlers fire.

### 2. Transparent `Listener` on top of the `Stack`

A `Listener(behavior: HitTestBehavior.translucent)` is placed as the **last
child** of the Stack that contains `FlNodeEditorWidget`.  In Flutter's hit-test
order, the last Stack child is tested **first**, so our Listener receives the
`PointerDownEvent` **before** fl_nodes' internal `ImprovedListener` widgets.

```dart
Stack(
  children: [
    FlNodeEditorWidget(...),      // fl_nodes editor
    IgnorePointer(WireValueBadges(...)),
    // ... other overlays ...

    // ↓ MUST be last — fires before fl_nodes
    Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        if (event.buttons == kSecondaryMouseButton) {
          _selectionBeforeClick = Set.of(_controller.selectedNodeIds);
          _lastSecondaryPos = event.position;
          fl_ctx.isContextMenuVisible = true;   // block fl_nodes
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _resolveContextMenu());
        }
      },
      child: const SizedBox.expand(),
    ),
  ],
)
```

**Why `HitTestBehavior.translucent`?**  It means our Listener participates in
hit testing (receives events) but does **not** prevent widgets below it from
also receiving events.  Primary clicks, drags, zoom — everything fl_nodes needs
— still works normally.

### 3. Detect what was clicked via selection state

Since the flag blocks fl_nodes' `contextMenuBuilder` callback (it's inside the
same `if (!isContextMenuVisible)` check), we can't rely on it to tell us which
node was right-clicked.  Instead, `_resolveContextMenu()` compares the selection
before and after:

```
Our Listener fires  →  snapshot selection  →  set flag
fl_nodes fires      →  selects the clicked node (happens BEFORE the flag check)
                    →  tries to show menu  →  flag is true  →  bails out
Post-frame          →  compare selection  →  show our menu
```

- **Selection changed + 1 node** → node was right-clicked → show node menu
- **Selection unchanged + 1 node** → re-click on same node → show node menu
- **No node selected** → background click → show editor menu

### 4. Show menus on the Root Navigator

All our replacement menus use Flutter's built-in `showMenu` with
`useRootNavigator: true`:

```dart
showMenu<String>(
  context: context,
  useRootNavigator: true,   // ← pushes onto Root Navigator (full screen)
  position: _menuPosition(globalOffset),
  ...
);
```

`_menuPosition` converts global screen coordinates into a `RelativeRect`
relative to the root overlay, so the menu appears exactly where the user
clicked.

## Known Trade-off

If a node is selected and the user right-clicks the **background**, we show the
node menu (not the editor menu) because we can't distinguish "re-click same
node" from "click background while node is selected" without manual hit-testing.

The user can double-click the canvas to deselect, then right-click for the
editor menu.

## If You Need to Change This

- **Adding menu items**: edit `_showNodeContextMenu` or `_showEditorContextMenu`
  in `flow_editor_screen.dart`.
- **If fl_nodes updates** and renames/moves `isContextMenuVisible`: search for
  the flag in the fl_nodes source — it's a top-level `bool` in
  `lib/src/widgets/context_menu.dart`.
- **If fl_nodes adds `useRootNavigator` support**: the entire workaround can be
  removed — just pass `contextMenuBuilder` normally and let fl_nodes show its
  own menus.
- **If the app stops using `ShellRoute`** (or the sidebar is removed): the
  offset disappears and this fix is no longer needed.
