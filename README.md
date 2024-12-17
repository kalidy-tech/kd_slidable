<!-- [![Build][github_action_badge]][github_action] -->
[<img src="https://raw.githubusercontent.com/letsar/flutter_slidable/assets/flutter_favorite.png" width="100" />][flutter_favorite] **Slidable is a [Flutter Favorite][flutter_favorite] package!**

# kd_slidable

A Flutter implementation of slidable list item with directional slide actions that can be dismissed.

## Features

* Accepts start (left/top) and end (right/bottom) action panes.
* Can be dismissed.
* 4 built-in action panes.
* 2 built-in slide action widgets.
* 1 built-in dismiss animation.
* You can easily create custom layouts and animations.
* You can use a builder to create your slide actions if you want special effects during animation.
* Closes when a slide action has been tapped (overridable).
* Closes when the nearest `Scrollable` starts to scroll (overridable).
* Option to disable the slide effect easily.

## Install

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  kd_slidable: <latest_version>
```

In your library add the following import:

```dart
import 'package:kd_slidable/kd_slidable.dart';
```

## Getting started

Example:

```dart
Slidable(
  // Specify a key if the Slidable is dismissible.
  key: const ValueKey(0),

  // The start action pane is the one at the left or the top side.
  startActionPane: ActionPane(
    // A motion is a widget used to control how the pane animates.
    motion: const ScrollMotion(),

    // A pane can dismiss the Slidable.
    dismissible: DismissiblePane(onDismissed: () {}),

    // All actions are defined in the children parameter.
    children: const [
      // A SlidableAction can have an icon and/or a label.
      SlidableAction(
        onPressed: doNothing,
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        widget: Icon(Icons.delete),
        label: 'Delete',
      ),
      SlidableAction(
        onPressed: doNothing,
        backgroundColor: Color(0xFF21B7CA),
        foregroundColor: Colors.white,
        widget: Icon(Icons.share),
        label: 'Share',
      ),
    ],
  ),

  // The end action pane is the one at the right or the bottom side.
  endActionPane: const ActionPane(
    motion: ScrollMotion(),
    children: [
      SlidableAction(
        // An action can be bigger than the others.
        flex: 2,
        onPressed: doNothing,
        backgroundColor: Color(0xFF7BC043),
        foregroundColor: Colors.white,
        widget: Icon(Icons.archive),
        label: 'Archive',
      ),
      SlidableAction(
        onPressed: doNothing,
        backgroundColor: Color(0xFF0392CF),
        foregroundColor: Colors.white,
        widget: Icon(Icons.save),
        label: 'Save',
      ),
    ],
  ),

  // The child of the Slidable is what the user sees when the
  // component is not dragged.
  child: const ListTile(title: Text('Slide me')),
),
```

## Motions

Any `ActionPane` has a motion parameter which allow you to define how the pane animates when the user drag the `Slidable`.

### Behind Motion

The actions appear as if they where behind the `Slidable`:

![Behind Motion][behind_motion]

### Drawer Motion

Animate the actions as if they were drawers, when the `Slidable` is moving:

![Drawer Motion][drawer_motion]

### Scroll Motion

The actions follow the `Slidable` while it's moving:

![Scroll Motion][scroll_motion]

### Stretch Motion

Animate the actions as if they were streched while the `Slidable` is moving:

![Stretch Motion][stretch_motion]

### Controller

You can use ```SlidableController``` to open or close the actions programmatically:

```dart
final controller = SlidableController();

// ...

Slidable(
  controller: controller,
  // ...
);

// ...

// Open the actions
void _handleOpen() {
  controller.openEndActionPane();
  // OR
  //controller.openStartActionPane();
}

void _handleOpen() {
  controller.close();
}
```

## Note

This package is inspired by `flutter_scalable`. I have updated the icon to use a widget. Thank you for your understanding and support.

##

<div style="padding: 20px; border: 1px solid #ddd; background-color: #f9f9f9; border-radius: 5px; text-align: center;">
  <h5 style="color: #333;">Prepared by: Kalidy</h5>
</div>
