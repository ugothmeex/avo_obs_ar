# ![](obs_godot_icon.png) OBS Websocket GD

A Godot addon to interact with [obs-websocket](https://github.com/Palakis/obs-websocket). Tested on Godot 4.0.2.

## Game/App Quickstart
1. Install [obs-websocket](https://github.com/Palakis/obs-websocket) for your platform. Recent distributions of OBS should come with obs-websocket already included
2. Configure obs-websocket in OBS and set the password to something of your choosing
3. Clone this project
4. Add the `addons/obs-websocket-gd/obs_websocket.gd` node to your scene
5. By default, the addon tries to connect to `localhost:4455` with a password of `password`. Change the password in `addons/obs_websocket_gd/obs_websocket.gd` to the password set in step 2. The variables are exported for convenience
6. (OPTIONAL) Connect some listener to the `data_received(update_data)` signal in `obs_websocket.gd`. `data_received` outputs an `ObsMessage` data structure. This data structure stores the raw response and also maps the data to the expected OpCode fields.
7. Call `establish_connection()` on the `obs_websocket.gd` node to connect to obs-websocket. The `connection_established`, `connection_authenticated`, and `connection_closed` signals are available to connect to
8. Call the `send_command(command: String, data: Dictionary = {})` method on the `obs_websocket.gd` instance. Reference the [obs-websocket protocol](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md) to find out what commands + data to send.

