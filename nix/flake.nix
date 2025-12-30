{
  description = "Universal Devcontainer Toolchain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    packages.${system}.default = pkgs.buildEnv {
      name = "universal-toolchain";

      paths = with pkgs; [
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
        # Build essentials (fixes most native build errors)
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
        # Compression / common C libraries
        ##################################################################
        zlib
        zlib.dev
        bzip2
        bzip2.dev
        xz
        xz.dev
        zstd
        zstd.dev

        ##################################################################
        # SSL / crypto (Python + Rust native deps)
        ##################################################################
        openssl
        openssl.dev
        libssh2
        libssh2.dev
        libsodium
        libsodium.dev

        ##################################################################
        # Python (pip / poetry / native extensions)
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
        cargo
        rustc

        ##################################################################
        # Node / native addons
        ##################################################################
        nodejs_20
        yarn
        pnpm
        nodePackages.node-gyp

        ##################################################################
        # Databases / common headers
        ##################################################################
        sqlite
        sqlite.dev
        ncurses
        ncurses.dev
        readline
        readline.dev
        libffi
        libffi.dev
      ];
    };
  };
}
