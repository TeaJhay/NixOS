<div align="center">
 <pre>
        _            _            _                       _        _       _    _    _        _   
       /\ \         /\ \         / /\                    /\ \     / /\    / /\ / /\ /\ \     /\_\ 
       \_\ \       /  \ \       / /  \                   \ \ \   / / /   / / // /  \\ \ \   / / / 
       /\__ \     / /\ \ \     / / /\ \                  /\ \_\ / /_/   / / // / /\ \\ \ \_/ / /  
      / /_ \ \   / / /\ \_\   / / /\ \ \                / /\/_// /\ \__/ / // / /\ \ \\ \___/ /   
     / / /\ \ \ / /_/_ \/_/  / / /  \ \ \      _       / / /  / /\ \___\/ // / /  \ \ \\ \ \_/    
    / / /  \/_// /____/\    / / /___/ /\ \    /\ \    / / /  / / /\/___/ // / /___/ /\ \\ \ \     
   / / /      / /\____\/   / / /_____/ /\ \   \ \_\  / / /  / / /   / / // / /_____/ /\ \\ \ \    
  / / /      / / /______  / /_________/\ \ \  / / /_/ / /  / / /   / / // /_________/\ \ \\ \ \   
 /_/ /      / / /_______\/ / /_       __\ \_\/ / /__\/ /  / / /   / / // / /_       __\ \_\\ \_\  
\_\/       \/__________/\_\___\     /____/_/\/_______/   \/_/    \/_/ \_\___\     /____/_/ \/_/
 </pre>
</div>                                                                                             

<img src="https://github.com/user-attachments/assets/db2b6368-25e4-417c-8428-2c93a068284f" width="20%" align="left" alt="NixHypr2"/>

<div align="center">

### **My little slice of hell. Structured questionably and like garbage.**

##### Utilising preservation and BTRFS rollback for impermanence with Hjem over Home Manager. I make use of a few tools, and copy from the smart people mentioned below. I'll try to add something special but, this is just my home setup while I learn nix and more about linux. I won't be doing anything server related, I'm happy and in love with Proxmox and Docker.

</div>


<br clear="left"/>

### To-Do list:
- [ ] Cleaner directory structure
- [ ] Move to individual package lists rather than a united one.
- [ ] Move dots and keys to declarative configs and secrets.

<div align="left">

## Structure (wip)
```
├── configuration.nix -- Base config, maybe not even needed?
├── flake.lock
├── flake.nix
├── Hosts
│   └── machineName (NixBeast)
│       ├── disko.nix -- Root, boot and swap partitions.
│       ├── filesystem.nix -- NFS shares and extra drives
│       └── hardware-configuration.nix -- Hardware config minus filesystem
│
├── InstallNix.sh -- Installer/helper script
│
├── Learning -- Learning directory, playing with nix configs and modules
│   ├── hjem-discovery.nix 
│   ├── hjem.nix
│   └── starship.nix
│
├── Options -- Big features/implementations.
│   ├── default.nix -- move to config for each user? Enabled hjem-discovery users
│   ├── ephemera.nix -- Impermanence/Preservation. Preserve files and configure rollback of @void
│   ├── flatpak.nix -- Add flatpaks, should be user based. Moved to programs.
│   └── hjem-discovery.nix -- Hjem management and auto-discovery of a user's files found in users/$Username/xdg/ and links to .local, .config and etc.
│
├── Profiles -- Nix configs for apps that might be edited or configurations changed often, where constant rebuilds would be inconvenient
│   └── NVF  -- Rafware, Neovim but nix and better!
│
│
├── Programs -- Nix configs for programs. Ideally everything should be here with a users configs. Maybe move to a user folder?
│   ├── hyprland
│   │   └── cursor.nix
│   ├── noctalia.nix
│   └── noctalia.nix.bak
│
├── Secrets -- Secrets management
│   ├── githubGPG.enc
│   ├── githubSSH.enc
│   ├── password.enc
│   └── secrets.nix
│
└── Users -- Users folder. Each users name, a nix file to mark them as "valid" and their dots.
    └── teajhay
        ├── user.nix
        └── xdg
```

BEAUTIFUL PEOPLE:

- [Jet and findFiles!](https://github.com/Michael-C-Buckley/findFiles.nix)
- [Squirrel and automation!](https://github.com/SquirrelModeller/squirrel-nixos)
- [Connor being tech support!](https://github.com/eConnah/nix-dots)
- [Fazzi and Hyprcursor](https://gitlab.com/fazzi/nixohess)
