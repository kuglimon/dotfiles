local terminal = "alacritty"
local browser  = "firefox"
local mainMod  = "SUPER"

-- FIXME(tatu): These should per host configuration rather than global
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- FIXME(tatu): This should be a per host configuration rather than global
hl.monitor({
  output = "desc:ASUSTek COMPUTER INC PG32UCDP T6LMQS118771",
  mode = "3840x2160@240",
  position = "0x0",
  scale = 1.5,
  -- Enables VRR on full screen apps
  vrr = 2,
  bitdepth = 10
})


hl.config({
  xwayland = {
    -- fixes x11 scaling going bonkers on some apps
    force_zero_scaling = true
  },

  -- disable various annoying popups after updates
  ecosystem = {
    no_update_news = true,
    no_donation_nag = true
  }
})

-- -----------------------------------------------------------------------------
-- AUTOSTART
-- -----------------------------------------------------------------------------
hl.on("hyprland.start", function()
  -- Status Bar
  hl.exec_cmd("waybar")

  -- Wallpaper
  hl.exec_cmd("hyprpaper")

  -- Notifications
  hl.exec_cmd("$HOME/.local/bin/start-dunst.sh")

  -- Authentication Agent (Essential for GUI apps needing sudo)
  -- hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1") -- Adjust path based on your distro

  -- No silent to give firefox focus on boot, rest should not take focus. I always
  -- hated this on windows and macos, bunch of applications battling for focus
  -- during boot.
  hl.exec_cmd(browser .. " --name firefox-main -P default-release", { workspace = "1" })

  -- Application Autostart (Matching your i3 setup)
  hl.exec_cmd(terminal .. " --class term-main", { workspace = "2 silent" })
  hl.exec_cmd("keepassxc", { workspace = "3 silent" })
  hl.exec_cmd("discord", { workspace = "4 silent" })
  -- hl.exec_cmd("spotify", { workspace = "5 silent" })
  hl.exec_cmd("steam", { workspace = "6 silent" })

  -- Firefox Private (Scratchpad)
  -- hl.exec_cmd(browser .. " -private-window --class firefox-private -P private")
  -- Scratchpad Terminal
  -- hl.exec_cmd(terminal .. " --class scratch-term")
end)

-- -----------------------------------------------------------------------------
-- APPEARANCE
-- -----------------------------------------------------------------------------
hl.config({
  general = {
    gaps_in = 10,
    gaps_out = 10,
    border_size = 2,

    -- Dracula Colors
    col = {
      active_border = "rgb(8BE9FD)",
      inactive_border = "rgb(282A36)",
    },

    layout = "dwindle",
  },

  decoration = {
    rounding = 5,

    blur = {
      enabled = true,
      size = 3,
      passes = 1,
    },
  },

  -- TODO(tatu): I need to make a separate layout for gaming. Having capslock as
  -- escape is perfect during development, but during gaming I constantly butter
  -- finger capslock. Either map it here or check if I can just remap it at
  -- keyboard level.
  input = {
    kb_layout = "fi",

    -- Capslock to escape without any annoying switch of them
    kb_options = "caps:escape",

    -- Disable mouse acceleration
    accel_profile = "flat",
  },

  cursor = {
    -- Hardware cursors don't work on nvidia, I don't know why.
    no_hardware_cursors = 1,
  },

  dwindle = {
    preserve_split = true,
  },

  misc = {
    -- Don't let apps grab focus by requesting activation, I decide what to look at
    focus_on_activate = false,
  },
})

-- -----------------------------------------------------------------------------
-- WINDOW RULES (Assigns & Behavior)
-- -----------------------------------------------------------------------------
-- Workspace assignments
--
-- Silent so apps never steal focus or switch workspaces when they open.
-- Discord and Steam fork and open several windows (updaters, main window,
-- Friends List), so the silent exec_cmd rules in autostart don't catch them,
-- these do.
--
-- KeePassXC is the exception. When git asks it to sign a commit while the
-- database is locked, it opens a new unlock dialog window. That dialog has to
-- take focus, otherwise git just appears to hang. The autostart exec_cmd rule
-- keeps the main window silent on boot.
hl.window_rule({ match = { class = "^(alacritty)$", title = "^(term-main)$" }, workspace = "2 silent" })
hl.window_rule({ match = { class = "^(org.keepassxc.KeePassXC)$" }, workspace = "3" })
hl.window_rule({ match = { class = "^(discord)$" }, workspace = "4 silent" })
hl.window_rule({ match = { class = "^(firefox-main)$" }, workspace = "1" })
hl.window_rule({ match = { class = "^(Spotify)$" }, workspace = "5 silent" })
hl.window_rule({ match = { class = "^(steam)$" }, workspace = "6 silent" })
hl.window_rule({ match = { initial_title = "^(Friends List)$" }, workspace = "6 silent" })

-- Steam Games to Workspace 7 (Present)
hl.window_rule({ match = { class = [[^steam_app_\d+$]] }, workspace = "7" })

-- Scratchpads (Special Workspaces)
-- In Hyprland, scratchpads are "special workspaces".
-- We define rules to send these apps to specific special workspaces on launch.

-- Scratch Terminal
hl.window_rule({
  match = { class = "^(scratch-term)$" },
  float = true,
  workspace = "special:scratch_term",
  center = true,
  size = { "monitor_w * 0.8", "monitor_h * 0.8" },
})

-- Private Firefox
hl.window_rule({
  match = { class = "^(firefox-private)$" },
  float = true,
  workspace = "special:firefox_private",
  center = true,
  size = { "monitor_w * 0.8", "monitor_h * 0.8" },
})

hl.window_rule({ match = { class = "^(rusty-path-of-building)$" }, tile = true }) -- Force tile

-- -----------------------------------------------------------------------------
-- KEYBINDINGS
-- -----------------------------------------------------------------------------

-- App Shortcuts
-- hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("toggle-rofi"))

-- Vim Focus / Move Window
local vimDirections = { H = "left", J = "down", K = "up", L = "right" }
for key, direction in pairs(vimDirections) do
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

-- Layout Toggles
hl.bind(mainMod .. " + O", hl.dsp.layout("togglesplit")) -- Split horizontal/vertical toggle
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + S", hl.dsp.group.toggle())        -- Tabbed-like behavior
-- Note: Stacked layout isn't strictly available in Dwindle, use Master layout if preferred.

-- Screenshots (Flameshot or Grim/Slurp)
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("flameshot gui -p ~/Images/Screenshots"))

-- Workspaces (1-7) and Move to Workspace
for i = 1, 7 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = true }))
end

-- Scratchpad Toggles
-- hl.bind(mainMod .. " + P", hl.dsp.workspace.toggle_special("scratch_term"))
-- hl.bind(mainMod .. " + I", hl.dsp.workspace.toggle_special("firefox_private"))

-- Reload/Exit
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload")) -- Hyprland reloads instantly, no restart needed

-- Modes

-- Emulate i3/vim marks. Submap resets automatically after any bind fires.
hl.bind(mainMod .. " + G", hl.dsp.submap("mark_mode"))
hl.define_submap("mark_mode", "reset", function()
  hl.bind("J", hl.dsp.focus({ window = "class:^(firefox-main)$" }))
  hl.bind("K", hl.dsp.focus({ window = "class:^(term-main)$" }))
  hl.bind("L", hl.dsp.focus({ window = "class:^(discord)$" }))
  hl.bind("odiaeresis", hl.dsp.focus({ window = "class:^(Spotify)$" })) -- 'ö' key
  hl.bind("U", hl.dsp.focus({ window = "class:^(KeePassXC)$" }))
  hl.bind("O", hl.dsp.focus({ window = "class:^(steam)$" }))
  hl.bind("I", hl.dsp.focus({ window = "title:^(Friends List)$" }))
  hl.bind("catchall", hl.dsp.submap("reset"))
end)

-- Thanks to samsaffron for this stealable gem used in his i3 config
hl.bind(mainMod .. " + X", hl.dsp.submap("exit_mode"))
hl.define_submap("exit_mode", "reset", function()
  hl.bind("l", hl.dsp.exit())
  hl.bind("r", hl.dsp.exec_cmd("systemctl reboot"))
  hl.bind("s", hl.dsp.exec_cmd("systemctl poweroff"))
  hl.bind("catchall", hl.dsp.submap("reset"))
end)
