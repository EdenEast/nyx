_: _final: prev: {
  direnv = prev.direnv.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        # Add `[whitelist] git_worktrees` to trust identical .envrc files in git worktrees.
        # Remove once upstreamed.
        ./0001-feat-trust-identical-.envrc-files-in-git-worktrees.patch
      ];

    # The patch edits a man page source, so make regenerates the man page.
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [prev.go-md2man];
  });
}
