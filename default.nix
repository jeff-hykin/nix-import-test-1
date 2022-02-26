let 
    pinnedNixVersion = "8917ffe7232e1e9db23ec9405248fd1944d0b36f"; # this is a hash of a specific commit
    pinnedNix = (builtins.import 
        (builtins.fetchTarball
            ({
                url=''https://github.com/NixOS/nixpkgs/archive/8917ffe7232e1e9db23ec9405248fd1944d0b36f.tar.gz'';
            })
        )
        ({
            config = {
                allowUnfree = true;
            };
        })
    );
in
    # exports a funciton, the arguments are things that importers can override if needed
    {
        pkgs ? pinnedNix
    }:
        let
            output = rec {
                howdy = true;
                packages = pkgs;
            };
        in 
            output
