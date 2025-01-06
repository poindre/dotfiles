-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'wuelnerdotexe/vim-astro',
    ft = "astro",
    init = function()
      vim.g.astro_typescript = "enable"
      vim.g.astro_stylus     = "disable"
    end,
  }
}
