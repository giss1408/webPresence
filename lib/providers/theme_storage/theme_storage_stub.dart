/// Non-web builds: nothing is remembered, and the system setting is unknown.
String? readSavedTheme() => null;

void saveTheme(String theme) {}

bool systemPrefersDark() => false;
