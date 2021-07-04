local naughty = require('naughty')

-- Check if awesome encountered an error during startup
-- and fall back to
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors durring setup",
    text = awesome.startup_errors,
  })
end

-- Handle runtime errors
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.preset.critical,
      title = "Oops, an error happened",
      text = tostring(err)
    })

    in_error = false
  end)
end
