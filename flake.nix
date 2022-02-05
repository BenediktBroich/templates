{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {

      nodejs = {
        path = ./nodejs;
        description = "Nodejs application template.";
      };

      # tomcat = {
      #   path = ./tomcat;
      #   description = "Tomcat web-app template.";
      # };

      direnv = {
        path = ./direnv;
        description = "Direnv template.";
      };

      nixos-vm = {
        path = ./nixos-vm;
        description = "NixOS VM (nixos-shell) template.";
      };

      hello = {
        path = ./hello;
        description = "Hello World template.";
      };

    };

    defaultTemplate = self.templates.hello;

  };
}
