{ pkgs, ... }:

{
  enable = true;
  settings = {
    width = 600;
    height = 400;
    show = "drun";
    prompt = "Search...";
    allow_images = true;
    insensitive = true;
  };
  style = ''
    window {
      background-color: rgba(26, 27, 38, 0.9);
      color: #cdd6f4;
      border-radius: 10px;
    }

    #input {
      margin: 5px;
      border-radius: 5px;
      background-color: rgba(17, 17, 27, 0.9);
      color: #cdd6f4;
    }

    #entry:selected {
      background-color: rgba(137, 180, 250, 0.3);
    }
  '';
}
