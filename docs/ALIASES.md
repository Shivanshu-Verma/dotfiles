# Cheat-sheet — aliases & functions

Defined in `zsh/aliases.zsh` and `zsh/functions.zsh`.

## Navigation & listing
| Command | Does |
|---|---|
| `ls` | `eza` with icons, dirs first |
| `ll` | long list + git status |
| `la` | list including hidden |
| `lt` / `ltt` | tree, 2 / 3 levels deep |
| `..` `...` `....` | up 1 / 2 / 3 dirs |
| `z <dir>` | zoxide jump to a frecent dir |
| `zi` | zoxide interactive (fzf) pick |
| `mkcd <dir>` | mkdir -p + cd |
| `c` | clear · `reload` | restart shell · `path` | print PATH lines |

## Viewing
| `cat <f>` | bat, no paging · `catp <f>` | bat with paging |

## Git
| `g` git · `gs` status · `gp` pull · `gpf` push --force-with-lease |
| `ga`/`gaa` add / add -A · `gc`/`gcm`/`gca` commit / -m / --amend |
| `gco`/`gsw` checkout / switch · `gb` branch · `gd`/`gds` diff / staged |
| `gl`/`gla` graph log (branch / all) · `lg` lazygit |
| `gclone <url>` clone + cd into it |

Git-native aliases (via gitconfig): `git st co sw br ci unstage last lg amend undo wip aliases`.

## Docker
| `d` docker · `dc` compose · `dps`/`dpsa` ps (running/all) · `dimg` images · `dprune` prune |
| `dsh <container>` shell into a running container |

## Kubernetes
| `k` kubectl · `kgp`/`kgs`/`kga`/`kgn` get pods/svc/all/nodes |
| `kd` describe · `kl` logs -f · `kctx` use-context · `kcur` current-context · `kns` set namespace |

## fzf keybindings
| `Ctrl-R` fuzzy history · `Ctrl-T` fuzzy file into cmdline · `Alt-C` fuzzy cd |

## Utility functions
| `extract <archive>` | unpack any common archive type |
| `killport <port>` | kill whatever listens on a TCP port |
| `serve [port]` | static HTTP server (default 8000) |
| `venv` | create/activate ./.venv |
| `backup <file>` | timestamped copy beside the file |
| `myip` public IP · `ports` local listeners |
