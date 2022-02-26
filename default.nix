{
    # Make sure to enable config.allowUnfree to the instance of nixpkgs to be
    # able to access the nvidia drivers.
    pkgs ? (builtins.import
        (<nixpkgs>) 
        ({
            config = {
                allowUnfree = true;
            };
        })
    )
}:
    (pkgs.callPackage
        (./nixGL.nix)
        ({})
    )
