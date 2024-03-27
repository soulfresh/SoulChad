local M = {}

-- Create a new table that contains all of the elements of table2 concatenated
-- after table1
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

return M
