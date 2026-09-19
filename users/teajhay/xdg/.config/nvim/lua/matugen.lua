 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#000000',
    base01 = '#1d100d',
    base02 = '#291a17',
    base03 = '#ae8881',
    base04 = '#e7bdb6',
    base05 = '#f9dcd7',
    base06 = '#f9dcd7',
    base07 = '#f9dcd7',
    base08 = '#ffb4ab',
    base09 = '#ffb4a7',
    base0A = '#f4b2e3',
    base0B = '#ffacec',
    base0C = '#ffb4a7',
    base0D = '#ffacec',
    base0E = '#f4b2e3',
    base0F = '#ffd7f2',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f9dcd7',          bg = '#000000' })
  hi('TelescopeBorder',         { fg = '#ae8881',             bg = '#000000' })
  hi('TelescopePromptNormal',   { fg = '#f9dcd7',          bg = '#000000' })
  hi('TelescopePromptBorder',   { fg = '#ae8881',             bg = '#000000' })
  hi('TelescopePromptPrefix',   { fg = '#ffacec',             bg = '#000000' })
  hi('TelescopePromptCounter',  { fg = '#e7bdb6',  bg = '#000000' })
  hi('TelescopePromptTitle',    { fg = '#000000',             bg = '#ffacec' })
  hi('TelescopePreviewTitle',   { fg = '#000000',             bg = '#f4b2e3' })
  hi('TelescopeResultsTitle',   { fg = '#000000',             bg = '#ffb4a7' })
  hi('TelescopeSelection',      { fg = '#f9dcd7',          bg = '#291a17' })
  hi('TelescopeSelectionCaret', { fg = '#ffacec',             bg = '#291a17' })
  hi('TelescopeMatching',       { fg = '#ffacec',             bold = true })
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
