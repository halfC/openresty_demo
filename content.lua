local common = require("utils.common")
local json = require("cjson")
local req_uri = ngx.var.uri
local setmetatable = setmetatable
local param = common.get_req_params()
local confCheckUri = require("conf.conf").checkUri
local signFilterColumns = require("conf.conf").signFilterColumns


local _M = {_VERSION = "0.01"}
local mt = {__index = _M}

_M.new = function (self)
	local ctx = ngx.ctx
	if not ctx.response or type(ctx.response) ~= "string" then
		ctx.response = ""
	end

	return setmetatable({ctx = ctx}, mt)
end

_M.checkUri = function (self, req_uri )
	
	local req_uri = ngx.var.uri
	if common:tableHas(confCheckUri, req_uri) then
		return true
	end

	return false;
end

_M.checkSign = function ( self, param, signFilterColumns)

	local sign = param['sign']
	local genSign = common:getReqSign(param, signFilterColumns)
	if sign ~= genSign then
		ngx.say("sign err! ".. genSign)
	end

end

_M.run = function ( self )
	if self:checkUri() then
		self:checkSign(param, signFilterColumns)
	end
end

obj = _M:new()
obj:run()
