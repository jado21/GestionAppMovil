class FormatHelpers {
  FormatHelpers._();

  static String formatTipoClase(String tipo) {
    switch (tipo.toLowerCase().trim()) {
      case '1':
      case 'teoria':
      case 'teoría':
        return 'Teoría';
      case '3':
      case 'laboratorio':
        return 'Laboratorio';
      case '2':
      case 'practica':
      case 'práctica':
        return 'Práctica';
      default:
        return tipo.isEmpty ? '-' : tipo;
    }
  }

  static String formatAula(String aula, {bool conPrefijo = false}) {
    if (aula == '0' || aula.trim().isEmpty || aula.toLowerCase() == 'none') {
      return 'Sin asignar';
    }
    return conPrefijo ? 'Aula $aula' : aula;
  }

  static String formatDocente(String docente) {
    final normalized = docente.trim().toLowerCase();
    if (normalized.isEmpty ||
        normalized == 'none' ||
        normalized == 'es none') {
      return 'Sin asignar';
    }
    return docente
        .split(' ')
        .map((palabra) => palabra.isEmpty
            ? ''
            : palabra[0].toUpperCase() + palabra.substring(1).toLowerCase())
        .join(' ');
  }
}
