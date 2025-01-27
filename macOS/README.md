# How to install

## iTerm2

    brew install --cask iterm2
    
Or, if you do not have homebrew (you should ;)): [Download](http://www.iterm2.com/downloads.html) and install iTerm2 

iTerm2 has better color fidelity than the built in Terminal, so your themes will look better.
    
Get the iTerm color settings

- [Solarized Dark theme](https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Solarized%20Dark%20-%20Patched.itermcolors) (patched version to fix the bright black value)
- [Solarized Light theme](https://raw.githubusercontent.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Light.itermcolors)
- [More themes @ iterm2colorschemes](http://iterm2colorschemes.com/)
    
Just save it somewhere and open the file(s). The color settings will be imported into iTerm2. Apply them in iTerm through iTerm → preferences → profiles → colors → load presets. You can create a different profile other than `Default` if you wish to do so.

# Oh My Zsh 

More info here: https://github.com/robbyrussell/oh-my-zsh

## Install with curl
    
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    
When the installation is done, edit `~/.zshrc` and set `ZSH_THEME="agnoster"` for the default look. Or better yet, go for Powerlevel10k.

## Powerlevel9k / Powerlevel10k

Why Powerlevel10k? Well, because it's a drop-in replacement for Powerlevel9k, just a lot faster to render your prompt. `ls` feels fast again!

So if you prefer the Powerlevel10k look with added info such as exit codes and timestamps on the right, run:

    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

Then edit your `~/.zshrc` and set `ZSH_THEME="powerlevel10k/powerlevel10k"`. Once you do so, when you start a new terminal session, the Powerlevel10 configure wizard will be launched to set your prompt, beware, there are many many options!

Powerlevel10k offers a whole lot more and is extremely configurable, best is to [check its project page](https://github.com/romkatv/powerlevel10k#extremely-customizable).

If you want to trigger the configuration wizard immediately, simply run `p10k configure` to discover all options, which are plentiful.

## Install a patched font

If you did not go with Powerlevel10k or you want another font, read on:

- [Source Code Pro](https://github.com/powerline/fonts/blob/master/SourceCodePro/Source%20Code%20Pro%20for%20Powerline.otf)
- [Source Code Pro + Font Awesome](https://github.com/Falkor/dotfiles/blob/master/fonts/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf), this one is needed if you want the icons from Font Awesome as shown in the screenshot for Powerlevel10k.
- [Others @ powerline fonts](https://github.com/powerline/fonts)
    
Open the downloaded font and press "Install Font".

Set this font in iTerm2 (iTerm → Preferences → Profiles → Text → Font), in the dropdown select the desired Font. You will see it change on the fly.

Restart iTerm2 for all changes to take effect.

# Further tweaking

Things like

- auto suggestions 
- word jumping with arrow keys / natural text editing
- syntax highlighting
- visual studio code config

can be found in the section below.

## Auto suggestions (for Oh My Zsh)

![Auto suggestions](https://gist.githubusercontent.com/kevin-smets/9722391f8b3e4fa436b1c1dcf05ecd88/raw/fba93f6061a73eaedefad2e8c6266ab4ed90fbbf/autocomplete.png)

Just follow these steps: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

If the auto suggestions do not appear to show, it could be a problem with your color scheme. Under "iTerm → Preferences → Profiles → Colors tab", check the value of Black Bright, that is the color your auto suggestions will have. It will be displayed on top of the Background color. If there is not enough contrast between the two, you won't see the suggestions even if they're actually there..

## Enable word jumps and word deletion, aka natural text selection

By default, word jumps (option + → or ←) and word deletions (option + backspace) do not work. To enable these, go to "iTerm → Preferences → Profiles → Keys → Key mappings → Presets... → Natural Text Editing → Boom! Head explodes"

## Syntax highlighting

Clone the repository:

```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Activate the plugin in `~/.zshrc`:

    plugins=( [plugins...] zsh-syntax-highlighting)

Restart iTerm2 for all changes to take effect.

## Visual Studio Code config

Installing a patched font will mess up the integrated terminal in VS Code unless you use the proper settings. You'll need to go to settings (CMD + ,) and add or edit the following values:

- for Source Code Pro + Font Awesome: `"terminal.integrated.fontFamily": "'SourceCodePro+Powerline+Awesome Regular'"`. The single quotes are important! Restart VS Code after the config change.
- for Source Code Pro: `"terminal.integrated.fontFamily": "Source Code Pro for Powerline"`
- for Meslo: `"terminal.integrated.fontFamily": "Meslo LG M for Powerline"`
- for other fonts you'll need to check the font name in Font Book. You can right click on them on select "Show in Finder" to get the exact name.

* If above configurations doesn't work, try this for `iTerm2` and `VSCode` 

> try `cmd+shift+P` in `VSCode`, write `Preferences: Open User Settings`, then edit`settings.json` file and add above this line of code

```json
    "terminal.integrated.defaultProfile.linux": "zsh", 
    "terminal.integrated.fontFamily": "MesloLGS NF",
    "terminal.integrated.defaultProfile.osx": "zsh",
    "terminal.integrated.fontSize":14,
```

You can also set the fontsize e.g.: `"terminal.integrated.fontSize": 14`

> If you want to run VS Code from the terminal, append the following to your `~/.bash_profile` file (`~/.zshrc` in case you use zsh).

```sh
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}
```

Now you can use `VSCode` with terminal, simply write for example `code ~/.bashrc` for editing

## Tilling Windows Manager *Yabai*

### Installing *yabai*

A codesigned binary release of yabai can be installed using Homebrew from the tap koekeishiya/formulae.

```sh
brew install koekeishiya/formulae/yabai
# start yabai
yabai --start-service
```

### Updating to the latest release

```sh
# stop yabai
yabai --stop-service

# upgrade yabai
brew upgrade yabai

# start yabai
yabai --start-service
```

### Configure scripting addition

yabai uses the macOS Mach APIs to inject code into Dock.app; this requires elevated (root) privileges. You can configure your user to execute yabai --load-sa as the root user without having to enter a password. To do this, we add a new configuration entry that is loaded by /etc/sudoers.

```sh
# create a new file for writing - visudo uses the vim editor by default.
# go read about this if you have no idea what is going on.

sudo visudo -f /private/etc/sudoers.d/yabai

# input the line below into the file you are editing.
#  replace <yabai> with the path to the yabai binary (output of: which yabai).
#  replace <user> with your username (output of: whoami). 
#  replace <hash> with the sha256 hash of the yabai binary (output of: shasum -a 256 $(which yabai)).
#   this hash must be updated manually after running brew upgrade.

<user> ALL=(root) NOPASSWD: sha256:<hash> <yabai> --load-sa
```

After the above edit has been made, add the command to load the scripting addition at the top of your yabairc config file

```sh
# for this to work you must configure sudo such that
# it will be able to run the command without password

yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
sudo yabai --load-sa

# .. more yabai startup stuff
```
