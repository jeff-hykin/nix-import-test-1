{
    enable32bits ? true,
    writeTextFile,
    fetchurl,
    lib,
}: 
    let
        output = rec {
            howdy = true;
        };
    in 
        output
