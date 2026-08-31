# command 1 
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#nixos
# command 2
sudo nixos-install --root /mnt --flake .#nixos
