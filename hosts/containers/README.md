# Containers

My homelabs hosts. These all run as NixOS-based LXC's (hence being in
"../containers").

These run via proxmox, on ZFS disks. They all share a single nix store, with
their own gcroots per-container.

Store is bind mounted as read-only for all except `Circus-NixLC` which is the
main builder/master host, hence having (almost) the most resources.

The circus host manages all evaluations and builds, and is the only host able to
write to the store. When another LXC needs to build something, it gets offloaded
to Circus and seamlessly build like it was local. Inspiration was taken from
[inx-container](https://github.com/Hyffer/inx-container) with the help of
Hyffer!

Proxmox manages DNS, IP and Hostname, although this is very easy to give control
back to Nix (and tempting).

PVE performs regular backups and everything is either served via bind mounts of
NFS shares with parrellizations

I do have VPS and some other things, which will likely end up here in the
future, aswell as my VM's converted

## Specs

| Component      | Specification                | Note                        |
| -------------- | ---------------------------- | --------------------------- |
| **CPU**        | Intel Xeon Gold 6138 @ 2ghz  | Dual socket, only using one |
| **RAM**        | 96GB (12x8) @ DDR4-2666 ECC  | Half slots used, max 3TB    |
| **Storage #1** | Dell BOSS-S1 - 2x NVME 240gb | Boot, in RAID               |
| **Storage #2** | Icydock 4x2.5" enclosure     | PERC H740P                  |
| **Storage #3** | 16x 2.5" SAS/SATA enclosure  | Dell HBA330                 |
| **Chassis**    | Dell PowerEdge T640          | Retired domain controller   |
