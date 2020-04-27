local common = require("utils.common")
local json = require("cjson")
local req_uri = ngx.var.request_uri
local setmetatable = setmetatable
local param = common.get_req_params()
local confCheckUri = require("conf.conf").checkUri


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
	ngx.say(common.printTable(ngx.req))
	ngx.say(json.encode(req_uri))
	if common.tableHas(confCheckUri, req_uri) then
		return true
	end
	ngx.say("not need checkUri")

	return false;
end
_M.checkMd5 = function ( self, param )
	-- body
end
_M.run = function ( self )
	if self:checkUri(self, req_uri) then
		self:checkMd5(self, param)
	end
end

dd = _M:new()
dd:run()




ngx.say(json.encode(param))