local addonName, addon = ...

if UnitClassBase('player') ~= 'HUNTER' then
	return
end

local FETCH_SPELL_ID = 1232995

local BIND_DRIVER = [[
if newstate == 'none' then
	self:ClearBindings()
else
	self:SetBindingClick(false, newstate, self:GetName())
end
]]

local TARGET_MACRO = [[
/target [@mouseover,dead,harm,exists]
/targetlastenemy [@target,noexists]
]]

local button = CreateFrame('Button', addonName .. 'Fetch', nil, 'SecureActionButtonTemplate, SecureHandlerStateTemplate')
button:RegisterForClicks('AnyUp', 'AnyDown')
button:SetAttribute('_onstate-bind', BIND_DRIVER)
button:SetAttribute('pressAndHoldAction', true)
button:SetAttribute('type1', 'macro')
button:SetAttribute('macrotext', TARGET_MACRO)
button:SetAttribute('spell', FETCH_SPELL_ID)
button:SetAttribute('typerelease', 'spell')

local function resetOverride()
	-- we need to trigger unbinding before we unregister the driver
	RegisterAttributeDriver(button, 'state-bind', 'none')
	UnregisterAttributeDriver(button, 'state-bind')
end

local function overrideButton(key, actionSlot)
	local conditions = ''
	if actionSlot >= 1 and actionSlot <= 12 then
		-- ensure overriden bars are always used (bonusbar:5 is dragonriding)
		conditions = '[vehicleui][overridebar][possessbar][bonusbar:5] none; '
	end

	-- use state driver to deal with override buttons
	RegisterAttributeDriver(button, 'state-bind', conditions .. key)

	-- addon:Print('Fetch active')
end

local function getActionBindingCommand(actionSlot)
	if actionSlot >= 1 and actionSlot <= 12 then
		return 'ACTIONBUTTON' .. actionSlot
	elseif actionSlot >= 25 and actionSlot <= 36 then
		return 'MULTIACTIONBAR3BUTTON' .. (actionSlot - 24)
	elseif actionSlot >= 37 and actionSlot <= 48 then
		return 'MULTIACTIONBAR4BUTTON' .. (actionSlot - 36)
	elseif actionSlot >= 49 and actionSlot <= 60 then
		return 'MULTIACTIONBAR2BUTTON' .. (actionSlot - 48)
	elseif actionSlot >= 61 and actionSlot <= 72 then
		return 'MULTIACTIONBAR1BUTTON' .. (actionSlot - 60)
	elseif actionSlot >= 145 and actionSlot <= 156 then
		return 'MULTIACTIONBAR5BUTTON' .. (actionSlot - 144)
	elseif actionSlot >= 157 and actionSlot <= 168 then
		return 'MULTIACTIONBAR6BUTTON' .. (actionSlot - 156)
	elseif actionSlot >= 169 and actionSlot <= 180 then
		return 'MULTIACTIONBAR7BUTTON' .. (actionSlot - 168)
	end
end

local function updateSpells()
	resetOverride()

	-- scan bars for the fetch spell
	for actionSlot = 1, 180 do
		local kind, id = GetActionInfo(actionSlot)
		if kind == 'spell' and id == FETCH_SPELL_ID then
			-- find the button type and index (e.g. the action command)
			local command = getActionBindingCommand(actionSlot)
			if command then
				-- find the key(s) bound to that button and override them
				local key1, key2 = GetBindingKey(command)
				if key1 then
					overrideButton(key1, actionSlot)
				end
				if key2 then
					overrideButton(key1, actionSlot)
				end
			end
		end
	end
end

function addon:ACTIONBAR_SLOT_CHANGED(actionSlot)
	local kind, id = GetActionInfo(actionSlot)
	if kind == 'spell' and id == FETCH_SPELL_ID then
		addon:Defer(updateSpells)
	end
end

function addon:PLAYER_SPECIALIZATION_CHANGED(unit)
	if unit == 'player' then
		addon:Defer(updateSpells)
	end
end

function addon:UPDATE_BINDINGS()
	addon:Defer(updateSpells)
end

function addon:PLAYER_LOGIN()
	addon:Defer(updateSpells)
end
