import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import "firebase_options.dart";


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0f081a), // cor do banner
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-Vindo ao',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ERUD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff332948), // cor do botão
              ),
              child: Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

// Página de Login
class LoginPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void showErroMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      }
    );
  }

  void signUserIn(String username, String password) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      }
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password
      );
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      showErroMessage(e.code);
    }
  }

  // Defina as constantes de cor aqui
  static const Color corBanner = Color(0xff0f081a);
  static const Color corBranco = Color(0xffffffff);
  static const Color corText = Color(0xff00ff88);
  static const Color corBotao = Color(0xff332948);
  static const Color corH2 = Color(0xff287138);
  static const Color corP = Color(0xffa879d1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corBanner,
      body: Center(
        child: _buildLoginContainer(),
      ),
    );
  }

  Widget _buildLoginContainer() {
    return SingleChildScrollView(
      child: Container(
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
            _buildUsernameField(),
            SizedBox(height: 40),
            _buildPasswordField(),
            SizedBox(height: 50),
            _buildLoginButton('LOGIN'),
            SizedBox(height: 20),
            _buildSignUpButton(), // Colocando o botão de cadastro aqui
            SizedBox(height: 20),
            _buildForgotPasswordButton(), // Colocando o botão de esqueci senha aqui
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldTitle('Usuário'),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _usernameController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFF0F0F0), // Nova cor de preenchimento
              hintText: 'Digite seu usuário',
              hintStyle: TextStyle(color: Colors.grey[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFieldTitle('Senha'),
            SizedBox(width: 20),
          ],
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFF0F0F0), // Nova cor de preenchimento
              hintText: 'Digite sua senha',
              hintStyle: TextStyle(color: Colors.grey[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(String text) {
    return ElevatedButton(
      onPressed: () {
        String username = _usernameController.text;
        String password = _passwordController.text;

        // Verificar se os campos de usuário e senha estão vazios
        if (username.isEmpty || password.isEmpty) {
          // Mostrar um alerta se algum dos campos estiver vazio
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Erro"),
                content: Text("Por favor, preencha todos os campos."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          signUserIn(username, password);
        }
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 1, 224, 35),
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      },
      child: Text(
        'Não tem uma conta? Cadastre-se',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
        );
      },
      child: Text(
        'Esqueceu a senha?',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  // Defina as constantes de cor aqui também
  static const Color corBanner = Color(0xff0f081a);
  static const Color corBranco = Color(0xffffffff);
  static const Color corText = Color(0xff00ff88);
  static const Color corBotao = Color(0xff332948);
  static const Color corH2 = Color(0xff287138);
  static const Color corP = Color(0xffa879d1);

  void _resetPassword(BuildContext context) async {
    final email = _emailController.text;

    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Por favor, insira seu email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Email enviado'),
            content: Text('Um link de recuperação de senha foi enviado para o seu email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text(e.message ?? 'Ocorreu um erro.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corBanner,
      appBar: AppBar(
        title: Text('Esqueceu a senha?'),
        backgroundColor: corBanner,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: corText),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: corText),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corText),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corText),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _resetPassword(context),
              child: Text(
                'Enviar link de recuperação',
                style: TextStyle(color: corBranco),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: corBotao,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Página de Cadastro

const Color corBanner = Color(0xff0f081a);
const Color corBranco = Color(0xffffffff);
const Color corText = Color(0xff00ff88);
const Color corBotao = Color(0xff332948);
const Color corH2 = Color(0xff287138);
const Color corP = Color(0xffa879d1);

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corBanner,
      appBar: AppBar(
        title: Text('Cadastre-se', style: TextStyle(color: corText)),
        backgroundColor: corBanner,
        iconTheme: IconThemeData(color: corText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            _buildTextField('Email', Icon(Icons.email, color: corText), false, _emailController),
            SizedBox(height: 20),
            _buildPasswordField('Senha', Icon(Icons.lock, color: corText), true, _passwordController),
            SizedBox(height: 20),
            _buildPasswordField('Confirmar Senha', Icon(Icons.lock, color: corText), true, _confirmPasswordController),
            SizedBox(height: 50),
            _buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, Widget icon, bool isObscure, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(color: corText),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: corH2),
        icon: icon,
        filled: true,
        fillColor: corBranco,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String labelText, Widget icon, bool isObscure, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(color: corText),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: corH2),
        icon: icon,
        filled: true,
        fillColor: corBranco,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: ()  async {
        String email = _emailController.text;
        String password = _passwordController.text;
        String confirmPassword = _confirmPasswordController.text;

       
       try {    // Verificar se todos os campos estão preenchidos
        if (email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty) {
          // Verificar se as senhas coincidem
          if (password == confirmPassword) { 
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email, 
              password: password);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Erro"),
                  content: Text("As senhas não coincidem."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          // Exibir uma mensagem de erro se algum campo estiver vazio
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Erro"),
                content: Text("Por favor, preencha todos os campos."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
       } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        showDialog(
          context: context,
           builder: (context){
            return AlertDialog(
              content: Text (e.message.toString()),
            );
           }
           );
       }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'CADASTRAR',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: corBranco,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: corBotao,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
// pagina de cursos comprados
class PurchasedCoursesPage extends StatelessWidget {
  final List<String> purchasedCourses;

  PurchasedCoursesPage({Key? key, required this.purchasedCourses})
      : super(key: key);

  // Defina as constantes de cor aqui
  static const Color corBanner = Color(0xff0f081a);
  static const Color corBranco = Color(0xffffffff);
  static const Color corText = Color(0xff00ff88);
  static const Color corBotao = Color(0xff332948);
  static const Color corH2 = Color(0xff287138);
  static const Color corP = Color(0xffa879d1);

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cursos Comprados',
          style: TextStyle(color: corH2), // Aplicando a cor verde ao título na AppBar
        )),
      drawer: _buildDrawer(context),
      body: ListView.builder(
        itemCount: purchasedCourses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              purchasedCourses[index],
              style: TextStyle(color: corText),
            ),
          );
        },
      ),
      backgroundColor: corBranco,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: corBanner,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: corBotao,
                image: DecorationImage(
                  image: AssetImage('assets/menu_background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: corBranco,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.school, color: corText),
              title: Text(
                'Cursos',
                style: TextStyle(color: corText, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                Navigator.pop(context); // Volta para a página inicial
              },
            ),
            Divider(color: corP),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: corText),
              title: Text(
                'Carrinho',
                style: TextStyle(color: corText, fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(cartItems: []),
                  ),
                );
              },
            ),
            Divider(color: corP),
            ListTile(
              leading: Icon(Icons.shopping_bag, color: corText),
              title: Text(
                'Cursos Comprados',
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
              },
            ),
            Divider(color: corP),
            Spacer(), // Empurra o item "Sair" para o fundo
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text(
                'Sair',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Sair"),
                      content: Text("Tem certeza que deseja sair?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Fecha o diálogo
                          },
                          child: Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            ); // Direciona para a página de login e remove todas as rotas anteriores da pilha
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: corBotao,
                          ),
                          child: Text("Sair"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Página Inicial
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _cartItems = [];
  List<String> _purchasedCourses = [];

  // Definindo as constantes de cor aqui
  static const Color corBanner = Color(0xFF0F081A);
  static const Color corBranco = Color(0xFFFFFFFF);
  static const Color corText = Color(0xFF00FF88);
  static const Color corBotao = Color(0xFF332948);
  static const Color corH2 = Color(0xFF287138);
  static const Color corP = Color(0xFFA879D1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Página Inicial',
          style: TextStyle(color: corBranco), // Letras brancas na appbar
        ),
        backgroundColor: corBanner,
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: corBanner,
              child: Center(
                child: Text(
                  'Cursos Disponíveis',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: corBranco, // Letras brancas no título principal
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildCourseList(),
          ],
        ),
      ),
      backgroundColor: corBranco, // Fundo branco
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: corBanner,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: corBotao,
                image: DecorationImage(
                  image: AssetImage('assets/menu_background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: corBranco,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.school, color: corText),
              title: Text(
                'Cursos',
                style: TextStyle(color: corText, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
              },
            ),
            Divider(color: corP),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: corText),
              title: Text(
                'Carrinho',
                style: TextStyle(color: corText, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(cartItems: _cartItems),
                  ),
                );
              },
            ),
            Divider(color: corP),
            ListTile(
              leading: Icon(Icons.shopping_bag, color: corText),
              title: Text(
                'Cursos Comprados',
                style: TextStyle(color: corText, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PurchasedCoursesPage(
                      purchasedCourses: _purchasedCourses,
                    ),
                  ),
                );
              },
            ),
            Divider(color: corP),
            Spacer(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: corText),
              title: Text(
                'Sair',
                style: TextStyle(color: corText, fontSize: 18),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Sair"),
                      content: Text("Tem certeza que deseja sair?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Fecha o diálogo
                          },
                          child: Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text("Sair"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: corBranco, backgroundColor: corBotao, // Cor do texto do botão
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList() {
    // Agrupando os cursos por categoria
    Map<String, List<Map<String, dynamic>>> groupedCourses = {
      'Python': [
        {
          'title': 'Introdução à Programação',
          'image':
              'https://firebasestorage.googleapis.com/v0/b/erudprojeto.appspot.com/o/python.jpeg?alt=media&token=8a4206b0-8b68-4e11-885f-8043e810d0fd',
          'price': 99.99,
        },
        // Adicione mais cursos de Python aqui
      ],
      'JavaScript': [
        {
          'title': 'Desenvolvimento de Aplicativos Móveis',
          'image':
              'https://firebasestorage.googleapis.com/v0/b/erudprojeto.appspot.com/o/javascript.jpeg?alt=media&token=9304e490-e1c7-409e-a7e6-c1068c9d9172',
          'price': 149.99,
        },
        // Adicione mais cursos de JavaScript aqui
      ],
      'Html, Css': [
        {
          'title': 'curso de html e css para iniciantes ',
          'image': 'https://firebasestorage.googleapis.com/v0/b/erudprojeto.appspot.com/o/download.png?alt=media&token=248702b6-5c51-495d-99ec-132122156d05',
          'price': 129.99,
        },
        // Adicione mais cursos de Flutter aqui
      ],
    };

    // Construindo a lista de cursos por categoria
    List<Widget> courseWidgets = [];
    groupedCourses.forEach((category, courses) {
      courseWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: corH2,
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: courses.map((course) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title'],
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Preço: R\$${course['price'].toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    leading: SizedBox(
                      width: 100,
                      child: Image.network(
                        course['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.add_shopping_cart,
                        color: corBotao,
                        size: 32,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirmar"),
                              content: Text(
                                  "Deseja adicionar este item ao carrinho?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancelar"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _cartItems.add(course['title']);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Adicionar ao Carrinho"),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: corBranco, backgroundColor: corBotao,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });

    return Column(
      children: courseWidgets,
    );
  }
}
// pagina do carrinho
class CartPage extends StatefulWidget {
  final List<String> cartItems;

  CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Map<String, double> _coursePrices = {
    'Introdução à Programação': 99.99,
    'Desenvolvimento de Aplicativos Móveis': 149.99,
    'curso de html e css para iniciantes': 129.99, // Adjusted course title
  };

  List<Map<String, dynamic>> _cartCourses = [];

  // Define color constants here
  static const Color corBanner = Color(0xff0f081a);
  static const Color corBranco = Color(0xffffffff);
  static const Color corText = Color(0xff00ff88);
  static const Color corBotao = Color(0xff332948);
  static const Color corH2 = Color(0xff287138);
  static const Color corP = Color(0xffa879d1);

  @override
  void initState() {
    super.initState();
    // Initialize _cartCourses with the courses and their data
    for (String item in widget.cartItems) {
      _cartCourses.add({
        'title': item,
        'image': _getImageForCourse(item),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = _calculateTotalPrice();
    bool canFinalize = widget.cartItems.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
        backgroundColor: corBanner,
      ),
      drawer: _buildDrawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartCourses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: SizedBox(
                    width: 100,
                    child: Image.network(
                      _cartCourses[index]['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(_cartCourses[index]['title'],
                      style: TextStyle(color: corText)),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: Color(0xff00ff88),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${_cartCourses[index]['title']} removido do carrinho.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      setState(() {
                        _removeItemFromCart(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: canFinalize
                      ? () {
                          // Add logic to finalize the purchase
                          setState(() {
                            _finalizePurchase();
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PurchasedCoursesPage(
                                  purchasedCourses: widget.cartItems),
                            ),
                          );
                        }
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    child: Text(
                      'FINALIZAR COMPRA',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: corBranco,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corBotao,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ), // Spacing between button and total text
                Text(
                  'Total: R\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, color: corText),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: corBranco,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: corBanner,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: corBotao,
                image: DecorationImage(
                  image: AssetImage('assets/menu_background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: corBranco,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.school, color: corText),
              title: Text(
                'Cursos',
                style: TextStyle(color: corText, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pop(context); // Return to the home page
              },
            ),
            Divider(color: corP),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: corText),
              title: Text(
                'Carrinho',
                style: TextStyle(color: corText, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            Divider(color: corP),
            ListTile(
              leading: Icon(Icons.shopping_bag, color: corText),
              title: Text(
                'Cursos Comprados',
                style: TextStyle(color: corText, fontSize: 18),
              ),
              onTap: () {
                var _purchasedCourses;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PurchasedCoursesPage(purchasedCourses: _purchasedCourses),
                  ),
                );
              },
            ),
            Divider(color: corP),
            Spacer(), // Pushes "Sair" item to the bottom
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text(
                'Sair',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Sair"),
                      content: Text("Tem certeza que deseja sair?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            ); // Navigate to login page and remove all previous routes from stack
                          },
                          child: Text("Sair"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: corBranco, backgroundColor: corBotao, // Button text color
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    for (String item in widget.cartItems) {
      total += _coursePrices[item] ?? 0.0;
    }
    return total;
  }

  String _getImageForCourse(String title) {
    // Match the title to the corresponding image URL from your data
    switch (title) {
      case 'Introdução à Programação':
        return 'https://firebasestorage.googleapis.com/v0/b/erudprojeto.appspot.com/o/python.jpeg?alt=media&token=8a4206b0-8b68-4e11-885f-8043e810d0fd';
      case 'Desenvolvimento de Aplicativos Móveis':
        return 'https://firebasestorage.googleapis.com/v0/b/erudprojeto.appspot.com/o/javascript.jpeg?alt=media&token=9304e490-e1c7-409e-a7e6-c1068c9d9172';
      case 'curso de html e css para iniciantes': // Adjusted course title
        return 'https://firebasestorage.googleapis.com/v0/b/erudprojeto.appspot.com/o/download.png?alt=media&token=248702b6-5c51-495d-99ec-132122156d05';
      default:
        return ''; // Return a default image URL or handle null case
    }
  }

  void _removeItemFromCart(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
      _cartCourses.removeAt(index);
    });
  }

  void _finalizePurchase() {
    setState(() {
      // Add purchased courses logic here if needed
      widget.cartItems.clear();
      _cartCourses.clear();
    });
  }
}

class CursosCompradosPage extends StatelessWidget {
  final List<String> cursosComprados;

  CursosCompradosPage({Key? key, required this.cursosComprados})
      : super(key: key);

  get _cartItems => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cursos Comprados'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.school, color: Colors.blue),
              title: Text(
                'Cursos',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                // Navega para a página inicial
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: Colors.blue),
              title: Text(
                'Carrinho',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                // Navega para a página do carrinho
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(cartItems: _cartItems),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.article, color: Colors.blue),
              title: Text(
                'Cursos Comprados',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                // Navega para a página de cursos comprados
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CursosCompradosPage(cursosComprados: _cartItems),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text(
                'Sair',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Sair"),
                      content: Text("Tem certeza que deseja sair?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Fecha o diálogo
                          },
                          child: Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Fecha o diálogo
                            Navigator.pop(context); // Fecha o drawer
                            Navigator.pop(
                                context); // Volta para a página anterior
                          },
                          child: Text("Sair"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: cursosComprados.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cursosComprados[index]),
            // Adicione aqui qualquer informação adicional sobre o curso, como preço, por exemplo.
          );
        },
      ),
    );
  }
}
