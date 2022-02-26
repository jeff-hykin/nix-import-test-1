{
    description = "A wrapper tool for nix OpenGL applications";
    outputs = { self }: ({
        overlay = final: (
            _: ({
                nixgl = (builtins.import
                    (./default.nix)
                    ({
                        pkgs = final; 
                    })
                );
            })
        );
    });
}
