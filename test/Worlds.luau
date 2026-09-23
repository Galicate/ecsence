local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ecsence = require(ReplicatedStorage.Ecsence)
local Components = require(script.Parent.Components)

return {
	Ecsence.world.new(Components),
}
