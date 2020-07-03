import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket;
  final String socketUrl = 'http://192.168.43.184:8000';

  createSocketConnection() {
    socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    this.socket.on("connect", (_) => print('Connected'));
    this.socket.on("disconnect", (_) => print('Disconnected'));
  }

  // instead of String, the 2nd parameter should be of type
  // Object JSON to match the required data from the server
  deliverSocketMessage(String channel, dynamic person) {
    this.socket.emit(channel, person);
    // another emit below for entirelist
  }
}
