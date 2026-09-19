 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#000000',
    base01 = '#2a170b',
    base02 = '#241209',
    base03 = '#716761',
    base04 = '#b6b1af',
    base05 = '#f3f2f2',
    base06 = '#f3f2f2',
    base07 = '#f3f2f2',
    base08 = '#fd4663',
    base09 = '#b8ff33',
    base0A = '#43fb37',
    base0B = '#ff8b4d',
    base0C = '#d3ff80',
    base0D = '#ffac80',
    base0E = '#8afd82',
    base0F = '#b9fdb4',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f3f2f2',          bg = '#000000' })
  hi('TelescopeBorder',         { fg = '#716761',             bg = '#000000' })
  hi('TelescopePromptNormal',   { fg = '#f3f2f2',          bg = '#000000' })
  hi('TelescopePromptBorder',   { fg = '#716761',             bg = '#000000' })
  hi('TelescopePromptPrefix',   { fg = '#ff8b4d',             bg = '#000000' })
  hi('TelescopePromptCounter',  { fg = '#b6b1af',  bg = '#000000' })
  hi('TelescopePromptTitle',    { fg = '#000000',             bg = '#ff8b4d' })
  hi('TelescopePreviewTitle',   { fg = '#000000',             bg = '#43fb37' })
  hi('TelescopeResultsTitle',   { fg = '#000000',             bg = '#b8ff33' })
  hi('TelescopeSelection',      { fg = '#f3f2f2',          bg = '#241209' })
  hi('TelescopeSelectionCaret', { fg = '#ff8b4d',             bg = '#241209' })
  hi('TelescopeMatching',       { fg = '#ff8b4d',             bold = true })
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
