import 'package:postgres/postgres.dart';

late Connection? _conn;

Future<void> conectarBD() async {
  _conn = await Connection.open(Endpoint(
    host: 'localhost',
    database: 'postgres',
    username: 'postgres',
    password: '2609',
  ));
  //return _conn!;
}

Future<void> cerrarBD() async {
  await _conn?.close();
} 