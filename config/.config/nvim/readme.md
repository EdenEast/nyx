# Neovim

This is my living `neovim` configuration. I describe it as `living` as it is constantly changing and
evolving as my needs change and my workflow improves. I live in neovim as my only editor. This means
that my neovim setup handles all my text editor needs as well as all of my development needs.

## Requirements and setup

This setup requires the [Nightly][nightly-release] version of neovim. My setup is managed by `nix`.
This means that installing the nightly version of neovim is handled by importing the flake:
[neovim-nightly-overlay][nightly-overlay]. See the input section of [flake.nix](../../../flake.nix)
for more information. Also see [neovim.nix](../../../home/modules/shell/neovim.nix) module for more
information of other configuration and programs that are installed with neovim.

[nightly-release]: https://github.com/neovim/neovim/releases/tag/nightly
[nightly-overlay]: https://github.com/nix-community/neovim-nightly-overlay

## Structure

My configuration is broken up into several sections.

```text
.
├── init.lua              | config entriy point
└── lua/                  |
    └── eden/             | namespace
        ├── core/         | keymap and autocmd apis + core defitiions
        ├── fn/           | Used defined function to call from mappings
        ├── modules/      | plugin definitions and configuration
        ├── user/         | user neovim settings, mapping and autocmds
        ├── bootstrap.lua | bootstrap of env and plugins
        └── main.lua      | main entry point after env has been bootstrapped
```

The interesting part of my configuration is how plugins are defined and configured. All of this is
defined in the file [pack.lua](./lua/eden/core/pack.lua). To set up packer we check all the files
located in the path `lua/eden/modules/*.lua` All these files return a table with a `plugins` key.
The values of these keys are collected and sent to packer. In these files they can also optionaly
return a `before` and `after` key. These are defined as function that will be executed before plugin
loading and after plugin loading.

The bootstrap module checks to see if packer is installed. If packer is not installed then it will
clone packer into the correct location. Once packer is closed it will then execute a packer install
to install all of the plugins. On packer complete the `eden.main` module will be required. If packer
is already installed then the bootstrap will just require `eden.main`.

See [boostrap.lua](./lua/eden/boostrap.lua) and [pack.lua](./lua/eden/core/pack.lua) for more
information.


## Why neovim?

#### History

I first learned vim in 2015 but only really used it for editing text and configuration files. I
became proficient with the aspects of vim that make editing fast but vim was lacking some essential
features that made it hard to switch to. These essential features were:`file/project fuzzy
navigation`, `language integration`, and `interactive visual debugger`. The first was solved with
the integration of `fzf` into a vim plugin. This let me quickly navigate a project and finding
files. The second was initially solved with `coc.nvim`. When coc was added vim finally had
interactive language support. I could finally have go to definition, find references and sweet sweet
autocompletion. With those two I was able to transition from vscode to vim, only switching if I did
not have language support or needed to debug. When the development started for neovim 0.5 and its
built in lsp client I transitioned from coc to that very quickly. I am still working on integrating
`dap` into my configuration.

**TLDR**

Neovim with `naitave lsp`, `fzf/telecope`, and `dap` turns it from a text editor to and development
environment that you can actually get work done in.

#### Neovim and Lua

The introduction of `Lua` as a first class language to neovim turned neovim from just a text editor
to as an editing language with the main entry point being `init.lua`. With lua I now have the power
to create the editing experience that I want. I think of neovim as an editor application that I
write with the main entry point being `init.lua`. This is very exciting and cant wait to see where
my configuration goes.

## Resources

- [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim)
