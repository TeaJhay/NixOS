{self, inputs, lib, ...}: let
findFiles = import ./findFiles.nix {inherit lib;}; 
in
{
  hjem = {
    clobberByDefault = true; 
    users = {
      teajhay = {
        user = "teajhay";
        directory = "/home/teajhay/";

        #So thanks to Lorkas and Choco, I learned that unquoted paths are relative to nix files, quoted are absolute but if referencing something outside the setup, is impure. Thanks to Connor an Squirrel for explaining impurity and making sure I had the right idea about paths and linking.
 #       files = {
          xdg.config.files = findFiles "${self}/users/teajhay/xdgConfig";
 #         xdg.state.files = findFiles "${self}/users/teajhay/xdgState";
 #         xdg.data.files = findFiles "${self}/users/teajhay/xdgData";
#          };
        };
       };
  };
}
