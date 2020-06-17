import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket;
  final String socketUrl = 'http://192.168.23.8:8000';

  createSocketConnection() {
    socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    this.socket.on("connect", (_) => print('Connected'));
    this.socket.on("disconnect", (_) => print('Disconnected'));
  }

  // instead of String, the 2nd parameter should be of type
  // Object JSON to match the required data from the server
  deliverSocketMessage(String message, String mustBeJson) {
    this.socket.on("connect", (_) => print('Connected'));
    this.socket.emit('msg', 'test');
  }
}
