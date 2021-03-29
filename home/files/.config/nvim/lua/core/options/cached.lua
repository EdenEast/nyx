local global = require('core.global')
local path = require('core.path')

local backup  = path.join({global.cachehome, 'backup'})
local swap    = path.join({global.cachehome, 'swap'})
local undo    = path.join({global.cachehome, 'undo'})
local view    = path.join({global.cachehome, 'view'})

path.create(backup)
path.create(swap)
path.create(undo)
path.create(view)

local cached = {
  backupdir = backup,
  dir       = swap,
  undodir   = undo,
  undofile  = true,
  viewdir   = view
}

return cached
