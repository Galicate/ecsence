local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Ecsence.Packages.jecs)
local replecs = require(ReplicatedStorage.Ecsence.Packages.replecs)

-- ECS

export type Entity<T> = jecs.Entity<T>
export type Component = jecs.Component

export type ComponentType = {
	Component: Component,
	ReplicationType: ReplicationType,
	Filter: PlayerFilter,
}

export type ComponentDefinition = {
	ComponentType: string,
	ReplicationType: ReplicationType,
}

export type ComponentDefinitions = {
	[string]: ComponentDefinition,
}

-- Replication

export type ReplicationType = jecs.Component

export type PlayerFilter = {
	[Player]: boolean,
} | Player

-- Scheduling

-- Worlds
export type World = {
	_components: { [string]: ComponentType },
	new: (ComponentDefinitions) -> World,
	getComponent: (self: World, ComponentDefinition) -> Component,
}

export type Server = {
	_replicator: replecs.Server,
	replicateEntity: (self: Server, entity: Entity<number>, filter: PlayerFilter?) -> (),
	stopReplicatingEntity: (self: Server, entity: Entity<number>) -> (),
	replicateComponent: (
		self: Server,
		entity: Entity<number>,
		component: jecs.Component,
		filter: PlayerFilter?
	) -> (),
	replicateAllComponents: (self: Server, entity: Entity<number>, filter: PlayerFilter?) -> (),
	stopReplicatingComponent: (self: Server, entity: Entity<number>, component: jecs.Component) -> (),
	stopReplicatingAllComponents: (self: Server, entity: Entity<number>) -> (),
} & World & jecs.World

export type Client = {
	_replicator: replecs.Client,
	applyUpdates: (self: Client, buf: buffer, variants: { { any } }) -> (),
	applyUnreliables: (self: Client, buf: buffer, variants: { { any } }) -> (),
	applyFull: (self: Client, buf: buffer, variants: { { any } }) -> (),
} & World & jecs.World

return nil
