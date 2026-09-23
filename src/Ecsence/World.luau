local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(script.Parent.Types)
local jecs = require(ReplicatedStorage.Ecsence.Packages.jecs)
local replecs = require(ReplicatedStorage.Ecsence.Packages.replecs)

local World = {}
World.__index = function(self, key)
	local ecsenceMethod = rawget(World, key)

	if ecsenceMethod ~= nil then
		return ecsenceMethod
	end

	return self._world[key]
end

function World.new(components: Types.ComponentDefinitions): Types.World
	local self = setmetatable({}, World)

	self._world = jecs.World.new()
	self._components = {}

	for name: string, componentDefinition: Types.ComponentDefinition in pairs(components) do
		local component: Types.Component = componentDefinition.ComponentType == "Component" and self._world:component()
			or self._world:entity()
		self._world:set(component, jecs.Name, name)
		self._world:add(component, replecs.shared)
		self._components[componentDefinition] = {
			Component = component,
			ReplicationType = componentDefinition.ReplicationType,
			Filter = {},
		}
	end

	return self
end

function World:getComponent(definition: Types.ComponentDefinition): Types.Component
	return self._components[definition].Component
end

function World:_getComponentType(definition: Types.ComponentDefinition): Types.ComponentType
	return self._components[definition]
end

return World
