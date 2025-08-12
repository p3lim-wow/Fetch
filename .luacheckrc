std = 'lua51'

quiet = 1 -- suppress report output for files without warnings

-- see https://luacheck.readthedocs.io/en/stable/warnings.html#list-of-warnings
-- and https://luacheck.readthedocs.io/en/stable/cli.html#patterns
ignore = {
	'122', -- overriding object methods
	'212/self', -- unused argument self
	'212/event', -- unused argument event
	'212/unit', -- unused argument unit
	'312/event', -- unused value of argument event
	'312/unit', -- unused value of argument unit
	'431', -- shadowing an upvalue
	'631', -- line is too long
}

globals = {
	-- exposed globals

	-- mutating globals
}

read_globals = {
	-- table = {fields = {'wipe'}},

	-- FrameXML objects

	-- FrameXML constants

	-- FrameXML functions
	'RegisterAttributeDriver',
	'UnregisterAttributeDriver',

	-- GlobalStrings

	-- namespaces

	-- API
	'UnitClassBase',
	'CreateFrame',
	'GetActionInfo',
	'GetBindingKey',
}
