local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Ecsence = require(ReplicatedStorage.Ecsence)
local Worlds = require(script.Worlds)

Ecsence.init(Worlds)
Ecsence.start()
