
# Peer Drop - P2P Mesh Offline Communication (Flutter)

Peer Drop is an **offline, peer-to-peer (P2P) mesh communication system** . It enables devices to discover each other and communicate reliably without the need for the internet or centralized servers.

This project focuses on creating a **resilient, reliable, and secure mesh network over Wi-Fi or Bluetooth**, empowering offline communication even in **disconnected or disaster-prone environments**.

---

## ✨ Features

- 🔗 **P2P Mesh Network:** Devices form a local mesh and relay messages reliably.
- 📶 **Offline-first:** Fully functional without internet using local Wi-Fi/Bluetooth.
- 📡 **Device Discovery:** Auto-discovers nearby devices.
- 🔒 **Secure & Encrypted Communication:** Ensures privacy using encryption.
- 📁 **File & Message Transfer:** Supports text messages, files, and media.
- 🔄 **Reliable Delivery:** Implements store-and-forward mechanisms for offline nodes.
- 🌐 **Cross-platform Flutter App:** Works on Android, iOS, Desktop (WIP).



## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Android/iOS device or emulator
- Nearby devices on the same local network or Bluetooth enabled

### System Diagram

![Screenshot 2025-05-14 180458](https://github.com/user-attachments/assets/d5638976-b622-4823-a1dd-6a1afed9c883)

![Screenshot 2025-05-14 180551](https://github.com/user-attachments/assets/d4eb8247-cb6b-4de4-b376-44de13ccf87a)


### 📐System Architecture 

```plaintext
+---------------------------------------------------------+
|                      Peer Drop App (Flutter)            |
+---------------------------------------------------------+
|                                                         |
|  UI Layer (Flutter Widgets)                             |
|  - Chat Interface                                        |
|  - File Transfer UI                                      |
|  - Device Discovery Screen                               |
|                                                         |
+---------------------------------------------------------+
|                                                         |
|  Core Communication Layer                                |
|  - P2P Manager (Discovery, Connection Management)        |
|  - Session Handler (Message/File Sessions)               |
|  - Mesh Routing Handler (Forwarding, Queuing)            |
|                                                         |
+---------------------------------------------------------+
|                                                         |
|  Network Layer                                           |
|  - WebRTC DataChannels / Bluetooth Sockets / Wi-Fi P2P   |
|  - Custom Mesh Protocol over Data Channels               |
|                                                         |
+---------------------------------------------------------+
|                                                         |
|  Device OS Layer (Android, iOS)                          |
|  - Bluetooth APIs, Wi-Fi APIs, Permissions               |
|                                                         |
+---------------------------------------------------------+

         <=== Mesh Network formed dynamically between devices ===>
   
  [Device A]  <---->  [Device B]  <---->  [Device C]  <---->  [Device D]
       |                 |                  |                  |
       |----Relay Msg----|----Forward Msg---|----Relay Msg-----|
       |----File Share---|----File Forward--|----File Share----|
```


### ✔ Key Flow:

1. **Device Discovery**

   * Uses Bluetooth/Wi-Fi P2P APIs.
   * Creates dynamic peer lists.

2. **Connection Establishment**

   * Establishes P2P channels (WebRTC DataChannel or Bluetooth Socket).
   * Encrypts sessions.

3. **Message/File Handling**

   * Messages are packaged and sent over the mesh.
   * If direct delivery fails, nodes **store and forward** later.

4. **Mesh Management**

   * Routing logic ensures messages/files take the best route.
   * Nodes act as relays if needed.

5. **Offline Resilience**

   * If any node goes offline, others continue the mesh.
   * Queues pending messages until the recipient is reachable.

---


### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/rohansnishad/Peer-Drop.git
   cd Peer-Drop
   ````

2. Get dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```


### Notes

* Ensure devices are on the same Wi-Fi network or Bluetooth is enabled.
* Permissions for location, storage, and Bluetooth might be required.

---

## 🤝 Contribution

Contributions, issues, and feature requests are welcome!

1. Fork the project
2. Create your feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'Add your feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request

---


## 📢 Acknowledgements

* Flutter community
* P2P Networking resources
* WebRTC and Mesh network open-source projects




