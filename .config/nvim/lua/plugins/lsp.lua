return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Keep existing clangd config
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        },
        -- Add Python LSP config
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pylint = { enabled = true },
                pycodestyle = { enabled = true },
                pyflakes = { enabled = true },
                mccabe = { enabled = true },
                rope_completion = { enabled = true },
              },
            },
          },
        },
      },
    },
  },
}
