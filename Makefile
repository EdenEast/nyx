
build:
	nix build --experimental-features 'nix-command flakes'

install: build
	[ -f ./result/activate ] && ./result/activate

check:
	nix flake check --experimental-features 'nix-command flakes'

update:
	nix flake update --recreate-lock-file --experimental-features 'nix-command flakes'

fmt:
	fd --type f --extension nix --exec nixfmt {}
	# nixfmt *.nix **/*.nix **/**/*.nix
