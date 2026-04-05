local set_maps = require("core.keymaps.plugins.util").set_maps

local M = {}

function M.setup()
  set_maps {
    { mode = "n", lhs = "<LEADER>cp", rhs = "<Plug>CaserMixedCase", desc = "Convert to PascalCase" },
    { mode = "n", lhs = "<LEADER>cc", rhs = "<Plug>CaserCamelCase", desc = "Convert to camelCase" },
    { mode = "n", lhs = "<LEADER>c_", rhs = "<Plug>CaserSnakeCase", desc = "Convert to snake_case" },
    { mode = "n", lhs = "<LEADER>cU", rhs = "<Plug>CaserUpperCase", desc = "Convert to UPPER_CASE" },
    { mode = "n", lhs = "<LEADER>ct", rhs = "<Plug>CaserTitleCase", desc = "Convert to Title Case" },
    { mode = "n", lhs = "<LEADER>cs", rhs = "<Plug>CaserSpaceCase", desc = "Convert to space Case" },
    { mode = "n", lhs = "<LEADER>c-", rhs = "<Plug>CaserKebabCase", desc = "Convert to kebab-case" },
    { mode = "n", lhs = "<LEADER>c.", rhs = "<Plug>CaserDotCase", desc = "Convert to dot.case" },
    { mode = "v", lhs = "<LEADER>cp", rhs = "<Plug>CaserVMixedCase", desc = "Convert to PascalCase" },
    { mode = "v", lhs = "<LEADER>cc", rhs = "<Plug>CaserVCamelCase", desc = "Convert to camelCase" },
    { mode = "v", lhs = "<LEADER>c_", rhs = "<Plug>CaserVSnakeCase", desc = "Convert to snake_case" },
    { mode = "v", lhs = "<LEADER>cU", rhs = "<Plug>CaserVUpperCase", desc = "Convert to UPPER_CASE" },
    { mode = "v", lhs = "<LEADER>ct", rhs = "<Plug>CaserVTitleCase", desc = "Convert to Title Case" },
    { mode = "v", lhs = "<LEADER>cs", rhs = "<Plug>CaserVSpaceCase", desc = "Convert to space Case" },
    { mode = "v", lhs = "<LEADER>c-", rhs = "<Plug>CaserVKebabCase", desc = "Convert to kebab-case" },
    { mode = "v", lhs = "<LEADER>c.", rhs = "<Plug>CaserVDotCase", desc = "Convert to dot.case" },
  }
end

return M
