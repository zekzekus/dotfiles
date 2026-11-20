-- Rex configuration, linked to ~/.config/rex/init.lua on every host.
-- Apply edits with `rex config reload` on the machine that runs the server.

local shell = "com.superlogical.terminal.shell"

-- Mirrors ZEK_DEVEL_HOME and ZEK_DEFAULT_PROJECT_DIR from nix/lib.nix. The
-- server does not inherit login-shell variables, so derive them from HOME.
local devel_home = os.getenv("HOME") .. "/devel/projects"
local default_project_dir = "personal"

local function check(result, err)
  if result == nil then error(err, 0) end
  return result
end

-- Show a palette prompt. Returns nil only when the person cancels; any other
-- missing answer (timeout, no_client, unsupported, busy, failed) is an error.
local function pick(opts)
  local answer, why, detail = rex.ui.pick(opts)
  if answer == nil and why ~= "cancelled" then
    error(opts.title .. ": " .. why .. (detail and (" (" .. detail .. ")") or ""), 0)
  end
  return answer
end

-- Ask for a project under devel_home/dir and return its name and path.
local function pick_project(dir)
  local base = devel_home .. "/" .. (dir or default_project_dir)
  local r = check(rex.exec({ "find", base, "-mindepth", "1", "-maxdepth", "1", "-type", "d" }))
  if not r.ok then error(r.stderr, 0) end

  local names = {}
  for path in r.stdout:gmatch("[^\n]+") do
    names[#names + 1] = path:match("([^/]+)$")
  end
  table.sort(names)

  local items = {}
  for _, name in ipairs(names) do
    items[#items + 1] = { id = name, subtitle = base, icon = "folder" }
  end

  local name = pick{ title = "Project", placeholder = "Filter projects", items = items }
  if name == nil then return nil end
  return name, base .. "/" .. name
end

local function terminal(cwd, input)
  return rex.layout.block{ flavor = shell, options = { cwd = cwd, initial_input = input } }
end

rex.action{
  name = "gg",
  title = "Project: Open Session…",
  description = "Open a project in its own session with editor and shell tabs, or switch to it.",
  category = "Projects",
  keywords = "gg project session open switch",
  args = { dir = "string?" },
  run = function(ctx, args)
    local name, cwd = pick_project(args.dir)
    if name == nil then return end

    for _, s in ipairs(check(rex.call("session.list")).sessions or {}) do
      if s.label == name then
        rex.client.queue("session.select", { session_id = s.session_id })
        return
      end
    end

    local created = check(rex.call("session.create", {
      label = name,
      initial_windows = {
        { window_label = "editor", layout = terminal(cwd, "nvim\r") },
        { window_label = "shell", layout = terminal(cwd, "clear; git fetch --all\r") },
      },
    }))
    rex.client.queue("session.select", {
      session_id = created.session_id,
      window_id = created.initial_windows[1].window_id,
    })
  end,
}

rex.action{
  name = "gk",
  title = "Project: Close Sessions…",
  description = "Close the chosen sessions and every terminal in them.",
  category = "Projects",
  keywords = "gk kill close destroy session",
  run = function(ctx, args)
    local items = {}
    for _, s in ipairs(check(rex.call("session.list")).sessions or {}) do
      items[#items + 1] = { id = s.session_id, title = s.label, icon = "terminal" }
    end

    local ids = pick{ title = "Close sessions", items = items, multiple = true, confirm = "Close" }
    if ids == nil then return end
    for _, id in ipairs(ids) do
      -- Destroying a session requires attaching to it first.
      check(rex.call("session.attach", { session_id = id }))
      check(rex.call("session.destroy", { session_id = id }))
    end
  end,
}

rex.action{
  name = "gp",
  title = "Project: Open in Split…",
  description = "Open a project in nvim in a split beside the focused pane.",
  category = "Projects",
  keywords = "gp project split pane editor",
  args = { dir = "string?" },
  run = function(ctx, args)
    local name, cwd = pick_project(args.dir)
    if name == nil then return end
    check(rex.session.new_split{
      anchor_id = ctx.block_id,
      direction = "horizontal",
      side = "after",
      focus = true,
      layout = terminal(cwd, "nvim\r"),
    })
  end,
}
