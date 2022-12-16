import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket;
  final String socketUrl = 'http://192.168.23.8';

  createSocketConnection() {
    socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    this.socket.on("connect", (_) => print('Connected'));
    this.socket.on("disconnect", (_) => print('Disconnected'));
  }

  // emit person json to socket
  deliverSocketMessage(String channel, dynamic person) {
    this.socket.emit(channel, person);
  }
}
