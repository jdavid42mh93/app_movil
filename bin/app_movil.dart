import 'dart:convert';

import 'package:http/http.dart' as http;
//import './Users/users.dart';
import 'package:postgres/postgres.dart';

late Connection? _conn;
late Connection? conn;

Future<Connection> conectarBD() async {
  _conn = await Connection.open(Endpoint(
    host: 'localhost',
    database: 'postgres',
    username: 'postgres',
    password: '2609',
  ));
  return _conn!;
}

Future<void> cerrarBD() async {
  await _conn?.close();
} 

Future<void> createUser(String username, String email, String password) async {
    final conn = await conectarBD();
    await conn.execute(
        'INSERT INTO users (username, email, password) VALUES (@username, @email, @password)',
        parameters: {'username': username, 'email': email, 'password': password});
    await conn.close();
}

Future<Result?> getUsers() async {
  await conectarBD();
  final result = await conn?.execute('SELECT * FROM users');
  await cerrarBD();
  return result;
}

Future<void> updateUser(int id, String username, String email, String password) async {
    final conn = await conectarBD();
    await conn.execute(
        'UPDATE users SET username = @username, email = @email, password = @password WHERE id = @id',
        parameters: {'id': id, 'username': username, 'email': email, 'password': password});
    await conn.close();
}

Future<void> deleteUser(int id) async {
    final conn = await conectarBD();
    await conn.execute('DELETE FROM users WHERE id = @id', parameters: {'id': id});
    await conn.close();
}

void main(List<String> arguments) async {
  final url = Uri.parse('https://reqres.in/api/users?page=2');
  http.get(url).then((res) {
    final body = jsonDecode(res.body);
    print(body);
  });

  await createUser('usuario1', 'usuario1@example.com', 'contraseña1');
    await getUsers().then((users) {
        print(users);
    });

    await updateUser(1, 'nuevo_usuario', 'nuevo_correo@example.com', 'nueva_contraseña');
    await getUsers().then((users) {
        print(users);
    });

    await deleteUser(1);
    await getUsers().then((users) {
        print(users);
    });
}
