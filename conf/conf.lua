local setmetatable = setmetatable
local _M = {_VERSION = "0.01"}
local mt = {__index = _M}

_M.new = function (self)
	return setmetatable(_M, mt)
end



_M.signFilterColumns = {
	"sgin",
	"t"
}

_M.checkUri = {
	"/user",
	"/edit"
}

return _M