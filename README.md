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

##### Utilising preservation and BTRFS rollback for impermanence with Hjem over Home Manager. I make use of a few tools, and copy from the smart people mentioned below. I'll try to add something special but, this is just my home setup while I learn nix and more about linux. I won't be doing anything server related, I'm happy and in love with Proxmox and Docker. Making a lot of progress, other than some preserved and security things, should be reproducible.

</div>


<br clear="left"/>

### To-Do list:
- [x] Cleaner directory structure
- [x] Move to individual package lists rather than a united one.
- [ ] Move dots and keys to declarative configs and secrets.
- [ ] Look into Hjem-Rum modules
- [ ] Fix yazi githead, needs middle cap 
- [ ] clean up log and readme
- [ ] add liquid glass theming
- [ ] Optimise
<div align="left">

## Structure (wip)
```
NixOS
├── configuration.nix -- temporary base config, removing.
│
├── flake.lock
│
├── flake.nix -- flake inputs for programs, functions, pkg channels and etc.
│
├── hosts -- Directory of hosts managed
│   └── NixBeast -- Host
│       ├── default.nix -- Importing hardware configs via nixos-hardware and setting some default settings or services.
│       ├── Disko.nix -- Disko partitioning and NFS shares
│       ├── Hacking.nix -- Networking
│       ├── Hardware-Configuration.nix -- Generated hardware-configuration plus additional kernel stuff + stateVersion
│       ├── Programs.nix -- Where to declare and import *.nix files from NixOS/Modules/Packages
│       ├── Services.nix -- Declare and set services.* or custom units
│       └── Users.nix -- Sets enabled users and declares some options used in Hjem-Discovery
│
├── InstallNix.sh -- Initial install commands for a fresh install.
│
├── learning -- kept for WIP modules and where iterations of existing modules with documentation                 
│
├── Modules -- Directory for nix modules
│   ├── Filesystem -- Modules for importing users, setting impermanence/preservation. This is auto-discovery and import of users + modules
│   │   ├── default.nix -- Imports Ephemera and Hjem-Discovery
│   │   ├── Ephemera.nix -- Preservation and impermanence (BTRFS snapshot) 
│   │   └── Hjem-Discovery.nix -- Discovers and imports users, uses Hjem to link their xdg files and imports a users modules.
│   │
│   └── Packages -- Packages and apps for use by users
│       ├── Core.nix -- Core packages for all systems
│       ├── Flatpak.nix -- Flatpaks, likely to be split into individual packages.=
│       ├── Gaming.nix -- Gaming related services, packages and settings
│       ├── Mobile.nix -- Mobile related packages (Sideloading iOS)
│       └── PrismLauncher.nix -- Minecraft Launcher
│
├── profiles -- Profiles used for applications that require extensive config and their own repo's. Presently NVF (Somehow load at startup?)
│   └── NVF -- NVF: Premium rafware, forked from Jet
│
├── secrets -- Configs and persistent storage for secrets (move off git?)
│   └── secrets.nix -- Config for nix-secrets
│
└── users -- Users dir
    └── TeaJhay -- User (Me, hi!)
        ├── default.nix -- Users default settings like password, fonts and shell
        ├── programs -- User specific programs
        └── xdg -- User specific dotfiles
```

BEAUTIFUL PEOPLE:

- [Jet and findFiles!](https://github.com/Michael-C-Buckley/findFiles.nix)
- [Jet and his Dots!](https://github.com/Michael-C-Buckley/nixos)
- [Squirrel and automation!](https://github.com/SquirrelModeller/squirrel-nixos)
- [Connor being tech support!](https://github.com/eConnah/nix-dots)
- [Fazzi and Hyprcursor](https://gitlab.com/fazzi/nixohess)
