local _M = {_VERSION = "0.01"}
local mt = {__index = _M}

_M.new = function (self)
	return setmetatable({}, mt)
end

_M.get_req_params = function (self)
	local method = string.upper(ngx.req.get_method())
	if method == "GET" then
		return ngx.req.get_uri_args()
	elseif method == "POST" then
		return ngx.req.get_post_args()
	else
		return nil, "method is not allowed"
	end
end

_M.hasVal = function ( self, data, val )
	for k,v in ipairs(data) do
		if val == v then
			return true
		end
	end

	return false
end

_M.tableHas = function ( self, data, val )
	if type(data) ~= table then return false end

	for k,v in pairs(data) do
		if val == v then
			return true
		end
	end

	return false
end

_M.is_empty_table = function (self, t)
    assert(type(t) == "table", "param type must be table")

    return t == nil or next(t) == nil
end

_M.printTable = function ( self, lua_table )
	if lua_table == nil then return false end
	local indent =  0
	for k, v in pairs(lua_table) do
		if type(k) == "string" then
			k = string.format("%q", k)
		end
		local szSuffix = ""
		if type(v) == "table" then
			szSuffix = "{"
		end
		local szPrefix = string.rep("    ", indent)
		formatting = szPrefix.."["..k.."]".." = "..szSuffix
		if type(v) == "table" then
			print(formatting)
			print_lua_table(v, indent + 1)
			print(szPrefix.."},")
		else
			local szValue = ""
			if type(v) == "string" then
				szValue = string.format("%q", v)
			else
				szValue = tostring(v)
			end
			print(formatting..szValue..",")
		end
	end

	-- body
end

_M.create_req_md5 = function ( self )
	
end

return _M