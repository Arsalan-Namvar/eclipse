return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local state = vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")
        vim.opt.runtimepath:append(state .. "/quickshell/nvim")
        if not pcall(vim.cmd.colorscheme, "impasto") then
          -- The generated palette is absent until the first shell palette push.
          vim.cmd.colorscheme("tokyonight")
        end
      end,
    },
  },
}
