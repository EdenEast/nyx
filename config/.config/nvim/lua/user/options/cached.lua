local global = require('core.global')
local path = require('core.path')
local opt = vim.opt

local backup  = path.join(global.cachehome, 'backup')
local swap    = path.join(global.cachehome, 'swap')
local undo    = path.join(global.cachehome, 'undo')
local view    = path.join(global.cachehome, 'view')

path.create(backup)
path.create(swap)
path.create(undo)
path.create(view)

opt.backupdir = backup
opt.directory = swap
opt.undodir   = undo
opt.undofile  = true
opt.viewdir   = view

