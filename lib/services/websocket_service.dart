import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class WebSocketService {
  static WebSocket? _socket;
  static final Map<String, List<Function(dynamic)>> _listeners = {};

  static Future<void> connect({
    required String id,
    required String token,
    required bool isSociety,
  }) async {
    String url = isSociety
        ? "ws://10.10.12.111:8000/ws/society"
        : "ws://10.10.12.111:8000/ws/chat";
    if (_socket != null) return;
    try {
      _socket = await WebSocket.connect("$url/$id/?token=$token");

      _socket!.listen(
        (data) => _handleMessage(data),
        onDone: () => log("❌ Socket disconnected"),
        onError: (e) => log("🚨 Socket error: $e"),
      );

      log("✅ WebSocket connected");
    } catch (e) {
      log("🚨 Connection failed: $e");
    }
  }

  static void disconnect() {
    _socket?.close();
    _socket = null;
    _listeners.clear();
    log("👋 Socket closed");
  }

  static bool get isConnected => _socket != null;

  static void _handleMessage(dynamic data) {
    try {
      final decoded = jsonDecode(data);

      if (decoded['type'] != null) {
        final type = decoded['type'];

        if (_listeners.containsKey(type)) {
          for (final fn in _listeners[type]!) {
            fn(decoded['data'] ?? decoded);
          }
        }
      } else {
        if (_listeners.containsKey("message")) {
          for (final fn in _listeners["message"]!) {
            fn(decoded);
          }
        }
      }
    } catch (e) {
      log("⚠️ Parse error: $e");
    }
  }

  static void on(String type, Function(dynamic) handler) {
    _listeners.putIfAbsent(type, () => []);
    _listeners[type]!.add(handler);
  }

  static void off(String type) {
    _listeners.remove(type);
  }

  static void send(Map<String, dynamic> data) {
    if (!isConnected) return;
    _socket!.add(jsonEncode(data));
  }

  static void sendText({required int thread, required String message}) {
    send({
      "type": "message",
      "thread": thread,
      "message_type": "text",
      "content": message,
      "attachment": null,
      "is_like": false,
    });
  }

  static void sendImage({required int thread, required String mediaUrl}) {
    send({
      "type": "message",
      "thread": thread,
      "message_type": "image",
      "content": "",
      "attachment": mediaUrl,
      "is_like": false,
    });
  }

  static void sendLike({required int thread}) {
    send({
      "type": "message",
      "thread": thread,
      "message_type": "text",
      "content": "",
      "attachment": null,
      "is_like": true,
    });
  }

  static void sendRaw(String data) {
    if (!isConnected) return;
    _socket!.add(data);
  }

  static void sendSocietyText({required String message}) {
    send({
      "type": "message.send",
      "payload": {"content": message, "attachment": null},
    });
  }

  static void sendSocietyImage({required String imageUrl}) {
    send({
      "type": "message.send",
      "payload": {"content": "", "attachment": imageUrl},
    });
  }
}
