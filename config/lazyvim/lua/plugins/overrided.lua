return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = { mason = false },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.indent["disable"] = { "nix" }
    end,
  },
  { "catppuccin/nvim", name = "catppuccin" },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-frappe" } },

  -- Super tab
  {
    "L3MON4D3/LuaSnip",
    -- Disable default <tab> and <s-tab> in LuaSnip
    keys = function()
      return {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-cmdline",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      opts.completion.completeopt = "menu,menuone,noselect"
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        config = function()
          require("telescope").load_extension("file_browser")
        end,
        keys = {
          { "<leader>fb", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "File browser" },
        },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        bind_to_cwd = true,
      },
    },
  },
  {
    "mrcjkb/haskell-tools.nvim",
    keys = {
      {
        "<leader>rr",
        function()
          require('haskell-tools').repl.toggle()
        end,
        desc = "Toggle a GHCi repl for the current package"
      },
      {
        "<leader>rf",
        function()
          require('haskell-tools').repl.toggle(vim.api.nvim_buf_get_name(0))
        end,
        desc = "Toggle a GHCi repl for the current buffer"
      },
      {
        "<leader>rq",
        function()
          require('haskell-tools').repl.quit()
        end,
        desc = "Quit GHCi repl"
      }
    },
  }
}
