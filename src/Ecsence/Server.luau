local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Ecsence.Packages.jecs)
local Types = require(script.Parent.Types)
local Utils = require(script.Parent.Utils)
local World = require(script.Parent.World)
local replecs = require(ReplicatedStorage.Ecsence.Packages.replecs)

local Server = {}

local function applyFilterToComponentType(self: Types.Server, filter: Types.PlayerFilter?, component: Types.Component)
	local componentType = Utils.GetComponentTypeFromComponent(self._components, component)
	if componentType then
		componentType.Filter = filter or {}
	end
end

Server.__index = function(self: Types.Server, key)
	local method = rawget(Server, key)

	if method ~= nil then
		return method
	end

	return World.__index(self, key)
end

function Server.new(components: Types.ComponentDefinitions): Types.Server
	local self = setmetatable(World.new(components), Server)

	self._replicator = replecs.create_server(self._world) :: replecs.Server
	self._replicator:init()

	return self
end

function World:replicateEntity(entity: Types.Entity<number>, filter: Types.PlayerFilter?)
	if filter then
		self._world:set(entity, replecs.networked, filter)
	else
		self._world:add(entity, replecs.networked)
	end
end

function World:stopReplicatingEntity(entity: Types.Entity<number>)
	self._world:remove(entity, replecs.networked)
end

function World:replicateComponent(entity: Types.Entity<number>, component: jecs.Component, filter: Types.PlayerFilter?)
	local componentType: Types.ComponentType? = Utils.GetComponentTypeFromComponent(self._components, component)
	if not componentType then
		return
	end

	if filter then
		self._world:set(entity, jecs.pair(componentType.ReplicationType, component), filter)
	else
		self._world:add(entity, jecs.pair(componentType.ReplicationType, component))
	end

	applyFilterToComponentType(self, filter, component)
end

function World:replicateAllComponents(entity: Types.Entity<number>, filter: Types.PlayerFilter?)
	for _, component: Types.ComponentType in pairs(self._components) do
		if not self._world:has(entity, component) then
			continue
		end

		if filter then
			self._world:set(entity, jecs.pair(component.ReplicationType, component.Component), filter)
		else
			self._world:add(entity, jecs.pair(component.ReplicationType, component.Component))
		end

		applyFilterToComponentType(self, filter, component.Component)
	end
end

function World:stopReplicatingComponent(entity: Types.Entity<number>, component: Types.Component)
	local componentType: Types.ComponentType? = Utils.GetComponentTypeFromComponent(self._components, component)
	if not componentType then
		return
	end

	self._world:remove(entity, jecs.pair(componentType.ReplicationType, component))

	applyFilterToComponentType(self, nil, component)
end

function World:stopReplicatingAllComponents(entity: Types.Entity<number>)
	for _, component: Types.ComponentType in pairs(self._components) do
		if not self._world:has(entity, component) then
			continue
		end

		self._world:remove(entity, jecs.pair(component.ReplicationType, component.Component))

		applyFilterToComponentType(self, nil, component.Component)
	end
end

return Server
