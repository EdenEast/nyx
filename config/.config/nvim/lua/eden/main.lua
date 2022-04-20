-- This is the main entry point of my configuration after the bootstrapping
-- phase is complete. This file is meant for the actual user configuration to be
-- set (or be required from other files)

require("eden.user.event")
require("eden.user.keymap")
require("eden.user.options")

-- This is required here as the packer setup outputted the compiled file in the
-- lua require path. This is so that it can be cached by `impatient`.
require("packer_compiled")

-- Trigger the after functions in the modules directory.
require("eden.core.pack").trigger_after()

-- Once the compiled packer file is required we can try and set the colorscheme.
-- This could not be done before because some colorschemes (light nightfox) have
-- some configuration in the config sections. Requiring the compiled file
-- executes the config section. Then the colorscheme can be applied and the
-- configuration settings would be seen.
require("eden.core.theme")
