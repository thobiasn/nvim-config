-- custom function for finding the deepest root pattern
local lspconfig_util = require("lspconfig.util")

function deepest_root_pattern(patterns1, patterns2)
  -- Create two root_pattern functions
  local find_root1 = lspconfig_util.root_pattern(unpack(patterns1))
  local find_root2 = lspconfig_util.root_pattern(unpack(patterns2))

  return function(startpath)
    local path1 = find_root1(startpath)
    local path2 = find_root2(startpath)

    if path1 and path2 then
      -- Count the number of slashes to determine the path length
      local path1_length = select(2, path1:gsub("/", ""))
      local path2_length = select(2, path2:gsub("/", ""))

      if path1_length > path2_length then
        return path1
      end
    elseif path1 then
      return path1
    end

    return nil
  end
end

local nvim_lsp = require('lspconfig')

return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- Automatically format on save
      autoformat = false,
      servers = {
        vtsls = {
          single_file_support = true,
          root_dir = deepest_root_pattern(
            { "package.json", "tsconfig.json" },
            { "deno.json", "deno.jsonc", "import_map.json" }
          ),
        },

        denols = {
          root_dir = deepest_root_pattern(
            { "deno.json", "deno.jsonc", "import_map.json" },
            { "package.json", "tsconfig.json" }
          ),
        },
      },
    },
  },
}
