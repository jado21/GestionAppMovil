class FormatHelpers {
  FormatHelpers._();

  static String formatTipoClase(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'teoria':
      case 'teoría':
        return 'Teoría';
      case 'laboratorio':
        return 'Laboratorio';
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
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
