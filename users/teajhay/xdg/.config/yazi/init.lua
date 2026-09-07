local catppuccin_palette = {
	rosewater = "#f4dbd6",
	flamingo = "#f0c6c6",
	pink = "#f5bde6",
	mauve = "#c6a0f6",
	red = "#ed8796",
	maroon = "#ee99a0",
	peach = "#f5a97f",
	yellow = "#eed49f",
	green = "#a6da95",
	teal = "#8bd5ca",
	sky = "#91d7e3",
	sapphire = "#7dc4e4",
	blue = "#8aadf4",
	lavender = "#b7bdf8",
	text = "#cad3f5",
	subtext1 = "#b8c0e0",
	subtext0 = "#a5adcb",
	overlay2 = "#939ab7",
	overlay1 = "#8087a2",
	overlay0 = "#6e738d",
	surface2 = "#5b6078",
	surface1 = "#494d64",
	surface0 = "#363a4f",
	base = "#24273a",
	mantle = "#1e2030",
	crust = "#181926",
}

-- Plugins
require("full-border"):setup({
	type = ui.Border.ROUNDED,
})

require("zoxide"):setup({
	update_db = true,
})

require("session"):setup({
	sync_yanked = true,
})

require("bunny"):setup({
  hops = {
    { key = "/",          path = "/",                                    },
    { key = "t",          path = "/tmp",                                 },
    { key = "n",          path = "/nix/store",     desc = "Nix store"    },
    { key = "~",          path = "~",              desc = "Home"         },
    { key = "m",          path = "~/Music",        desc = "Music"        },
    { key = "d",          path = "~/Desktop",      desc = "Desktop"      },
    { key = "D",          path = "~/Documents",    desc = "Documents"    },
    { key = "c",          path = "~/.config",      desc = "Config files" },
    { key = { "l", "s" }, path = "~/.local/share", desc = "Local share"  },
    { key = { "l", "b" }, path = "~/.local/bin",   desc = "Local bin"    },
    { key = { "l", "t" }, path = "~/.local/state", desc = "Local state"  },
    { key = { "h", "r" }, path = "/persistent/home/teajhay/nixos", desc = "Nix config"},
    { key = { "h", "y" }, path = "/persistent/home/teajhay/nixos/users/teajhay/xdg/.config", desc = "Nix user config" },
    -- key and path attributes are required, desc is optional
  },
  desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
  ephemeral = true, -- Enable ephemeral hops, default is true
  tabs = true, -- Enable tab hops, default is true
  notify = false, -- Notify after hopping, default is false
  fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
})


require("yatline"):setup({
	section_separator = { open = "", close = "" },
	inverse_separator = { open = "", close = "" },
	part_separator = { open = "", close = "" },

	style_a = {
		fg = catppuccin_palette.mantle,
		bg_mode = {
			normal = catppuccin_palette.blue,
			select = catppuccin_palette.mauve,
			un_set = catppuccin_palette.red,
		},
	},
	style_b = { bg = catppuccin_palette.surface0, fg = catppuccin_palette.text },
	style_c = { bg = catppuccin_palette.base, fg = catppuccin_palette.text },

	permissions_t_fg = catppuccin_palette.green,
	permissions_r_fg = catppuccin_palette.yellow,
	permissions_w_fg = catppuccin_palette.red,
	permissions_x_fg = catppuccin_palette.sky,
	permissions_s_fg = catppuccin_palette.lavender,

	selected = { icon = "󰻭", fg = catppuccin_palette.yellow },
	copied = { icon = "", fg = catppuccin_palette.green },
	cut = { icon = "", fg = catppuccin_palette.red },

	total = { icon = "", fg = catppuccin_palette.yellow },
	succ = { icon = "", fg = catppuccin_palette.green },
	fail = { icon = "", fg = catppuccin_palette.red },
	found = { icon = "", fg = catppuccin_palette.blue },
	processed = { icon = "", fg = catppuccin_palette.green },

	tab_width = 20,
	tab_use_inverse = true,

	show_background = false,

	display_header_line = true,
	display_status_line = true,

	header_line = {
		left = {
			section_a = {
				{ type = "line", custom = false, name = "tabs", params = { "left" } },
			},
			section_b = {
				{ type = "coloreds", custom = false, name = "githead" },
			},
			section_c = {},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "tab_path" },
			},
			section_b = {
				{ type = "coloreds", custom = false, name = "task_workload" },
			},
			section_c = {
				{ type = "coloreds", custom = false, name = "task_states" },
			},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {
				{ type = "string", custom = false, name = "hovered_size" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_name" },
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "cursor_position" },
			},
			section_b = {
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
	},
})

require("yatline-githead"):setup({
	show_branch = true,
	branch_prefix = "",
	branch_symbol = "",
	branch_borders = "",

	commit_symbol = " ",

	show_stashes = true,
	stashes_symbol = " ",

	show_state = true,
	show_state_prefix = true,
	state_symbol = "󱅉",

	show_staged = true,
	staged_symbol = " ",

	show_unstaged = true,
	unstaged_symbol = " ",

	show_untracked = true,
	untracked_symbol = " ",

	prefix_color = catppuccin_palette.pink,
	branch_color = catppuccin_palette.pink,
	commit_color = catppuccin_palette.mauve,
	stashes_color = catppuccin_palette.teal,
	state_color = catppuccin_palette.lavender,
	staged_color = catppuccin_palette.green,
	unstaged_color = catppuccin_palette.yellow,
	untracked_color = catppuccin_palette.pink,
})

