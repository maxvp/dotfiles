# .dotfiles for zsh

To set up, run:

```bash
git clone https://github.com/maxvp/.dotfiles.git $HOME/.dotfiles && bash $HOME/.dotfiles/bootstrap.sh && exec zsh
```

## Directory structure

```
.
└── .dotfiles/
    ├── bootstrap.sh
    ├── README.md
    └── zsh/
        ├── .zimrc      # change zimfw settings
        ├── .zprofile   # change profile settings
        ├── .zshrc      # change zsh settings
        ├── abbrs.zsh   # add abbrs
        └── aliases.zsh # add aliases
```
