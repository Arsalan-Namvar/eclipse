-- Keep Eclipse's generated colours separate from LazyVim's configuration.
local state = vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")
vim.opt.runtimepath:append(state .. "/quickshell/nvim")

-- Palette reloads address this instance without sending input-mode keystrokes.
if vim.env.XDG_RUNTIME_DIR then
  vim.fn.serverstart(vim.env.XDG_RUNTIME_DIR .. "/nvim-impasto-" .. vim.fn.getpid() .. ".sock")
end
