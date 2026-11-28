hl.monitor({
  output = "DP-5",
  mode = "1920x1080@60.0",
  position = "0x0",
  scale = 1,
  --disabled = true
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "3840x2160@120.0",
  position = "1920x0",
  scale = 1.5,
  cm = "hdredid",
  bitdepth = 10,
  vrr = 2,
  --disabled = true,
  sdr_min_luminance = 0.005,
  sdr_max_luminance = 203,
  sdrbrightness = 0.5,
  sdrsaturation = 1.02,
})

--monitorv2 {

--    output   = HDMI-A-1

--    disabled = true

--}

--hl.config({
--    debug = {
--        overlay = true,
--        vfr = false,  -- disable VFR so the fps counter shows accurate numbers
--    }
--})

hl.config({
  render = {
    cm_auto_hdr = 2,
    direct_scanout = 2,
  },
})
