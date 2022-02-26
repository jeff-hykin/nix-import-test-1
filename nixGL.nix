{ # # Nvidia informations.
    # Version of the system kernel module. Let it to null to enable auto-detection.
    nvidiaVersion ? null,
    # Hash of the Nvidia driver .run file. null is fine, but fixing a value here
    # will be more reproducible and more efficient.
    nvidiaHash ? null,
    # Alternatively, you can pass a path that points to a nvidia version file
    # and let nixGL extract the version from it. That file must be a copy of
    # /proc/driver/nvidia/version. Nix doesn't like zero-sized files (see
    # https://github.com/NixOS/nix/issues/3539 ).
    nvidiaVersionFile ? null,
    # Enable 32 bits driver
    # This is one by default, you can switch it to off if you want to reduce a
    # bit the size of nixGL closure.
    enable32bits ? true,
    writeTextFile,
    shellcheck,
    pcre,
    runCommand,
    linuxPackages,
    fetchurl,
    lib,
    runtimeShell,
    bumblebee,
    libglvnd,
    vulkan-validation-layers,
    mesa,
    libvdpau-va-gl,
    intel-media-driver,
    vaapiIntel,
    pkgsi686Linux,
    driversi686Linux,
    zlib,
    libdrm,
    xorg,
    wayland,
    gcc 
}: 

let
    writeExecutable = { name, text }: (writeTextFile
        ({
            inherit name text;
            executable = true;
            destination = "/bin/${name}";
            checkPhase = ''
                ${shellcheck}/bin/shellcheck "$out/bin/${name}"

                # Check that all the files listed in the output binary exists
                for i in $(${pcre}/bin/pcregrep  -o0 '/nix/store/.*?/[^ ":]+' $out/bin/${name})
                do
                ls $i > /dev/null || (echo "File $i, referenced in $out/bin/${name} does not exists."; exit -1)
                done
            '';
        })
    );
    top = rec {
        howdy = true;
    };
in 
    (
        top // (
            if
                nvidiaVersion != null
            then
                top.nvidiaPackages {
                    version = nvidiaVersion;
                    sha256 = nvidiaHash;
                }
            else
                { }
        )
    )
