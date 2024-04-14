{
  description = "Start Nix projects quickly with this simple template";
  outputs = { self }: {
    templates = {
        rust = {
            path = ./templates/rust;
            description = "A Rust proyect template"
          };
      };
    defaultTemplate = self.templates.rust;
  };
}
