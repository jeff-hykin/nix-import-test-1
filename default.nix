{
    # Make sure to enable config.allowUnfree to the instance of nixpkgs to be
    # able to access the nvidia drivers.
    pkgs ? (builtins.import 
        (builtins.fetchTarball
            ({
                url="https://github.com/NixOS/nixpkgs/archive/8917ffe7232e1e9db23ec9405248fd1944d0b36f.tar.gz";
            })
        )
        ({
            config = {
                allowUnfree = true;
            };
        })
    )
}:
    let
        output = rec {
            howdy = true;
        };
    in 
        output
