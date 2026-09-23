local RunService = game:GetService("RunService")

local Client = require(script.Client)
local replecs = require(script.Packages.replecs)
local Server = require(script.Server)
local Types = require(script.Types)
local Utils = require(script.Utils)

export type Entity<T> = Types.Entity<T>
export type Component = Types.Component
export type ReplicationType = Types.ReplicationType

const IS_SERVER: boolean = RunService:IsServer()
const IS_DEBUG: boolean = true

local inited: boolean = false
local started: boolean = false

local ReplicationType = table.freeze({
	Reliable = replecs.reliable,
	Unreliable = replecs.unreliable,
	NonReplicated = 0,
})

local function init(worlds: { Types.Server | Types.Client })
	assert(not inited, "Ecsence has already been initialized!")
	inited = true

	if IS_DEBUG then
		warn("Initializing Ecsence...")
		warn(`Initializing {Utils.CountDictionary(worlds)} worlds...`)
	end
end

local function start()
	assert(inited, "Ecsence hasn't been initialized.")
	assert(not started, "Ecsence has already started!")
	started = true

	if IS_DEBUG then
		warn("Starting Ecsence...")
	end
end

local function newServerWorld(components: Types.ComponentDefinitions): Types.Server
	return Server.new(components)
end

local function newClientWorld(components: Types.ComponentDefinitions): Types.Client
	return Client.new(components)
end

local function newWorld(components: Types.ComponentDefinitions): Types.Server | Types.Client
	if IS_SERVER then
		return newServerWorld(components)
	else
		return newClientWorld(components)
	end
end

local function newComponent(replicationType: ReplicationType?): Types.ComponentDefinition
	return {
		ComponentType = "Component",
		ReplicationType = replicationType,
	}
end

local function newTag(replicationType: ReplicationType?): Types.ComponentDefinition
	return {
		ComponentType = "Tag",
		ReplicationType = replicationType or ReplicationType.NonReplicated,
	}
end

return table.freeze({
	init = init,
	start = start,
	world = {
		new = newWorld,
		server = newServerWorld,
		client = newClientWorld,
	},
	component = newComponent,
	tag = newTag,
	replicationType = ReplicationType,
})
