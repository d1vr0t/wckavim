{ pkgs, lib, ... }:
{
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };
  opts = {
    number = true;
    mouse = "a";
    cursorline = true;
  };
  colorschemes.onedark.enable = true;
  plugins = {
    markview.enable = true;
    dashboard.enable = true;
    dashboard.settings = {
      change_to_vcs_root = true;
      config = {
        footer = [
          "The only winning move is not to play"
        ];
        header = [
          "▗▖ ▗▖ ▗▄▄▖▗▖ ▗▖ ▗▄▖     ▗▖  ▗▖▗▄▄▄▖▗▖  ▗▖"
          "▐▌ ▐▌▐▌   ▐▌▗▞▘▐▌ ▐▌    ▐▌  ▐▌  █  ▐▛▚▞▜▌"
          "▐▌ ▐▌▐▌   ▐▛▚▖ ▐▛▀▜▌    ▐▌  ▐▌  █  ▐▌  ▐▌"
          "▐▙█▟▌▝▚▄▄▖▐▌ ▐▌▐▌ ▐▌     ▝▚▞▘ ▗▄█▄▖▐▌  ▐▌"
        ];
        mru = {
          limit = 20;
        };
        project = {
          enable = false;
        };
        week_header = {
          enable = false;
        };
      };
      theme = "hyper";
    };
    # Grep
    telescope = {
      enable = true;
      extensions = {
        file-browser.enable = true;
        fzf-native.enable = true;
        live-grep-args.enable = true;
        ui-select.enable = true;
        undo.enable = true;
      };
      keymaps = {

        "<Leader>fg" = {
          action = "live_grep";
          options.desc = "Find w grep";
        };

        "<Leader>ff" = {
          action = "find_files";
          options.desc = "Find files";
        };

      };
    };
    # Filebrowser
    nvim-tree.enable = true;
    # Language Higlighting etc.
    treesitter = {
      enable = true;
      grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;

      settings = {
        highlight.enable = true;
        # Install missing Parsers
        auto_install = true;
        # Mark Code Blocks
        incremental_selection.enable = true;
        # Indent Code
        indent.enable = true;
      };
    };

    # Show Head of current function on top
    treesitter-context = {
      enable = true;
    };
    # QoL for code, showing definitions, current scope, renaming, etc...
    treesitter-refactor = {
      enable = true;
      highlightCurrentScope.enable = true;
      highlightDefinitions.enable = true;
      navigation.enable = true;
      # Rename with "grr"
      smartRename.enable = true;
    };

    # Floating definitions, etc.:
    treesitter-textobjects = {
      enable = true;
      lspInterop.enable = true;
      move.enable = true;

    };

    # Language Server:
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        prismals.enable = true;
        prismals.package = pkgs.nodePackages."@prisma/language-server";
        ts_ls.enable = true;
        html.enable = true;
        nixd = {
          enable = true;
          settings =
            let
              flake = ''(builtins.getFlake "/etc/nixos/flake")""'';
            in
            {
              nixpkgs = {
                expr = "import ${flake}.inputs.nixpkgs { }";
              };
              formatting = {
                command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
              };
            };

        };
      };
    };

    lsp-lines.enable = true;
    lsp-signature.enable = true;
    lsp-status.enable = true;
    lspkind.enable = true;

    # Autocompletion
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }

      ];
    };

  };

  keymaps = [
    {
      key = "<Space>";
      action = "<Nop>";
      options.desc = "Disable space in normal mode";
      mode = "n";
    }

    {
      key = "<c-n>";
      action = "<cmd>NvimTreeToggle<CR>";
      options.desc = "Toggle File browser";
    }
    {
      key = "<Leader>F";
      action = "<cmd>lua vim.lsp.buf.format()<CR>";
      options.desc = "Format Code";
    }
    {
      key = "<Leader>id";
      action = "<cmd>lua vim.api.nvim_put({io.popen('uuidgen'):read():sub(1, -2)}, 'c', true, true)<CR>";
      options.desc = "Insert UUID";
    }

  ];

}
