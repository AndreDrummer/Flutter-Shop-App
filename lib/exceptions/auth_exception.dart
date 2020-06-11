class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "E-mail já existe!",
    "OPERATION_NOT_ALLOWED": "Operação não permitida.",
    "TOO_MANY_ATTEMPTS_TRY_LATER": "Tente novamente mais tarde.",
    "EMAIL_NOT_FOUND": "E-mail não encontrado.",
    "INVALID_PASSWORD": "Senha Inválida",
    "USER_DISABLED": "Usuário desativado!"    
  };

  AuthException(this.key);

  final String key;

  @override
  String toString() {
    if(errors.containsKey(key)) {
      return errors[key];
    } else {
      return "Ocorreu um erro inesperado!";
    }
  }

}