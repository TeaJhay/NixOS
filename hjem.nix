{inputs, ...}; let
  inherit (findFiles) findFiles;
in {
  hjem.user = {
    teajhay = {
      user = "teajhay";
      directory = "/home/teajhay/"
      clobberByDefault = true; e

      #So thanks to Lorkas and Choco, I learned that unquoted paths are relative 

      files = {
        xdg.config.files = findFiles ./users/teajhay/xdgConfig
        xdg.state.files = findFiles ./users/teajhay/xdgState
        xdg.data.files = findFiles ./users/teajhay/xdgData
        };
      };
    };
  }

