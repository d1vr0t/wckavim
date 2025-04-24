{ pkgs, lib, ... }:
{
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };
  clipboard.register = "unnamedplus";
  opts = {
    number = true;
    mouse = "a";
    cursorline = true;
    undofile = true;
  };
  colorschemes.onedark.enable = true;
  plugins = {
    web-devicons.enable = true; # Warning wants this explicitly
    which-key.enable = true;
    bufferline.enable = true;
    markview.enable = true;
    dashboard.enable = true;
    dashboard.settings = {
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
    undotree.enable = true;
    # Grep
    telescope = {
      enable = true;
      extensions = {
        file-browser.enable = true;
        fzf-native.enable = true;
        live-grep-args.enable = true;
        ui-select.enable = true;
        undo.enable = true;
        media-files.enable = true;
        #Nix fuzzy search
        manix.enable = true;
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
        "<Leader>fn" = {
          action = "manix";
          options.desc = "Find in nix doc";
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
        # indent.enable = true;
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
        volar.enable = true;
        ts_ls.enable = true;
        eslint.enable = true;
        bashls.enable = true;
        postgres_lsp.enable = true;
        lemminx.enable = true;
        jsonls.enable = true;
        yamlls.enable = true;
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

    #lsp-lines.enable = true;
    lsp-signature.enable = true;
    lsp-status.enable = true;
    lspkind.enable = true;

    # Autocompletion
    cmp = {
      enable = true;
      autoEnableSources = false;
      settings = {

        sources = [
          {
            name = "nvim_lsp";
            entry_filter = ''
              	function(entry, ctx)
                  return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind();
                end'';
          }
          { name = "path"; }
          {
            name = "buffer";
            entry_filter = ''
              	function(entry, ctx)
                  return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind();
                end'';
          }
          { name = "luasnip"; }
          { name = "nvim_lsp_document_symbol"; }
          { name = "nvim_lsp_signature_help"; }

        ];
        experimental = {
          ghost_text = true;
        };
        mapping = {
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";

          "<Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" })
          '';

          "<C-e>" = "cmp.mapping.abort()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ select = false })"; # Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })";

        };
      };
    };
    cmp-nvim-lsp = {
      enable = true;
    }; # lsp
    cmp-buffer = {
      enable = true;
    };
    cmp-path = {
      enable = true;
    }; # file system paths
    cmp-cmdline = {
      enable = true;
    }; # autocomplete for cmdline
    cmp-nvim-lsp-document-symbol = {
      enable = true;
    }; # docs
    cmp-nvim-lsp-signature-help = {
      enable = true;
    }; # function signatures

    cmp_luasnip = {
      enable = true;
    }; # snippets
    luasnip = {
      enable = true;
      settings.enable_autosnippets = true;
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
    {
      key = "<Leader>ca";
      action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
      options.desc = "Apply Code Action";
    }

    {
      key = "<Leader>e";
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
      options.desc = "Open full error/warning";
    }
  ];

}
