return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon",
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
  },
  {
    {
      "rebelot/kanagawa.nvim",
      name = "kanagawa",
      lazy = false,
    },
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    priority = 1000,
    config = true,
    opts = ...,
  },
}
