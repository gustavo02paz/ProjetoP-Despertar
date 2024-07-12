import 'package:flutter/material.dart';

void main() {
  runApp(LoginApp());
}

class Course {
  final String title;
  final String description;

  Course({required this.title, required this.description});
}

class LoginApp extends StatelessWidget {
  final List<Course> courses = [
    Course(
      title: 'Curso de Flutter',
      description: 'Aprenda a desenvolver aplicativos com Flutter.',
    ),
    Course(
      title: 'Curso de Desenvolvimento Web',
      description: 'Aprenda HTML, CSS e JavaScript para desenvolvimento web.',
    ),
    // Adicione mais cursos conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(courses: courses),
    );
  }
}

class LoginPage extends StatelessWidget {
  final List<Course> courses;

  LoginPage({required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 253, 253),
      body: Center(
        child: _buildLoginContainer(context),
      ),
    );
  }

  Widget _buildLoginContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Login',
            style: TextStyle(
              color: Color.fromARGB(255, 4, 221, 62),
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 40),
          // Adicione seus campos de login aqui
          // Exemplo: _buildUsernameField(),
          //          _buildPasswordField(),
          //          _buildLoginButton('LOGIN'),
          SizedBox(height: 50),
          Text(
            'Cursos Disponíveis:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    courses[index].title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(courses[index].description),
                  onTap: () {
                    // Implemente o que acontece ao clicar em um curso
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
