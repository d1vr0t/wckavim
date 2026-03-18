{ pkgs, lib, ... }:
{
  diagnostic.settings = {
    virtual_text = false;
    signs = true;
    underline = true;
    update_in_insert = false;
    float = {
      border = "rounded";
      source = "always";
      header = "";
      prefix = "";
    };
  };
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };
  clipboard.register = "unnamedplus";
  autoCmd = [
    {
      command = "lua vim.cmd.cd(vim.fn.expand('%:p:h'))";
      event = [ "VimEnter" ];
    }
  ];
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
      settings = {
        max_lines = 10;
      };

    };
    # QoL for code, showing definitions, current scope, renaming, etc...
    treesitter-refactor = {
      enable = true;
      settings = {
        highlight_current_scope.enable = true;
        highlight_definitions.enable = true;
        smart-rename.enable = true;
        navigation.enable = true;
      };
      # Rename with "grr"
    };

    # Floating definitions, etc.:
    treesitter-textobjects = {
      enable = true;
      settings = {
        lsp_interop.enable = true;
        move.enable = true;
      };
    };

    # Language Server:
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        #prismals.enable = true;
        #prismals.package = pkgs.nodePackages."@prisma/language-server";
        vue_ls.enable = true;
        ts_ls = {
          enable = true;
          settings = {
            init_options = {
              plugins = [
                {
                  name = "@vue/typescript-plugin";
                  location = "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server";
                  languages = [
                    "javascript"
                    "typescript"
                    "vue"
                  ];
                }
              ];
            };
            filetypes = [
              "javascript"
              "typescript"
              "vue"
            ];
          };
        };
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

    lspsaga = {
      enable = true;
      settings = {
        lightbulb.sign = false;
        ui.codeAction = "󰴺";
        diagnostic = {
          extend_relatedInformation = true;
          show_layout = "float";
          max_width = 0.8;
          text_hl_follow = true;
          border_follow = true;
        };
        finder = {
          keys = {
            tabe = "<CR>";
          };
        };
      };
    };
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
          "<Tab>" = ''
                        cmp.mapping(function(fallback)
                          if cmp.visible() then
                            cmp.select_next_item()
                          elseif not cmp.visible() then
            	        cmp.mapping.complete()
            	      else
                            fallback()
                          end
                        end, { "i", "s" })
          '';

          "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })"; # Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

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
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "ts-error-translator.nvim";
      version = "latest";
      src = pkgs.fetchFromGitHub {
        owner = "dmmulroy";
        repo = "ts-error-translator.nvim";
        rev = "main";
        sha256 = "sha256-kjZwfvb0B7GC4dBBSdgC/zRmCUCfCm4H5J+8SFzANJ4=";
      };
    })
  ];
  extraConfigLua = ''
    require("ts-error-translator").setup({
      auto_attach = true,
    })
  '';
  keymaps = [
    {
      key = "<Space>";
      action = "<Nop>";
      options.desc = "Disable space in normal mode";
      mode = "n";
    }
    {
      key = "<F1>";
      action = "<Nop>";
      options.desc = "Disable Helpfile";
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
      key = "<Leader>fs";
      action = "<cmd>Lspsaga finder<CR>";
      options.desc = "Find symbol";
    }
    {
      key = "<c-t>";
      action = "<cmd>Lspsaga term_toggle<CR>";
      options.desc = "Open Terminal";
    }
    {
      key = "<F2>";
      action = "<cmd>lua vim.lsp.buf.rename()<CR>";
      options.desc = "Rename Symbol";
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
      action = "<cmd>Lspsaga show_line_diagnostics<CR>";
      options.desc = "Open full error/warning";
    }
  ];

}
