{
  description = "Universal Devcontainer Toolchain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
  let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    forAllSystems = f:
      builtins.listToAttrs (map (system: {
        name = system;
        value = f system;
      }) systems);
  in
  {
    ##########################################################################
    # Development shells (PRIMARY ENTRYPOINT)
    ##########################################################################
    devShells = forAllSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          name = "universal-devcontainer-shell";

          packages = with pkgs; [
            ##################################################################
            # Core CLI / UX
            ##################################################################
            bash
            coreutils
            curl
            wget
            git
            gh
            jq
            yq
            ripgrep
            fd
            tree
            unzip
            zip
            gnupg
            less
            which

            ##################################################################
            # Build essentials
            ##################################################################
            gcc
            gnumake
            cmake
            pkg-config
            autoconf
            automake
            libtool
            patchelf
            binutils

            ##################################################################
            # Compression / common libs
            ##################################################################
            zlib
            bzip2
            xz
            zstd

            ##################################################################
            # SSL / crypto
            ##################################################################
            openssl
            libssh2
            libsodium

            ##################################################################
            # Python
            ##################################################################
            python311
            python311Packages.pip
            python311Packages.virtualenv
            python311Packages.setuptools
            python311Packages.wheel
            python311Packages.cffi
            python311Packages.pyopenssl

            ##################################################################
            # Rust
            ##################################################################
            rustc
            cargo

            ##################################################################
            # Node
            ##################################################################
            nodejs_20
            yarn
            pnpm
            nodePackages.node-gyp

            ##################################################################
            # Databases / headers
            ##################################################################
            sqlite
            ncurses
            readline
            libffi

            ##################################################################
            # Image processing
            ##################################################################
            imagemagick
            ghostscript
            inkscape
          ];

          shellHook = ''
            echo "🔧 Universal Devcontainer Toolchain ready"
            echo "📦 System: ${system}"
          '';
        };
      }
    );

    ##########################################################################
    # Optional: keep a package output if you really want one
    ##########################################################################
    packages = forAllSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.buildEnv {
          name = "universal-toolchain";
          paths = self.devShells.${system}.default.packages;
        };
      }
    );
  };
}
