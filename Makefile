build:
	nix build . --experimental-features 'nix-command flakes'

wsl:
	nix build .#wsl --experimental-features 'nix-command flakes'

fmt:
	nixfmt *.nix **/*.nix **/**/*.nix
