--!strict
--!native
--!optimize 2


--[[

	Notes:
	Bytes are used over bits because they're faster
	You must add your own Buffer:write_foobar() function & type
	Variables will be stylised in snake_case, as I like how they look compared to the C++ types
	Strings will be max size of u16
	Strings will be 2 + #string due to the fact of that I need to store a length variable.


	--Types--		--Size in bytes--		--Notes--
	
	Numbers
	
	u8				1						0 to 255
	u16				2						0 to 65,535
	u32				4						0 to 4,294,967,295
	
	i8				1						-128 to 127
	i16				2						-32,768 to 32,767
	i32				4						-2,147,483,648 to 2,147,483,647
	
	f32				4						32bit float
	f64				8						64bit double
	
	bool			1						usually stored as a u8
	char			1						usually stored as a u8
	string			2 + #string				foobar123
]]


--Constants--

local SIZES = {

	u8 = 1,
	u16 = 2,
	u32 = 4,
	u64 = 8,

	i8 = 1,
	i16 = 2,
	i32 = 4,
	i64 = 8,

	f32 = 4,
	f64 = 8,

	bool = 1,
	char = 1,
	
	--String will take 2 + #string as mentioned above
	--This is due to the fact that I need to store length of string with u16
	--Yes I can just set length of read of string but what if you send the script of bee movie
	--(Meaning bad practice)

}


local CHARACTERS = {

	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	"!",
	"@",
	"#",
	"$",
	"%",
	"^",
	"&",
	"*",
	"(",
	")",
	"-",
	"_",
	"=",
	"+",
	"[",
	"]",
	"{",
	"}",
	";",
	":",
	"'",
	"<",
	">",
	",",
	".",
	"/",
	"?",
	"`",
	"~",
	" ",
	"0",

}


--Types--

export type buffer_self = {

	buffer:buffer,
	offset:number,
	size:number,
	struct:{[number]:string},
	current_read_indice:number,

}


--Module--

local Buffer = {}
Buffer.__index = Buffer


--Public Functions--

--Constructor for the buffer wrapper.
function Buffer.new(size:number)
	
	assert(type(size) == "number", "Size for buffer is NaN.")
	assert(size > 0, `Cannot input {size} as buffer size, must be a natural number.`)

	local self = setmetatable({}, Buffer)

	self.buffer = buffer.create(size)
	self.offset = 0
	self.size = size
	self.struct = {}
	self.current_read_indice = 1 --Starts at 1, because lua(u) has arrays starting at 1. Just remember!

	
	return self :: buffer_self
end


--=======UNSIGNED INTEGERS======--
--=======UNSIGNED INTEGERS======--
--=======UNSIGNED INTEGERS======--
--=======UNSIGNED INTEGERS======--
--=======UNSIGNED INTEGERS======--


function Buffer:write_u8(u8:number)
	
	assert(type(u8) == "number", "Unsigned8 is NaN.")
	
	assert(self.offset + SIZES.u8 <= (self.size :: number), `Buffer overflow while trying to insert {u8} into buffer.`)
	assert(u8 <= 255, `Unsigned8 {u8} cannot be bigger than 255.`)
	assert(u8 >= 0, `uints cannot be negative ({u8})`)


	buffer.writeu8(self.buffer, self.offset, u8)
	self.offset += SIZES.u8
	
	table.insert(self.struct, "u8")
end


function Buffer:write_u16(u16:number)
	
	assert(type(u16) == "number", "Unsigned16 is NaN.")

	assert(self.offset + SIZES.u16 <= (self.size :: number), `Buffer overflow while trying to insert {u16} into buffer.`)
	assert(u16 <= 65_535, `Unsigned16 {u16} cannot be bigger than 65,535.`)
	assert(u16 >= 0, `uints cannot be negative ({u16})`)


	buffer.writeu16(self.buffer, self.offset, u16)
	self.offset += SIZES.u16

	table.insert(self.struct, "u16")
end


function Buffer:write_u32(u32:number)
	
	assert(type(u32) == "number", "Unsigned32 is NaN.")

	assert(self.offset + SIZES.u32 <= (self.size :: number), `Buffer overflow while trying to insert {u32} into buffer.`)
	assert(u32 <= 4_294_967_295, `Unsigned {u32} cannot be bigger than 4,294,967,295.`)
	assert(u32 >= 0, `uints cannot be negative ({u32})`)


	buffer.writeu32(self.buffer, self.offset, u32)
	self.offset += SIZES.u32

	table.insert(self.struct, "u32")
end


--=======SIGNED INTEGERS=======--
--=======SIGNED INTEGERS=======--
--=======SIGNED INTEGERS=======--
--=======SIGNED INTEGERS=======--
--=======SIGNED INTEGERS=======--


function Buffer:write_i8(i8:number)
	
	assert(type(i8) == "number", "Signed8 is NaN.")

	assert(self.offset + SIZES.i8 <= (self.size :: number), `Buffer overflow while trying to insert {i8} into buffer.`)
	assert(i8 >= -128 and i8 <= 127, `Signed i8 must be between -128 and 127 ({i8})`)


	buffer.writei8(self.buffer, self.offset, i8)
	self.offset += SIZES.i8

	table.insert(self.struct, "i8")
end


function Buffer:write_i16(i16:number)
	
	assert(type(i16) == "number", "Signed16 is NaN.")

	assert(self.offset + SIZES.i16 <= (self.size :: number), `Buffer overflow while trying to insert {i16} into buffer.`)
	assert(i16 >= -32_768 and i16 <= 32_767, `Signed i16 must be between -32,768 and 32,767 ({i16})`)


	buffer.writei16(self.buffer, self.offset, i16)
	self.offset += SIZES.i16
	
	table.insert(self.struct, "i16")
end


function Buffer:write_i32(i32:number)
	
	assert(type(i32) == "number", "Signed32 is NaN.")

	assert(self.offset + SIZES.i32 <= (self.size :: number), `Buffer overflow while trying to insert {i32} into buffer.`)
	assert(i32 >= -2_147_483_648 and i32 <= 2_147_483_647, `Signed i32 must be between -2,147,483,648 and 2,147,483,647 ({i32})`)

	
	buffer.writei32(self.buffer, self.offset, i32)
	self.offset += SIZES.i32

	table.insert(self.struct, "i32")
end


--=======FLOATS=======--
--=======FLOATS=======--
--=======FLOATS=======--
--=======FLOATS=======--
--=======FLOATS=======--


function Buffer:writef32(f32:number)
	
	assert(type(f32) == "number", "Float32 is NaN.")

	assert(self.offset + SIZES.f32 <= (self.size :: number), `Buffer overflow while trying to insert {f32} into buffer.`)


	buffer.writef32(self.buffer, self.offset, f32)
	self.offset += SIZES.f32

	table.insert(self.struct, "f32")
end


function Buffer:writef64(f64:number)
	
	assert(type(f64) == "number", "Float32 is NaN.")

	assert(self.offset + SIZES.f64 <= (self.size :: number), `Buffer overflow while trying to insert {f64} into buffer.`)


	buffer.writef64(self.buffer, self.offset, f64)
	self.offset += SIZES.f64

	table.insert(self.struct, "f64")
end


--=======MISCELLANEOUS=======--
--=======MISCELLANEOUS=======--
--=======MISCELLANEOUS=======--
--=======MISCELLANEOUS=======--
--=======MISCELLANEOUS=======--


function Buffer:write_bool(bool:boolean)

	assert(self.offset + SIZES.bool <= (self.size :: number), `Buffer overflow while trying to insert {bool} into buffer.`)


	buffer.writeu8(self.buffer, self.offset, bool and 1 or 0)
	self.offset += SIZES.bool

	table.insert(self.struct, "bool")
end


function Buffer:write_char(char:string)
	
	assert(self.offset + SIZES.char <= (self.size :: number), `Buffer overflow while trying to insert {char} into buffer.`)
	assert(table.find(CHARACTERS, char) ~= nil, `Character not found in character list ({char})`)


	--Luau strict type solver says that self.offset in writeu8 is invalid because of 3rd parameter, however it is very valid.
	buffer.writeu8(self.buffer, self.offset, table.find(CHARACTERS, char))
	self.offset += SIZES.char

	table.insert(self.struct, "char")
end


function Buffer:write_str(str:string)
	
	assert(type(str) == "string", "String provided is not a string.")
	
	--Using u16 because I don't think anyone will send a string with a size over 65,355 bytes
	assert(self.offset + SIZES.u16 + #str <= (self.size :: number), `Buffer overflow while trying to insert {str} into buffer.`)
	assert(#str <= 65_535, `String size is over 65,535.. What are you doing`)
	
	--Also using "str" instead of string since string is a lua library.
	buffer.writeu16(self.buffer, self.offset, #str)
	self.offset += SIZES.u16 --store length of string for easy access
	
	buffer.writestring(self.buffer, self.offset, str, #str) --Added 4th parameter for readability, I hate you suphi kaner!!
	self.offset += #str
	
	table.insert(self.struct, "str")
end


--Returns read offset from 0 to indice. Optionally include a custom_indice parameter for it to use that instead
function Buffer:get_read_offset_by_read_indice(custom_indice:number?):(number, keyof<typeof(SIZES)>|"str")
	
	local Index_read_indice_stop_point_thing = custom_indice or self.current_read_indice :: number
	
	local read_offset = 0
	local read_type = self.struct[Index_read_indice_stop_point_thing]
	
	assert(Index_read_indice_stop_point_thing <= #self.struct, "Length of custom indice cannot be larger than buffer struct.")
	
	for Index = 1, Index_read_indice_stop_point_thing :: number - 1 do
		read_offset += (SIZES[self.struct[Index]]::number)
		
		if self.struct[Index] == "str" then
			read_offset += SIZES.u16
		end
	end
	
	return read_offset, read_type :: keyof<typeof(SIZES)>|"str"
end


--Reads next buffer indice, regardless of type
function Buffer:read_next_indice():unknown
	
	local read_offset, read_type = self:get_read_offset_by_read_indice();
	
	(self::buffer_self).current_read_indice += 1
	
	return self[`read_{read_type}`](self, read_offset)
end


--Reads a u8 from read_offset. Optionally leave it blank to read the next u8 it finds.
function Buffer:read_u8(read_offset:number?):number?

	local read_indice = table.find(self.struct, "u8", self.current_read_indice) :: number
	
	if type(read_offset) == "number" then
		
		return buffer.readu8((self::buffer_self).buffer, read_offset)
	elseif read_indice then
		
		return buffer.readu8(self.buffer, self:get_read_offset_by_read_indice(read_indice))
	end
	
	return nil
end


--Reads a u16 from read_offset. Optionally leave it blank to read the next u16 it finds.
function Buffer:read_u16(read_offset:number?):number?

	local read_indice = table.find(self.struct, "u16", self.current_read_indice) :: number

	if type(read_offset) == "number" then

		return buffer.readu16((self::buffer_self).buffer, read_offset)
	elseif read_indice then

		return buffer.readu16(self.buffer, self:get_read_offset_by_read_indice(read_indice))
	end

	return nil
end


--Reads a u32 from read_offset. Optionally leave it blank to read the next u32 it finds.
function Buffer:read_u32(read_offset:number?):number?

	local read_indice = table.find(self.struct, "u32", self.current_read_indice) :: number

	if type(read_offset) == "number" then
		
		assert(read_offset >= 0, "read_offset cannot be negative.")

		return buffer.readu32((self::buffer_self).buffer, read_offset)
	elseif read_indice then

		return buffer.readu32(self.buffer, self:get_read_offset_by_read_indice(read_indice))
	end

	return nil
end



--Reads a i8 from read_offset. Optionally leave it blank to read the next i8 it finds.
function Buffer:read_i8(read_offset:number?):number?
	
	local read_indice = table.find(self.struct, "i8", self.current_read_indice) :: number

	if type(read_offset) == "number" then
		
		assert(read_offset >= 0, "read_offset cannot be negative.")

		return buffer.readi8((self::buffer_self).buffer, read_offset)
	elseif read_indice then

		return buffer.readi8(self.buffer, self:get_read_offset_by_read_indice(read_indice))
	end

	return nil
end


--Reads a i16 from read_offset. Optionally leave it blank to read the next i16 it finds.
function Buffer:read_i16(read_offset:number?):number?

	local read_indice = table.find(self.struct, "i16", self.current_read_indice) :: number

	if type(read_offset) == "number" then

		assert(read_offset >= 0, "read_offset cannot be negative.")

		return buffer.readi16((self::buffer_self).buffer, read_offset)
	elseif read_indice then

		return buffer.readi16(self.buffer, self:get_read_offset_by_read_indice(read_indice))
	end

	return nil
end


--Reads a i32 from read_offset. Optionally leave it blank to read the next i32 it finds.
function Buffer:read_i32(read_offset:number?):number?

	local read_indice = table.find(self.struct, "i32", self.current_read_indice) :: number

	if type(read_offset) == "number" then

		assert(read_offset >= 0, "read_offset cannot be negative.")

		return buffer.readi32((self::buffer_self).buffer, read_offset)
	elseif read_indice then

		return buffer.readi32(self.buffer, self:get_read_offset_by_read_indice(read_indice))
	end

	return nil
end


--Reads a f32 from read_offset. Optionally leave it blank to read the next f32 it finds.
function Buffer:read_f32(read_offset:number?):number?

	local read_indice = table.find(self.struct, "f32", self.current_read_indice) :: number

	if type(read_offset) == "number" then

		assert(read_offset >= 0, "read_offset cannot be negative.")

		return buffer.readf32((self::buffer_self).buffer, read_offset)
	elseif read_indice then

		return buffer.readf32(self.buffer, self:get_read_offset_by_read_indice(read_indice))
	end

	return nil
end



--Reads a f64 from read_offset. Optionally leave it blank to read the next f64 it finds.
function Buffer:read_f64(read_offset:number?):number?

	local read_indice = table.find(self.struct, "f64", self.current_read_indice) :: number

	if type(read_offset) == "number" then

		assert(read_offset >= 0, "read_offset cannot be negative.")

		return buffer.readf64((self::buffer_self).buffer, read_offset)
	elseif read_indice then

		return buffer.readf64(self.buffer, self:get_read_offset_by_read_indice(read_indice))
	end

	return nil
end


--Reads a bool from read_offset. Optionally leave it blank to read the next bool it finds.
function Buffer:read_bool(read_offset:number?):number?

	local read_indice = table.find(self.struct, "bool", self.current_read_indice) :: number

	if type(read_offset) == "number" then

		assert(read_offset >= 0, "read_offset cannot be negative.")

		return buffer.readu8((self::buffer_self).buffer, read_offset)
	elseif read_indice then

		return buffer.readu8(self.buffer, self:get_read_offset_by_read_indice(read_indice))
	end

	return nil
end


--Reads a string from read_offset. Optionally leave it blank to read the next string it finds. Offset should be the position of the u16 string length, the string will be autodetermined.
function Buffer:read_str(read_offset:number?):string?

	local read_indice = table.find((self::buffer_self).struct, "str", self.current_read_indice)
	
	if type(read_offset) == "number" then
		
		assert(read_offset >= 0, "read_offset cannot be negative.")
		
		local str_length = buffer.readu16(self.buffer, read_offset) :: number
		
		--Adding the u16 because length is a u16 before it
		return buffer.readstring(self.buffer, read_offset + SIZES.u16, str_length)
	elseif read_indice then
		
		local read_offset = self:get_read_offset_by_read_indice(read_indice)
		local str_length = buffer.readu16(self.buffer, read_offset)
		
		return buffer.readstring(self.buffer, read_offset + SIZES.u16, str_length)
	end

	return nil
end


return Buffer
