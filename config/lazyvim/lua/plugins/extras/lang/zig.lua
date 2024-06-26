return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { zig })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        zls = { mason = false },
      },
    },
  }
}
