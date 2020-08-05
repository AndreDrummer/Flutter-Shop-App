import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';

import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  Map<String, String> _authData = {'email': '', 'password': ''};
  final _passwordController = TextEditingController();
  var _authMode = AuthMode.Login;
  bool _isLoading = false;

  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _slideAnimation = Tween(begin: Offset(0, -1.5), end: Offset(0, 0)).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showDialogErrors(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Ocorreu um erro!"),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            child: Text("Fechar"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_keyForm.currentState.validate()) {
      return;
    }

    _keyForm.currentState.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      setState(() {
        _isLoading = true;
      });
      if (_authMode == AuthMode.Signup) {
        await auth.signup(
          _authData["email"].toString().trim(),
          _authData["password"],
        );
      } else {
        await auth.login(
          _authData["email"].toString().trim(),
          _authData["password"],
        );
      }
    } on AuthException catch (error) {
      _showDialogErrors(error.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(16),
        width: deviceSize.width * 0.75,
        height: _authMode == AuthMode.Signup ? 401 : 310,
        // height: _heightAnimation.value.height,
        child: Form(
          key: _keyForm,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _authData['email'] = value,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'E-mail inválido!';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Senha inválida! Informe uma senha maior que 5 caracteres';
                  }
                  return null;
                },
                obscureText: true,
                onSaved: (value) => _authData['password'] = value,
                controller: _passwordController,
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                  maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                      ),
                      validator: (value) {
                        if (_opacityAnimation.value.abs() > 0.9 && value != _passwordController.text) {
                          return 'Senhas não confere';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: const EdgeInsets.all(15),
                child: _isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onPressed: _submit,
                        color: Theme.of(context).primaryColor,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                        child: Text(
                          _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                          style: TextStyle(),
                        ),
                      ),
              ),
              FlatButton(
                child: Text(
                    "${_authMode == AuthMode.Login ? "ALTERNAR P/ REGISTRAR" : "ALTERNAR P/ LOGIN"}"),
                onPressed: _switchAuthMode,
                textColor: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
