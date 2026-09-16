require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "nil_ls" }
vim.lsp.enable(servers)

vim.lsp.config("nil_ls", {
  settings = {
    ["nil"] = {
      formatting = {
        command = { "alejandra" }, -- or "nixfmt-rfc-style"
      },
    },
  },
})
