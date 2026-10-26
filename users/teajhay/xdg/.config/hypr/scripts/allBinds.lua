local function allBinds()
  hl.exec_cmd([==[
bash << 'EOF'
printf 'j/binds' | socat - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock" | jq -r '
def mods: . as $m
  | [[1,"SHIFT"],[4,"CTRL"],[8,"ALT"],[64,"SUPER"]]
  | map(select(($m / .[0] | floor) % 2 == 1) | .[1]);

def keyname:
  if .key != "" then
    ({"mouse:272":"LMB","mouse:273":"RMB","mouse:274":"MMB"}[.key] // .key)
  elif .keycode >= 10 and .keycode <= 19 then
    ["1","2","3","4","5","6","7","8","9","0"][.keycode - 10]
  else "code:\(.keycode)" end;

.[]
| "[" + ((.modmask | mods) + [keyname] | join(" + "))
  + "] = "
  + (if .description != "" then .description else "\(.dispatcher) \(.arg)" end)' | noctalia dmenu
EOF
]==])
end
return allBinds
