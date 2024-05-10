import 'package:postgres/postgres.dart';

late Connection? _conn;

Future<Connection> conectarBD() async {
  final conn = await Connection.open(
    Endpoint(
      host: 'localhost',
      database: 'TrainingDB',
      username: 'postgres',
      password: '2609',
      port:     5433
    ),
    settings: ConnectionSettings(sslMode: SslMode.disable),
  );
  print('has connection!');
  return conn;
}

Future<void> cerrarBD() async {
  await _conn?.close();
} 

Future<void> createUser(Connection conn, String email, String password, String nombre, String apellido, String genero, int edad, double altura, double peso) async {
  final createUser = await conn.execute(
    Sql.named(r'INSERT INTO users (email, password, nombre, apellido, genero, edad, altura, peso) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)'),
    parameters: {'email': email, 'password': password, 'nombre': nombre, 'apellido': apellido, 'genero': genero, 'edad': edad, 'altura': altura, 'peso': peso},
  );
  print('Inserted ${createUser.affectedRows} rows');
}

Future<Result?> getUsers(Connection conn) async {
  await conectarBD();
  final result = conn.execute('SELECT * FROM users');
  await cerrarBD();
  return result;
}

Future<void> updateUser(Connection conn, int id, String username, String email, String password) async {
  final updateUser = await conn.execute(
    r'UPDATE users SET notificaciones=$1 WHERE id=$2',
    parameters: [true, 1]
  );
  print(updateUser);
}

Future<void> deleteUser(int id) async {
    final conn = await conectarBD();
    final deleteUser = await conn.execute(
      r'DELETE FROM users WHERE id=$1',
      parameters: [10]
    );
    print(deleteUser);
    await conn.close();
}

void main() async {
  final conn = await Connection.open(
    Endpoint(
      host: 'localhost',
      database: 'TrainingDB',
      username: 'postgres',
      password: '2609',
      port:     5433
    ),
    settings: ConnectionSettings(sslMode: SslMode.disable),
  );
  print('has connection!');

  // Create User
  final createUser = await conn.execute(
    r'INSERT INTO users (email, password, nombre, apellido, genero, edad, altura, peso) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)',
    parameters: ['prueba@gmail.com','@Admin2024','Prueba','Prueba','Masculino',30,1.68,75],
  );
  print('Inserted ${createUser.affectedRows} rows');

  // Get Users
  final getUsers = await conn.execute("SELECT * from users");
  print(getUsers); 

  // Get User by ID
  final getUserbyID = await conn.execute(
    Sql.named('SELECT * FROM users WHERE id=@id'),
    parameters: {'id': 1},
  );
  print(getUserbyID.first.toColumnMap());

  // Update User
  final updateUser = await conn.execute(
    r'UPDATE users SET notificaciones=$1 WHERE id=$2',
    parameters: [true, 1]
  );
  print(updateUser);

  // Delete User
  final deleteUser = await conn.execute(
    r'DELETE FROM users WHERE id=$1',
    parameters: [10]
  );
  print(deleteUser);
  
  // CRUD Functions
  //createUser(conn, 'jdavid42mh93@gmail.com', '@Admin2024', 'Juan', 'Callataxi', 'Masculino', 30, 1.69, 75);

  await conn.close();
}