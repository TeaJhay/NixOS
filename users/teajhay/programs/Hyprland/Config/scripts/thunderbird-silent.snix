local thunderstart = {}
function thunderstart.launch()
    local rule = hl.window_rule({
        name = "Thunderbird-startup",
        match = { class = "org.mozilla.Thunderbird" },
        suppress_event = "activate",
    })
    hl.exec_cmd("thunderbird")

    hl.timer(function ()
      rule:set_enabled(false)
      hl.exec_cmd("notify-send 'Timer waiting'")
    end, {timeout = 2000, type = "oneshot"})
end
return thunderstart

