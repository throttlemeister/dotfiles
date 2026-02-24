return {
  "breiting/zettel.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("zettel").setup({
      vault_dir = "~/Documents/notes/",
      note_types = { "note", "journal", "meeting", "meta" },
    })
  end,
}
