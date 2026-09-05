{
  inputs,
  ...
}:
{
  hjem = {
    extraModules = [
      inputs.noctalia.hjemModules.default
    ];
    users.teajhay = {
      programs.noctalia = {
        enable = true;
        settings = {
          audio = {
            enable_overdrive = true;
            enable_sounds = true;
          };
          bar = {
            bottom = {
              enabled = false;
              position = "bottom";
              smart_auto_hide = true;
            };
            left = {
              enabled = false;
              position = "left";
              smart_auto_hide = true;
            };
            order = [
              "top"
              "left"
              "right"
              "bottom"
            ];
            right = {
              enabled = false;
              position = "right";
              smart_auto_hide = true;
            };
            top = {
              background_opacity = 0.2;
              capsule_group = [
                {
                  accordion = true;
                  accordion_direction = "start";
                  enabled = true;
                  fill = "surface_variant";
                  id = "g1";
                  members = [
                    "launcher"
                    "wallhaven"
                    "wallpaper"
                  ];
                  opacity = 1;
                  padding = 6;
                }
                {
                  accordion = true;
                  accordion_direction = "start";
                  enabled = true;
                  fill = "surface_variant";
                  id = "g2";
                  members = [
                    "volume"
                    "input_volume"
                  ];
                  opacity = 1;
                  padding = 6;
                }
                {
                  accordion = true;
                  accordion_direction = "start";
                  enabled = true;
                  fill = "surface_variant";
                  id = "g3";
                  members = [
                    "session"
                    "control-center"
                  ];
                  opacity = 1;
                  padding = 6;
                }
                {
                  accordion = true;
                  accordion_direction = "start";
                  enabled = true;
                  fill = "surface_variant";
                  id = "g5";
                  members = [
                    "network_rx"
                    "network_tx"
                    "bluetooth"
                  ];
                  opacity = 1;
                  padding = 6;
                }
                {
                  accordion = false;
                  accordion_direction = "end";
                  enabled = true;
                  fill = "surface_variant";
                  id = "g4";
                  members = [
                    "ram"
                    "cpu"
                  ];
                  opacity = 1;
                  padding = 6;
                }
                {
                  accordion = false;
                  accordion_direction = "end";
                  enabled = true;
                  fill = "surface_variant";
                  id = "g6";
                  members = [
                    "shelly"
                    "notifications"
                    "caffeine"
                    "workspaces"
                    "clock"
                    "nightlight"
                    "weather"
                  ];
                  opacity = 1;
                  padding = 6;
                }
              ];
              center = [
                "group:g1"
                "group:g6"
                "recorder"
              ];
              end = [
                "tray"
                "clipboard"
                "group:g4"
                "group:g5"
                "network"
                "group:g2"
                "group:g3"
              ];
              font_family = "IBM Plex Sans";
              font_weight = 600;
              start = [
                "media"
                "audio_visualizer"
                "hypr-submap"
                "toggle"
              ];
            };
          };
          brightness = {
            enable_ddcutil = true;
          };
          config_version = 13;
          control_center = {
            calendar = {
              show_week_numbers = true;
            };
          };
          desktop_widgets = {
            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };
            schema_version = 2;
            widget = {
              desktop-widget-0000000000000001 = {
                box_height = 0;
                box_width = 0;
                cx = 2294;
                cy = 214;
                output = "HDMI-A-1";
                placement_height = 1440;
                placement_width = 2560;
                rotation = 0;
                settings = {
                  background = false;
                  visualization_mode = "all";
                };
                type = "fancy_audio_visualizer";
              };
              desktop-widget-0000000000000002 = {
                box_height = 224;
                box_width = 432;
                cx = 2296;
                cy = 432;
                output = "HDMI-A-1";
                placement_height = 1440;
                placement_width = 2560;
                rotation = 0;
                settings = {
                  background_color = "on_primary";
                  background_opacity = 0;
                  display = "graph";
                  font_family = "IBM Plex Sans";
                  stat = "gpu_temp";
                  stat2 = "cpu_usage";
                };
                type = "sysmon";
              };
              desktop-widget-0000000000000003 = {
                box_height = 0;
                box_width = 0;
                cx = 2303.5;
                cy = 568;
                output = "HDMI-A-1";
                placement_height = 1440;
                placement_width = 2560;
                rotation = 0;
                settings = {
                  background = false;
                  background_opacity = 0;
                  color = "error";
                  description = "      GPU Temp + Usage";
                  opacity = 1;
                  shadow = false;
                  title = "System Monitor";
                };
                type = "label";
              };
            };
            widget_order = [
              "desktop-widget-0000000000000001"
              "desktop-widget-0000000000000002"
              "desktop-widget-0000000000000003"
            ];
          };
          dock = {
            background_opacity = 0.2;
            enabled = true;
            inactive_opacity = 0.78;
            monitors = [
              "DP-3"
              "HDMI-A-1"
            ];
            reserve_space = false;
            smart_auto_hide = true;
          };
          idle = {
            behavior = {
              idle-behavior-notify = {
                action = "command";
                command = "notify-send 'You're gone :('";
                enabled = true;
                resume_command = "notify-send 'You're back! :)'";
                timeout = 180;
              };
              lock = {
                action = "lock";
                enabled = true;
                timeout = 600;
              };
              lock-and-suspend = {
                action = "lock_and_suspend";
                enabled = true;
                timeout = 1200;
              };
              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 900;
              };
            };
            behavior_order = [
              "lock"
              "screen-off"
              "lock-and-suspend"
              "idle-behavior-notify"
            ];
          };
          #location = {
          #  address = config.security.nix-secrets.secrets."noctalia/address".vars;
          #};
          lockscreen = {
            blur_intensity = 0.06;
            wallpaper = "/home/teajhay/.config/hypr/Extras/Japanese-castle.png";
          };
          lockscreen_widgets = {
            enabled = true;
            grid = {
              cell_size = 64;
              major_interval = 4;
              visible = true;
            };
            schema_version = 2;
            widget = {
              "lockscreen-login-box@DP-3" = {
                box_height = 196;
                box_width = 810;
                cx = 960;
                cy = 898;
                output = "DP-3";
                placement_height = 1080;
                placement_width = 1920;
                rotation = 0;
                settings = {
                  background_color = "surface_variant";
                  background_opacity = 0.88;
                  background_radius = 12;
                  center_password_text = false;
                  input_opacity = 1;
                  input_radius = 6;
                  layout = "regular";
                  show_caps_lock = true;
                  show_keyboard_layout = true;
                  show_login_button = true;
                  show_media = true;
                  show_session_buttons = true;
                  show_unlock_hint = true;
                  show_weather = true;
                };
                type = "login_box";
              };
              "lockscreen-login-box@HDMI-A-1" = {
                box_height = 196;
                box_width = 810;
                cx = 1280;
                cy = 1202;
                output = "HDMI-A-1";
                placement_height = 1440;
                placement_width = 2560;
                rotation = 0;
                settings = {
                  background_color = "surface_variant";
                  background_opacity = 0.88;
                  background_radius = 12;
                  center_password_text = false;
                  input_opacity = 1;
                  input_radius = 6;
                  layout = "regular";
                  show_caps_lock = true;
                  show_keyboard_layout = true;
                  show_login_button = true;
                  show_media = true;
                  show_session_buttons = true;
                  show_unlock_hint = true;
                  show_weather = true;
                };
                type = "login_box";
              };
              lockscreen-widget-0000000000000001 = {
                box_height = 96;
                box_width = 688;
                cx = 1280;
                cy = 176;
                output = "HDMI-A-1";
                placement_height = 1440;
                placement_width = 2560;
                rotation = 0;
                settings = {
                  background_color = "hover";
                  background_opacity = 0.2;
                  background_padding = 8;
                  background_radius = 32;
                  center_text = false;
                  clock_style = "digital";
                  format = "%c";
                };
                type = "clock";
              };
              lockscreen-widget-0000000000000002 = {
                box_height = 0;
                box_width = 0;
                cx = 120;
                cy = 97;
                output = "HDMI-A-1";
                placement_height = 1440;
                placement_width = 2560;
                rotation = 0;
                settings = {
                  forecast_days = 3;
                  show_forecast = true;
                };
                type = "weather";
              };
              lockscreen-widget-0000000000000004 = {
                box_height = 0;
                box_width = 0;
                cx = 80;
                cy = 294.5;
                output = "HDMI-A-1";
                placement_height = 1440;
                placement_width = 2560;
                rotation = 0;
                settings = {
                  background = false;
                  hide_when_no_media = true;
                  layout = "vertical";
                };
                type = "media_player";
              };
            };
            widget_order = [
              "lockscreen-login-box@HDMI-A-1"
              "lockscreen-login-box@DP-3"
              "lockscreen-widget-0000000000000001"
              "lockscreen-widget-0000000000000002"
              "lockscreen-widget-0000000000000004"
            ];
          };
          nightlight = {
            temperature_night = 5400;
          };
          notification = {
            background_opacity = 0.2;
          };
          osd = {
            background_opacity = 0.1;
            monitors = [
              "DP-3"
              "HDMI-A-1"
            ];
            offset_x = 0;
            offset_y = 0;
          };
          plugin_settings = {
            "noctalia/bitwarden" = {
              server_url = "https://vw.doesntcompute.site";
            };
            "noctalia/screen_recorder" = {
              restore_portal = true;
              video_codec = "av1";
            };
            "noctalia/wallhaven" = {
              download_dir = "/home/teajhay/Pictures/wallpapers/";
            };
          };
          plugins = {
            auto_update = "all";
            enabled = [
              "noctalia/wallhaven"
              "noctalia/bitwarden"
              "k4n4t4/hypr-submap"
              "alexander/screen-toolkit"
              "noctalia/screen_recorder"
            ];
            source = [
              {
                kind = "git";
                location = "https://github.com/noctalia-dev/official-plugins";
                name = "official";
              }
              {
                kind = "git";
                location = "https://github.com/noctalia-dev/community-plugins";
                name = "community";
              }
              {
                kind = "git";
                location = "https://github.com/anthonyhab/noctalia-plugins/";
                name = "custom";
              }
            ];
          };
          shell = {
            animation = {
              speed = 0.6;
            };
            app_icon_color = "hover";
            avatar_path = "/home/teajhay/.config/hypr/Extras/TheMaxx2.png";
            corner_radius_scale = 0.6;
            external_ip_enabled = true;
            font_family = "IBM Plex Sans";
            panel = {
              session_placement = "floating";
              session_position = "center";
              transparency_mode = "glass";
            };
            polkit_agent = true;
            session = {
              grid_columns = 4;
            };
            settings_window_translucent = true;
            shadow = {
              alpha = 1;
              direction = "center";
            };
            telemetry_enabled = true;
          };
          system = {
            monitor = {
              cpu_freq_critical_threshold = 5;
            };
          };
          theme = {
            builtin = "Tokyo-Night";
            community_palette = "Garnet";
            custom_palette = "Bloody-night";
            pure_black_dark = true;
            source = "custom";
            templates = {
              builtin_ids = [ "btop" ];
              community_ids = [
                "neovim"
                "prismlauncher"
                "steam"
              ];
            };
            wallpaper_scheme = "dysfunctional";
          };
          wallpaper = {
            default = {
              path = "/home/teajhay/Pictures/wallpapers/Dreamy-Aesthetic-Home-Under-Moonlight.png";
            };
            directory = "/home/teajhay/Pictures/wallpapers/";
            favorite = [
              {
                builtin_palette = "Ayu";
                palette_source = "builtin";
                path = "/home/teajhay/Pictures/wallpapers/3d-door.jpg";
                theme_mode = "dark";
              }
            ];
            last = {
              path = "/home/teajhay/Pictures/wallpapers/Dreamy-Aesthetic-Home-Under-Moonlight.png";
            };
            monitors = {
              DP-3 = {
                path = "/home/teajhay/Pictures/wallpapers/Dreamy-Aesthetic-Home-Under-Moonlight.png";
              };
              HDMI-A-1 = {
                path = "/home/teajhay/Pictures/wallpapers/Dreamy-Aesthetic-Home-Under-Moonlight.png";
              };
            };
            transition_on_startup = true;
          };
          widget = {
            audio_visualizer = {
              bands = 24;
              color_1 = "on_primary";
              color_2 = "secondary";
              width = 112;
            };
            bluetooth = {
              show_label = true;
            };
            clock = {
              actions = {
                right = "settings-toggle";
              };
              format = "{:%-I:%M %p}";
              tooltip_format = "%c";
            };
            cpu = {
              actions = {
                right = "exec kitty btop";
                scroll_down = "power-cycle prev";
                scroll_up = "power-cycle next";
              };
            };
            hypr-submap = {
              hide_when_default = true;
              type = "k4n4t4/hypr-submap:hypr-submap";
            };
            network = {
              actions = {
                right = "exec kitty --class nmtui env NEWT_COLORS='root=white,black border=black,lightgray window=lightgray,lightgray title=black,lightgray button=black,cyan' nmtui &";
              };
            };
            network_rx = {
              actions = {
                right = "panel-toggle control-center network";
              };
              network_speed_compact = true;
              network_speed_unit = "mb";
            };
            network_tx = {
              actions = {
                right = "panel-toggle control-center network";
              };
            };
            notifications = {
              anchor = true;
            };
            ram = {
              actions = {
                right = "exec missioncenter";
              };
            };
            recorder = {
              type = "noctalia/screen_recorder:recorder";
            };
            toggle = {
              type = "alexander/screen-toolkit:widget";
            };
            volume = {
              actions = {
                left = "exec hyprpwcenter";
              };
            };
            wallhaven = {
              type = "noctalia/wallhaven:wallhaven";
            };
            workspaces = {
              actions = {
                right = "settings-open";
              };
              focused_output_only = true;
              style = "focus_hint";
            };
          };
        };
      };
    };
  };
}
