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

        myImagemagick = pkgs.imagemagick.override {
          bzip2Support = true;
          djvulibreSupport = true;
          fontconfigSupport = true;
          freetypeSupport = true;
          ghostscriptSupport = true;
          lcms2Support = true;
          libX11Support = true;
          libXtSupport = true;
          libheifSupport = true;
          libjpegSupport = true;
          libjxlSupport = true;
          liblqr1Support = true;
          libpngSupport = true;
          librawSupport = true;
          librsvgSupport = true;
          libtiffSupport = true;
          libwebpSupport = true;
          libxml2Support = true;
          openexrSupport = true;
          openjpegSupport = true;
          zlibSupport = true;
        };

        myFFmpeg = pkgs.ffmpeg.override {
          withAlsa = true;
          withAom = true;
          withAppKit = false;
          withAribcaption = true;
          withAss = true;
          withAudioToolbox = false;
          withAvFoundation = false;
          withAvisynth = true;
          withBin = true;
          withBluray = true;
          withBs2b = true;
          withBzlib = true;
          withCaca = true;
          withCelt = true;
          withChromaprint = true;
          withCodec2 = true;
          withCoreImage = false;
          withCuda = true;
          withCudaLLVM = true;
          withCuvid = true;
          withDav1d = true;
          withDc1394 = true;
          withDebug = true;
          withDoc = true;
          withDocumentation = true;
          withDrm = true;
          withDvdnav = true;
          withDvdread = true;
          withExtraWarnings = true;
          withFdkAac = false;
          withFlite = true;
          withFontconfig = true;
          withFreetype = true;
          withFrei0r = true;
          withFribidi = true;
          withGPL = true;
          withGPLv3 = true;
          withGme = true;
          withGnutls = true;
          withGrayscale = true;
          withGsm = true;
          withHardcodedTables = true;
          withHarfbuzz = true;
          withHeadlessDeps = true;
          withHtmlDoc = true;
          withIconv = true;
          withJack = true;
          withJxl = true;
          withLadspa = true;
          withLib = true;
          withLzma = true;
          withManPages = true;
          withMfx = false;
          withModplug = true;
          withMp3lame = true;
          withMultithread = true;
          withMysofa = true;
          withNetwork = true;
          withNvcodec = true;
          withNvdec = true;
          withNvenc = true;
          withOgg = true;
          withOpenal = true;
          withOpencl = true;
          withOpencoreAmrnb = true;
          withOpencoreAmrwb = true;
          withOpengl = true;
          withOpenh264 = true;
          withOpenjpeg = true;
          withOpenmpt = true;
          withOptimisations = true;
          withOpus = true;
          withPic = true;
          withPixelutils = true;
          withPlacebo = true;
          withPodDoc = true;
          withPulse = true;
          withQrencode = true;
          withQuirc = true;
          withRav1e = true;
          withRtmp = true;
          withRuntimeCPUDetection = true;
          withSafeBitstreamReader = true;
          withSamba = true;
          withSdl2 = true;
          withShaderc = true;
          withShared = true;
          withSmallBuild = true;
          withSmallDeps = true;
          withSoxr = true;
          withSpeex = true;
          withSrt = true;
          withSsh = true;
          withStatic = true;
          withStripping = true;
          withSvg = true;
          withSvtav1 = true;
          withSwscaleAlpha = true;
          withTensorflow = true;
          withTheora = true;
          withThumb = true;
          withTxtDoc = true;
          withUnfree = false;
          withV4l2 = true;
          withV4l2M2m = true;
          withVaapi = true;
          withVdpau = true;
          withVersion3 = true;
          withVidStab = true;
          withVideoToolbox = false;
          withVmaf = true;
          withVoAmrwbenc = true;
          withVorbis = true;
          withVpl = true;
          withVpx = true;
          withVulkan = true;
          withWebp = true;
          withX264 = true;
          withX265 = true;
          withXavs = true;
          withXcb = true;
          withXcbShape = true;
          withXcbShm = true;
          withXcbxfixes = true;
          withXevd = true;
          withXeve = true;
          withXlib = true;
          withXml2 = true;
          withXvid = true;
          withZimg = true;
          withZlib = true;
          withZmq = true;
        };

        # ------------------------------------------------------------------
        # Package groups
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
          gettext
          shared-mime-info
          xdg-utils
          openssh
          xdg-terminal-exec
          rsync
          cacert
          tzdata
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

        languageGo = with pkgs; [
          go
          gofmt
        ];

        databases = with pkgs; [
          sqlite
          ncurses
          readline
          libffi
        ];

        imageTools = with pkgs; [
          myImagemagick
          ghostscript
          inkscape
          glibcLocales
        ];

        audioTools = with pkgs; [
          myFFmpeg
          sox
          supercollider
          pulseaudioFull
        ];

        pdfTools = with pkgs; [
          evince
          pandoc
        ];

        miscTools = with pkgs; [
          calibre
        ];

        fontPkgs = with pkgs; [
          # fonts
          ubuntu-classic
          inconsolata # monospace

          # gpt recommended:
          # Cica	Japanese-focused monospaced font
          pkgs.myrica # https://myrica.estable.jp/ Balanced monospace font with CJK support
          pkgs.hackgen-nf-font # HackGen Console	Great for code + Japanese
          pkgs.source-han-code-jp # Source Han Code JP	From Adobe; fixed-width variant of Source Han Sans

          # cica
          noto-fonts-cjk-sans # asiatic but double-width by default
          nerd-fonts.fira-code # otherwise no characters
          nerd-fonts.droid-sans-mono # otherwise no characters

          # corefonts # microsoft fonts  UNFREE
          font-awesome_5
          source-code-pro
          dejavu_fonts
          # Adobe Source Han Sans
          source-han-sans # sourceHanSansPackages.japanese
          fira-code-symbols # for ligatures
          iosevka
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
            ++ pdfTools
            ++ miscTools
            ++ audioTools;

          shellHook = ''
            echo "🔧 Universal Devcontainer Toolchain ready"
            echo "📦 System: ${system}"

            echo "❄️  Nix: $(nix --version 2>/dev/null)"
            echo "📁 Repo: $(git rev-parse --show-toplevel 2>/dev/null || echo "n/a")"
            echo "🔖 Rev:  $(git rev-parse --short HEAD 2>/dev/null || echo "unknown")"

            echo "🌐 Locale: $(echo ${LANG})"
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

            if command -v ffmpeg >/dev/null 2>&1; then
              echo "🔊 ffmpeg: $(ffmpeg -version 2>/dev/null | head -n1)"
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
