--- **LibDataBroker-1.1** provides a simple data exchange protocol for addons.
-- @class file
-- @name LibDataBroker-1.1
local MAJOR, MINOR = "LibDataBroker-1.1", 4
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end

lib.callbacks = lib.callbacks or LibStub("CallbackHandler-1.0"):New(lib)
lib.attributestorage, lib.namestorage, lib.proxystorage = lib.attributestorage or {}, lib.namestorage or {}, lib.proxystorage or {}

local attributestorage, namestorage, callbacks = lib.attributestorage, lib.namestorage, lib.callbacks

local donothing = function() end

local function RemoveAttributeStorage(name)
	for attribute, storageattribute in pairs(attributestorage) do
		if storageattribute[name] then
			storageattribute[name] = nil
		end
	end
end

local function CreateProxyObject(name)
	local dataobj = {}
	
	setmetatable(dataobj, {
		__index = function(self, key)
			if key == "name" then return name end
			if attributestorage[key] then
				return attributestorage[key][name]
			end
		end,
		
		__newindex = function(self, key, value)
			if key == "name" then return end
			attributestorage[key] = attributestorage[key] or {}
			attributestorage[key][name] = value
			callbacks:Fire("LibDataBroker_AttributeChanged", name, key, value, dataobj)
			callbacks:Fire(("LibDataBroker_AttributeChanged_%s"):format(name), name, key, value, dataobj)
			callbacks:Fire(("LibDataBroker_AttributeChanged_%s_%s"):format(name, key), name, key, value, dataobj)
			callbacks:Fire(("LibDataBroker_AttributeChanged__%s"):format(key), name, key, value, dataobj)
		end,
	})
	
	return dataobj
end

--- Create a new data object.
-- @param name The name of the data object
-- @param dataobject The data object table (optional)
-- @return The data object
function lib:NewDataObject(name, dataobject)
	if self.proxystorage[name] then return end
	
	if dataobject then
		-- Store attributes
		for k, v in pairs(dataobject) do
			attributestorage[k] = attributestorage[k] or {}
			attributestorage[k][name] = v
		end
	end
	
	namestorage[name] = true
	local dataobj = CreateProxyObject(name)
	self.proxystorage[name] = dataobj
	
	callbacks:Fire("LibDataBroker_DataObjectCreated", name, dataobj)
	return dataobj
end

--- Get a data object by name.
-- @param name The name of the data object
-- @return The data object
function lib:GetDataObjectByName(name)
	return self.proxystorage[name]
end

--- Get the name of a data object.
-- @param dataobject The data object
-- @return The name
function lib:GetNameByDataObject(dataobject)
	for name, obj in pairs(self.proxystorage) do
		if obj == dataobject then
			return name
		end
	end
end

--- Iterate through all data objects.
-- @return iterator
function lib:DataObjectIterator()
	return pairs(self.proxystorage)
end

--- Get a list of all data objects.
-- @return A table of data objects
function lib:GetDataObjects()
	return self.proxystorage
end

-- Backwards compatibility
lib.pairs = lib.DataObjectIterator
