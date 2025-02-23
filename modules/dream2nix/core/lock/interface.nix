{
  config,
  lib,
  ...
}: let
  l = lib // builtins;
  t = l.types;
in {
  imports = [
    (lib.mkRemovedOptionModule ["lock" "repoRoot"] "Use paths.projectRoot instead.")
    (lib.mkRemovedOptionModule ["lock" "lockFileRel"] "Use paths.package instead.")
  ];
  options.lock = {
    # GLOBAL OPTIONS

    content = l.mkOption {
      type = t.submodule {
        freeformType = t.anything;
      };
    };

    fields = l.mkOption {
      type = t.attrsOf (t.submodule [
        {
          options = {
            script = l.mkOption {
              type = t.path;
              description = ''
                A script to refresh the value of this lock file field.
                The script should write the result as json file to $out.
              '';
            };
            default = l.mkOption {
              type = t.nullOr t.anything;
              description = ''
                The default value in case the lock file doesn't exist or doesn't yet contain the field.
              '';
              default = null;
            };
          };
        }
      ]);
      description = "Fields of the lock file";
      default = {};
      example = {
        pname = true;
        version = true;
      };
    };

    refresh = l.mkOption {
      type = t.package;
      description = "Script to refresh the cache file of this package";
      readOnly = true;
    };

    lib.computeFODHash = l.mkOption {
      type = t.functionTo t.path;
      description = ''
        Helper function to write the hash of a given FOD to $out.
      '';
      readOnly = true;
    };
  };
}
