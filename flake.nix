{
  description = "Start Nix projects quickly with this simple template";
  outputs = { self }: {
    templates = {
      rust = {
        path = ./templates/rust/default;
        description = "A Rust proyect template";
        bevy = {
          path = ./templates/rust/engine/bevy;
          description = "A Rust proyect template for bevyengine";
        };
      };
      python = {
        path = ./templates/python;
        description = "A python proyect template";
      };
    };
    defaultTemplate = self.templates.rust;
    #alias
    rs = self.templates.rust;
    "rust#bevy" = self.templates.rust.bevy;
    "rs#bevy" = self.templates.rust.bevy;
    py = self.templates.python;
  };
}
