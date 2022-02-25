local neorg = prequire("neorg")

if not neorg then
  return
end

neorg.setup {
  load = {
    ["core.defaults"] = {},
    -- ["core.gtd.base"] = {},
    -- ["core.norg.completion"] = {},
    ["core.norg.concealer"] = {},
    ["core.norg.dirman"] = {},
    ["core.norg.journal"] = {},
    ["core.norg.qol.toc"] = {},
    -- ["core.presenter"] = {},
  }
}
