import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String _usernameError = '';
  String _passwordError = '';
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;

  // Dummy database
  final Map<String, String> _dummyDb = {
    'admin': 'admin123',
    'user1': 'password1',
    'user2': 'password2',
  };

  // Handle login action
  void _handleLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    setState(() {
      _usernameError = ''; // Clear previous errors
      _passwordError = ''; // Clear previous errors
    });

    // Validate the fields
    if (username.isEmpty && password.isEmpty) {
      setState(() {
        _usernameError = 'Username is required';
        _passwordError = 'Password is required';
      });
    } else if (username.isEmpty) {
      setState(() {
        _usernameError = 'Username is required';
      });
    } else if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
    } else {
      // Start the button animation when clicking the login button
      _animationController.forward();
      
      // Check credentials against dummy database
      if (_dummyDb.containsKey(username) && _dummyDb[username] == password) {
        // Login successful
        print('Login successful!');
      } else {
        // Login failed
        _showErrorPopup('Invalid username or password.');
      }
    }
  }

  // Show error popup with animation control
  void _showErrorPopup(String message) {
    _animationController.reverse(); // Reverse the animation when the popup appears
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
                _animationController.forward(); // Bring the login elements back
              },
              child: const Text('OK', style: TextStyle(color: Color(0xFF0D47A1))),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Button animation (scale effect)
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animations on page load
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Split background
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(color: Colors.white),
              ),
              Expanded(
                flex: 1,
                child: Container(color: const Color(0xFF0D47A1)), // Dark blue color
              ),
            ],
          ),
          // Curved shape at the bottom left
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFF0D47A1), // Dark blue color
                borderRadius: BorderRadius.only(topRight: Radius.circular(200)),
              ),
            ),
          ),
          // Enlarged blue portion at the top right
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xFF0D47A1), // Dark blue color
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(300)),
              ),
            ),
          ),
          // Admin login form
          Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Container(
                  width: 600,
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Admin login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Username',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: const Color(0xFF0D47A1),
                              width: 2.0,
                            ),
                          ),
                        ),
                        onEditingComplete: () {
                          _usernameFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(_passwordFocusNode);
                          _animationController.reverse(); // Reset animation when clicking on text field
                        },
                      ),
                      if (_usernameError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _usernameError,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      const SizedBox(height: 16),
                      const Text(
                        'Password',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        focusNode: _passwordFocusNode,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: const Color(0xFF0D47A1),
                              width: 2.0,
                            ),
                          ),
                        ),
                        onEditingComplete: _handleLogin,
                      ),
                      if (_passwordError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _passwordError,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ScaleTransition(
                        scale: _buttonScaleAnimation,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D47A1),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Logo
          Positioned(
            left: 16,
            top: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/logo.png',
                width: 50,
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
