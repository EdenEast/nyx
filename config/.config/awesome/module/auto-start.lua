local awful = require('awful')

local function run_once(cmd)
    local findme = cmd
    local firstspace = cmd:find(' ')
    if firstspace then
        findme = cmd:sub(o, firstspace - 1)
    end
    awful.spawn.with_shell(string.format('pgrep -u $USER -x %s >/dev/null || (%s)', findme, cmd))
end

for _,app in ipairs(user.run_once_at_startup) do
    run_once(app)
end

