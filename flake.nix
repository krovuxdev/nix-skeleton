{
  description = "Start Nix projects quickly with this simple template";
  outputs = { self }: {
    templates = {
        rust = {
            path = ./templates/rust;
            description = "A Rust proyect template";
          };
        python = {
            path = ./templates/python;
            description = "A python proyect template";
          };
      };
    defaultTemplate = self.templates.rust;
    #alias
    rs = self.templates.rust;
    py = self.templates.python;
  };
}
