local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ecsence = require(ReplicatedStorage.Ecsence)

return {
	Reliable = Ecsence.component(Ecsence.replicationType.Reliable),
	Unreliable = Ecsence.component(Ecsence.replicationType.Unreliable),
	NonReplicated = Ecsence.component(),
	ReliableTag = Ecsence.tag(Ecsence.replicationType.Reliable),
}
