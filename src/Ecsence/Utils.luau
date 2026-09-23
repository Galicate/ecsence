local Types = require(script.Parent.Types)

local Utils = {}

function Utils.CountDictionary(dict): number
	local count = 0

	for _ in pairs(dict) do
		count = count + 1
	end

	return count
end

function Utils.GetComponentTypeFromComponent(
	components: { [string]: Types.ComponentType },
	component: Types.Component
): Types.ComponentType | nil?
	for _, componentType: Types.ComponentType in pairs(components) do
		if componentType.Component == component then
			return componentType
		end
	end
	return nil
end

return Utils
