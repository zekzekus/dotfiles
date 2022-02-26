local neorg = prequire("neorg")

if not neorg then
  return
end

neorg.setup {
  load = {
    ["core.defaults"] = {},
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          gtd = "~/norg",
        },
      },
    },
    ["core.gtd.base"] = {
      config = {
        workspace = "gtd",
      },
    },
    -- ["core.norg.completion"] = {},
    ["core.norg.concealer"] = {},
    ["core.norg.journal"] = {},
    ["core.norg.qol.toc"] = {},
    -- ["core.presenter"] = {},
  }
}
