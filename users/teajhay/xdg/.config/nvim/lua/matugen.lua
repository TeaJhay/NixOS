 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#000000',
    base01 = '#0f1325',
    base02 = '#151a34',
    base03 = '#5d6682',
    base04 = '#9aa5ce',
    base05 = '#7aa2f7',
    base06 = '#7aa2f7',
    base07 = '#7aa2f7',
    base08 = '#f7768e',
    base09 = '#9ece6a',
    base0A = '#bb9af7',
    base0B = '#9c152c',
    base0C = '#c1e996',
    base0D = '#f08f9f',
    base0E = '#af89f6',
    base0F = '#cfb8f9',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#7aa2f7',          bg = '#000000' })
  hi('TelescopeBorder',         { fg = '#5d6682',             bg = '#000000' })
  hi('TelescopePromptNormal',   { fg = '#7aa2f7',          bg = '#000000' })
  hi('TelescopePromptBorder',   { fg = '#5d6682',             bg = '#000000' })
  hi('TelescopePromptPrefix',   { fg = '#9c152c',             bg = '#000000' })
  hi('TelescopePromptCounter',  { fg = '#9aa5ce',  bg = '#000000' })
  hi('TelescopePromptTitle',    { fg = '#000000',             bg = '#9c152c' })
  hi('TelescopePreviewTitle',   { fg = '#000000',             bg = '#bb9af7' })
  hi('TelescopeResultsTitle',   { fg = '#000000',             bg = '#9ece6a' })
  hi('TelescopeSelection',      { fg = '#7aa2f7',          bg = '#151a34' })
  hi('TelescopeSelectionCaret', { fg = '#9c152c',             bg = '#151a34' })
  hi('TelescopeMatching',       { fg = '#9c152c',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
