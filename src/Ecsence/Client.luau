local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(script.Parent.Types)
local World = require(script.Parent.World)
local replecs = require(ReplicatedStorage.Ecsence.Packages.replecs)

local Client = {}

Client.__index = function(self: Types.Client, key)
	local method = rawget(Client, key)

	if method ~= nil then
		return method
	end

	return World.__index(self, key)
end

function Client.new(components: Types.ComponentDefinitions): Types.Client
	local self = setmetatable(World.new(components), Client)

	self._replicator = replecs.create_client(self._world) :: replecs.Client
	self._replicator:init()

	return self
end

function Client:applyUpdates(buf: buffer, variants: { { any } })
	self._replicator:ApplyUpdates(buf, variants)
end

function Client:applyUnreliables(buf: buffer, variants: { { any } })
	self._replicator:ApplyUnreliables(buf, variants)
end

function Client:applyFull(buf: buffer, variants: { { any } })
	self._replicator:ApplyFull(buf, variants)
end

return Client
