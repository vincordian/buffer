--[[

	Notes:
	
	Upcoming changes:
	Adding physics methods such as writing & reading CFrames, etc
	
	
	You must add your own buffer_module:write_foobar() function & type
	Variables will be stylised in snake_case, as I like how they look compared to the C++ types
	*and also because I'm trying out new cases
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

--!strict
--!native
--!optimize 2


local INT_START_SIZE = 2
local INT_END_SIZE = 32 --This is to not be changed, max int is int32
local INT_SIZE_STEP = 2


local bit_buffer = {}
bit_buffer.__index = bit_buffer


type self_t = typeof(bit_buffer) & {

	buffer:buffer,
	bit_offset:number,
	size:number,
	

}



local function make_write_signed(bit_size:number)
	return function(self, signed:number)
		print(self)
		buffer.writebits(self.buffer, self.bit_offset, bit_size, signed + 2^((bit_size - 1)))
		self.bit_offset += bit_size
	end
end


local function make_write_unsigned(bit_size:number)
	return function(self, unsigned:number)
		print(self)
		buffer.writebits(self.buffer, self.bit_offset, bit_size, unsigned)
		self.bit_offset += bit_size
	end
end


local function make_read_signed(bit_size:number):(self_t) -> number
	return function(self)
		self.bit_offset -= bit_size
		return buffer.readbits(self.buffer, self.bit_offset, bit_size) - 2^((bit_size - 1))
	end
end


local function make_read_unsigned(bit_size:number):(self_t) -> number
	return function(self:self_t)
		self.bit_offset -= bit_size
		return buffer.readbits(self.buffer, self.bit_offset, bit_size)
	end
end


for bit_size = INT_START_SIZE, INT_END_SIZE, INT_SIZE_STEP do
	bit_buffer[`write_i{bit_size}`] = make_write_signed(bit_size)
	bit_buffer[`read_i{bit_size}`] = make_read_signed(bit_size)
	bit_buffer[`write_u{bit_size}`] = make_write_unsigned(bit_size)
	bit_buffer[`read_u{bit_size}`] = make_read_unsigned(bit_size)
end


function bit_buffer.new(size:number):self_t
	
	local self = setmetatable({}, bit_buffer) --had to do it here instead of at return, as I don't think there's any type check for metatables.
	
	self.buffer = buffer.create(size)
	self.size = size
	self.bit_offset = 0
	
	return self
end


return bit_buffer
