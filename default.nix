let 
    # 
    # pick which frozen version of nixpkgs to use
    # 
    # 7e9b0dff974c89e070da1ad85713ff3c20b0ca97 # <- alternative
    pinnedNixVersion = "8917ffe7232e1e9db23ec9405248fd1944d0b36f"; # this is a hash of a specific commit
    pinnedNix = (builtins.import 
        (builtins.fetchTarball
            ({
                url=''https://github.com/NixOS/nixpkgs/archive/${pinnedNixVersion}.tar.gz'';
            })
        )
        ({
            config = {
                allowUnfree = true;
            };
        })
    );
    
    # 
    # put frozen dependencies in a map
    #
    defaultVersions = {
        pkgs = pinnedNix;
        lib = pinnedNix.lib;
        fetchFromGitHub = pinnedNix.fetchFromGitHub;
        rustPlatform = pinnedNix.rustPlatform;
    };
    
    # 
    # Load data from Cargo.toml
    # 
    packageInfo = (pinnedNix.fromTOML
        (pinnedNix.readFile
            ./Cargo.toml
        )
    );
    
in
    # this is exporting a funciton, the arguments are things that importers can override if needed
    {
        pkgs            ? defaultVersions.pkgs,
        lib             ? defaultVersions.lib,
        fetchFromGitHub ? defaultVersions.fetchFromGitHub,
        rustPlatform    ? defaultVersions.rustPlatform,
        ...
    }:
        (rustPlatform.buildRustPackage 
            ({
                pname = "salt";
                version = "0";

                src = fetchFromGitHub {
                    owner = "Milo123459";
                    repo = "https://github.com/Milo123459/salt.git";
                    rev = "v0.2.3";
                    sha256 = "1d17lxz8kfmzybbpkz1797qkq1h4jwkbgwh2yrwrymraql8rfy42";
                };

                cargoSha256 = "1615z6agnbfwxv0wn9xfkh8yh5waxpygv00m6m71ywzr49y0n6h6";

                meta = {
                    description = "Fast and simple task management from the CLI.";
                    homepage = "https://github.com/Milo123459/salt";
                    license = lib.licenses.mit;
                    maintainers = [ ];
                };
            })
        )