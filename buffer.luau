--[[

	Notes:
	
	Upcoming changes:
	Adding physics methods such as writing & reading CFrames, etc
	Adding 24 bit types
	
	
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





local INT_RANGES = {
	
	i2 = {
		
		minimum_size = -1,
		maximum_size = 1
		
		
	},
	
}


local bit_buffer = {}
bit_buffer.__index = bit_buffer


type self_t = typeof(bit_buffer) & {

	buffer:buffer,
	bit_offset:number,
	size:number,
	

}


--[[local function make_read_signed(bits:number)
	return function(self)
		local signed = buffer.readbits(self.buffer, self.bit_offset, bits)
		self.bit_offset += bits
		return signed - 2^((bits - 1) - 1)
	end
end


local function make_write_signed(bits:number)
	return function(self, signed:number)
		buffer.writebits(self.buffer, self.bit_offset, bits, signed + 2^((bits - 1) - 1))
		self.bit_offset += bits
	end
end


local function make_write_unsigned(bits:number)
	return function(self, unsigned:number)
		buffer.writebits(self.buffer, self.bit_offset, bits, unsigned)
		self.bit_offset += bits
	end
end


local function make_read_unsigned(bits:number)
	return function(self)
		local unsigned = buffer.readbits(self.buffer, self.bit_offset, bits)
		self.bit_offset -= bits
		return unsigned
	end
end


for bit_size = 1, 32 do
	bit_buffer[`write_i{bit_size}`] = make_write_signed(bit_size)
	bit_buffer[`read_i{bit_size}`] = make_read_unsigned(bit_size)
	bit_buffer[`write_u{bit_size}`] = make_write_unsigned(bit_size)
	bit_buffer[`read_u{bit_size}`] = make_read_unsigned(bit_size)
end]]


function bit_buffer.new(size:number):self_t
	
	local self = setmetatable({}, bit_buffer) --had to do it here instead of at return, as I don't think there's any type check for metatables.
	
	self.buffer = buffer.create(size)
	self.size = size
	self.bit_offset = 0
	
	return self
end





--signed: 2^size = how much to subtract

function bit_buffer:write_i2(i2:number) buffer.writebits(self.buffer, self.bit_offset, 2, i2+2^1) self.bit_offset += 2 end
function bit_buffer:write_i4(i4:number) buffer.writebits(self.buffer, self.bit_offset, 4, i4+2^3) self.bit_offset += 4 end
function bit_buffer:write_i6(i6:number) buffer.writebits(self.buffer, self.bit_offset, 6, i6+2^5) self.bit_offset += 6 end
function bit_buffer:write_i8(i8:number) buffer.writebits(self.buffer, self.bit_offset, 8, i8+2^7) self.bit_offset += 8 end
function bit_buffer:write_i10(i10:number) buffer.writebits(self.buffer, self.bit_offset, 10, i10+2^9) self.bit_offset += 10 end
function bit_buffer:write_i12(i12:number) buffer.writebits(self.buffer, self.bit_offset, 12, i12+2^11) self.bit_offset += 12 end
function bit_buffer:write_i14(i14:number) buffer.writebits(self.buffer, self.bit_offset, 14, i14+2^13) self.bit_offset += 14 end
function bit_buffer:write_i16(i16:number) buffer.writebits(self.buffer, self.bit_offset, 16, i16+2^15) self.bit_offset += 16 end
function bit_buffer:write_i18(i18:number) buffer.writebits(self.buffer, self.bit_offset, 18, i18+2^17) self.bit_offset += 18 end
function bit_buffer:write_i20(i20:number) buffer.writebits(self.buffer, self.bit_offset, 20, i20+2^19) self.bit_offset += 20 end
function bit_buffer:write_i22(i22:number) buffer.writebits(self.buffer, self.bit_offset, 22, i22+2^21) self.bit_offset += 22 end
function bit_buffer:write_i24(i24:number) buffer.writebits(self.buffer, self.bit_offset, 24, i24+2^23) self.bit_offset += 24 end
function bit_buffer:write_i26(i26:number) buffer.writebits(self.buffer, self.bit_offset, 26, i26+2^25) self.bit_offset += 26 end
function bit_buffer:write_i28(i28:number) buffer.writebits(self.buffer, self.bit_offset, 28, i28+2^27) self.bit_offset += 28 end
function bit_buffer:write_i30(i30:number) buffer.writebits(self.buffer, self.bit_offset, 30, i30+2^29) self.bit_offset += 30 end
function bit_buffer:write_i32(i32:number) buffer.writebits(self.buffer, self.bit_offset, 32, i32+2^31) self.bit_offset += 32 end

function bit_buffer:write_u2(u2:number) buffer.writebits(self.buffer, self.bit_offset, 2, u2) self.bit_offset += 2 end
function bit_buffer:write_u4(u4:number) buffer.writebits(self.buffer, self.bit_offset, 4, u4) self.bit_offset += 4 end
function bit_buffer:write_u6(u6:number) buffer.writebits(self.buffer, self.bit_offset, 6, u6) self.bit_offset += 6 end
function bit_buffer:write_u8(u8:number) buffer.writebits(self.buffer, self.bit_offset, 8, u8) self.bit_offset += 8 end
function bit_buffer:write_u10(u10:number) buffer.writebits(self.buffer, self.bit_offset, 10, u10) self.bit_offset += 10 end
function bit_buffer:write_u12(u12:number) buffer.writebits(self.buffer, self.bit_offset, 12, u12) self.bit_offset += 12 end
function bit_buffer:write_u14(u14:number) buffer.writebits(self.buffer, self.bit_offset, 14, u14) self.bit_offset += 14 end
function bit_buffer:write_u16(u16:number) buffer.writebits(self.buffer, self.bit_offset, 16, u16) self.bit_offset += 16 end
function bit_buffer:write_u18(u18:number) buffer.writebits(self.buffer, self.bit_offset, 18, u18) self.bit_offset += 18 end
function bit_buffer:write_u20(u20:number) buffer.writebits(self.buffer, self.bit_offset, 20, u20) self.bit_offset += 20 end
function bit_buffer:write_u22(u22:number) buffer.writebits(self.buffer, self.bit_offset, 22, u22) self.bit_offset += 22 end
function bit_buffer:write_u24(u24:number) buffer.writebits(self.buffer, self.bit_offset, 24, u24) self.bit_offset += 24 end
function bit_buffer:write_u26(u26:number) buffer.writebits(self.buffer, self.bit_offset, 26, u26) self.bit_offset += 26 end
function bit_buffer:write_u28(u28:number) buffer.writebits(self.buffer, self.bit_offset, 28, u28) self.bit_offset += 28 end
function bit_buffer:write_u30(u30:number) buffer.writebits(self.buffer, self.bit_offset, 30, u30) self.bit_offset += 30 end
function bit_buffer:write_u32(u32:number) buffer.writebits(self.buffer, self.bit_offset, 32, u32) self.bit_offset += 32 end

function bit_buffer:read_i2() self.bit_offset -= 2 return buffer.readbits(self.buffer, self.bit_offset, 2) - 2^1 end
function bit_buffer:read_i4() self.bit_offset -= 4 return buffer.readbits(self.buffer, self.bit_offset, 4) - 2^3 end
function bit_buffer:read_i6() self.bit_offset -= 6 return buffer.readbits(self.buffer, self.bit_offset, 6) - 2^5 end
function bit_buffer:read_i8() self.bit_offset -= 8 return buffer.readbits(self.buffer, self.bit_offset, 8) - 2^7 end
function bit_buffer:read_i10() self.bit_offset -= 10 return buffer.readbits(self.buffer, self.bit_offset, 10) - 2^9 end
function bit_buffer:read_i12() self.bit_offset -= 12 return buffer.readbits(self.buffer, self.bit_offset, 12) - 2^11 end
function bit_buffer:read_i14() self.bit_offset -= 14 return buffer.readbits(self.buffer, self.bit_offset, 14) - 2^13 end
function bit_buffer:read_i16() self.bit_offset -= 16 return buffer.readbits(self.buffer, self.bit_offset, 16) - 2^15 end
function bit_buffer:read_i18() self.bit_offset -= 18 return buffer.readbits(self.buffer, self.bit_offset, 18) - 2^17 end
function bit_buffer:read_i20() self.bit_offset -= 20 return buffer.readbits(self.buffer, self.bit_offset, 20) - 2^19 end
function bit_buffer:read_i22() self.bit_offset -= 22 return buffer.readbits(self.buffer, self.bit_offset, 22) - 2^21 end
function bit_buffer:read_i24() self.bit_offset -= 24 return buffer.readbits(self.buffer, self.bit_offset, 24) - 2^23 end
function bit_buffer:read_i26() self.bit_offset -= 26 return buffer.readbits(self.buffer, self.bit_offset, 26) - 2^25 end
function bit_buffer:read_i28() self.bit_offset -= 28 return buffer.readbits(self.buffer, self.bit_offset, 28) - 2^27 end
function bit_buffer:read_i30() self.bit_offset -= 30 return buffer.readbits(self.buffer, self.bit_offset, 30) - 2^29 end
function bit_buffer:read_i32() self.bit_offset -= 32 return buffer.readbits(self.buffer, self.bit_offset, 32) - 2^31 end


return bit_buffer
