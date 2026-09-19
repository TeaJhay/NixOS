{ pkgs, ... }: {
  hjem.users.teajhay.xdg.config.files = {
    "jj/config.toml" = {
      generator = (pkgs.formats.toml { }).generate "config.toml";
      value = {
        aliases = {
          pull-pr = {
            definition = [
              "util"
              "exec"
              "--"
              "bash"
              "-c"
              "set -euo pipefail; git fetch $0 pull/$1/head:$2"
            ];
            doc = "A convenient alias to pull a pr $1 from remote $0 into branch $2";
          };
        };
        signing = {
          backend = "gpg";
          key = "F6928ABB9CBF3877";
        };
        template-aliases = {
          "format_short_signature(signature)" = ''
            coalesce(signature.name(), name_placeholder)
          '';
        };
        revsets = {
          log = "present(@) | ancestors(immutable_heads().., 10) | trunk()";
        };
        ui = {
          default-command = "log";
          diff-editor = ":builtin";
          editor = "nvim";
          merge-editor = ":builtin";
        };
        merge-tools = {
          kitty-diff = {
            program = "kitten";
            diff-args = [
              "diff"
              "$left"
              "$right"
            ];
          };
        };
        user = {
          name = "Teajhay";
          email = "140999577+TeaJhay@users.noreply.github.com";
        };
      };
    };
  };
}
