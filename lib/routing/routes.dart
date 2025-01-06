enum AppRoutes {
  signin('/signin', 'signin'),
  home('/home', 'home'),
  ;

  const AppRoutes(this.path, this.name);

  final String path;
  final String name;
}
