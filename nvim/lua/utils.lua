M = {}

-- Update the given table so you can dynamically access deeply nested
-- properties using the syntax `table[{"a", "b", "c"}]`.
--
-- @example
--     local table = makeTableAccessible({ foo = { bar = "baz" } })
--     local bar = table[{"foo", "bar"}]
--
-- @param table The table you want to make accessible
M.makeTableAccessible = function(table)
  setmetatable(table, {
    __index = function(t, k)
      for i, k in ipairs(k) do
        if t == nil then return nil end
        if type(t) ~= "table" then error("Unexpected subtable", 2) end
        t = rawget(t, k)
      end
      return t
    end,
    __newindex = function(t, k, v)
      local last_k
      for i, k in ipairs(k) do
        k, last_k = last_k, k
        if k ~= nil then
          local parent_t = t
          t = rawget(parent_t, k)
          if t == nil then
            t = {}
            rawset(parent_t, k, t)
          end
          if type(t) ~= "table" then error("Unexpected subtable", 2) end
        end
      end
      rawset(t, last_k, v)
    end
  })
  return table
end

-- Concatenate two tables together
--
-- @example
--     local a = { "foo" }
--     local b = { "bar" }
--     local c = concat(a, b)
--     c -> { "foo", "bar" }
--
-- @param table1
-- @param table2
M.concat = function(table1, table2)
  local result = {}
  for _, v in ipairs(table1) do
    table.insert(result, v)
  end
  for _, v in ipairs(table2) do
    table.insert(result, v)
  end
  return result
end

-- Load some deeply nested property from the given language configs in the
-- "lua/configs/languages" folder. This will find the field you're looking for
-- in each language config and merge the values into a single table.
--
-- @example
--     local servers = loadLanguageConfigs({"cpp", "js"}, {"lspconfig", "servers"})
--     servers -> {"html", "clang"}
--
-- @param languages A table with the languages you want to load. 
--   Ex `{"cpp", "js"}`
-- @param node The deeply nested node on those configs that you need access to.
--   Ex `{"lspconfig", "servers"}`
--
-- @return Returns a table with the merged data for each language.
M.loadLanguageConfigs = function(languages, node)
  local servers = {}
  for _, language in ipairs(languages) do
    local file = 'configs.languages.' .. language
    local curr = require(file)
    -- TODO Also check `node` is a valid list of string paths
    if (curr) then
      curr = M.makeTableAccessible(curr)
      local data = curr[node]
      if (data) then
        -- vim.print('M', vim.inspect(M))
        -- vim.print("current config", vim.inspect(curr))
        servers = M.concat(servers, data)
        -- servers = vim.tbl_deep_extend("force", servers, curr)
        -- vim.print('after:')
        -- vim.print(vim.inspect(configs))
      else
        vim.print("Unable to find the node", vim.inspect(node), "on the", language, "config")
      end
    else
      vim.print("Unable to load the config for language", language)
    end
  end
  return servers
end

return M
