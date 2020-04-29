local json  = require("cjson")
local ngxMd5 = ngx.md5
local ngxReq = ngx.req
local table  = table
local setmetatable = setmetatable

local _M = {_VERSION = "0.01"}
local mt = {__index = _M}

_M.new = function (self)
	return setmetatable({}, mt)
end

_M.get_req_params = function (self)
	local method = string.upper(ngxReq.get_method())
	if method == "GET" then
		return ngxReq.get_uri_args()
	elseif method == "POST" then
		return ngxReq.get_post_args()
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

	if type(data) ~= 'table' then return false end
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

_M.getSignParam = function ( self, params, filterField )
	for k, v in pairs(params) do
        if self:hasVal(filterField, k) then
            params = self:removeEleByKey(params, k)
        end
    end

    return params
end

_M.removeEleByKey = function (self, tbl, key)
    local tmp ={}
    --把每个key做一个下标，保存到临时的table中，转换成{1=a,2=c,3=b}
    --组成一个有顺序的table，才能在while循环准备时使用#table
    for i in pairs(tbl) do
        table.insert(tmp,i)
    end

    local newTbl = {}
    --使用while循环剔除不需要的元素
    local i = 1
    while i <= #tmp do
        local val = tmp [i]
        if val == key then
            --如果是需要剔除则remove
            table.remove(tmp,i)
        else
            --如果不是剔除，放入新的tabl中
            newTbl[val] = tbl[val]
            i = i + 1
        end
    end

    return newTbl
end
_M.getReqSign = function ( self, params, filterField)
	if params == nil then return false end
	local SignParam = self:getSignParam(params, filterField)
	table.sort( SignParam )
	local paramsStr = table.concat( SignParam, "|")

	return ngxMd5(paramsStr)
end

return _M