{...}: {
  mkcd = ''
    if test (count $argv) -ne 1
      echo "Usage: mkcd <directory>"
      return 1
    end
    mkdir -p $argv[1] && cd $argv[1]
  '';

  # Process killer by name
  killall-fuzzy = ''
    if test (count $argv) -eq 0
      echo "Usage: killall-fuzzy <process_name_pattern>"
      return 1
    end
    ps aux | grep $argv[1] | grep -v grep | awk '{print $2}' | xargs -r kill
  '';
}
