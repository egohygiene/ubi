{
  description = "Universal Devcontainer Toolchain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
  let
    systems = [ "x86_64-linux" "aarch64-linux" ];

    forAllSystems = f:
      builtins.listToAttrs (map (system: {
        name = system;
        value = f system;
      }) systems);
  in
  {
    devShells = forAllSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # ------------------------------------------------------------------
        # Package groups (this is the key refactor)
        # ------------------------------------------------------------------

        coreTools = with pkgs; [
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
          lsof
          gawk
        ];

        buildTools = with pkgs; [
          gcc
          gnumake
          cmake
          pkg-config
          autoconf
          automake
          libtool
          patchelf
          binutils
        ];

        devTools = with pkgs; [
          shellcheck
          go-task
          pandoc
          act
          direnv
        ];

        languagePython = with pkgs; [
          python311
          python311Packages.pip
          python311Packages.virtualenv
          python311Packages.setuptools
          python311Packages.wheel
          python311Packages.cffi
          python311Packages.pyopenssl
        ];

        languageRust = with pkgs; [
          rustc
          cargo
        ];

        languageNode = with pkgs; [
          nodejs_20
          yarn
          pnpm
          nodePackages.node-gyp
        ];

        databases = with pkgs; [
          sqlite
          ncurses
          readline
          libffi
        ];

        imageTools = with pkgs; [
          imagemagick
          ghostscript
          inkscape
          glibcLocales
        ];

        # Example: audio / creative (from the reference)
        audioTools = with pkgs; [
          ffmpeg
          sox
          supercollider
        ];

      in {
        default = pkgs.mkShell {
          name = "universal-devcontainer-shell";

          packages =
            coreTools
            ++ buildTools
            ++ devTools
            ++ languagePython
            ++ languageRust
            ++ languageNode
            ++ databases
            ++ imageTools
            ++ audioTools;

          shellHook = ''
            echo "🔧 Universal Devcontainer Toolchain ready"
            echo "📦 System: ${system}"

            echo "❄️  Nix: $(nix --version 2>/dev/null)"
            echo "📁 Repo: $(git rev-parse --show-toplevel 2>/dev/null || echo "n/a")"
            echo "🔖 Rev:  $(git rev-parse --short HEAD 2>/dev/null || echo "unknown")"

            echo "🌐 Locale: ${LANG:-unknown}"
            echo "🕒 Timezone: $(cat /etc/timezone 2>/dev/null || echo "unknown")"

            for tool in git rg fd jq; do
              if command -v "$tool" >/dev/null 2>&1; then
                printf "✔️  %-10s %s\n" "$tool" "$("$tool" --version 2>/dev/null | head -n1)"
              else
                printf "⚠️  %-10s not found\n" "$tool"
              fi
            done

            if command -v magick >/dev/null 2>&1; then
              echo "🖼️  ImageMagick: $(magick -version | head -n1)"
            fi

            if command -v inkscape >/dev/null 2>&1; then
              echo "🎨 Inkscape: $(inkscape --version 2>/dev/null | head -n1)"
            fi

            echo "—"
          '';
        };
      }
    );

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
