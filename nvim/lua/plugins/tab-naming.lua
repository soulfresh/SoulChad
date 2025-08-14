-- Taboo
-- Used to name tabs with my custom tabufline "tabs" module
return {
  "gcmt/taboo.vim",
  dependencies = { "NvChad/ui" },
  -- Needs to load up front so that NvChad tabufline can use it.
  lazy = false,
}
