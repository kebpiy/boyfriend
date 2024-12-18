--[
-- Globals
--]
FILENAME = "input" -- name of the file that you want to read from

NUM_REGISTERS = 4 -- number of total registers that should be supported

REGISTERS = {} -- list of all registers [1-NUM_REGISTERS]
for i = 1, NUM_REGISTERS do
	REGISTERS[i] = 1
end

CURRENT_REGISTER = 1 -- which register the program is currently focused on

MAX_INT = 16 -- maximum possible value that can be stored in a register before looping back to 0

LOOP_STACK = {} -- empty if not in a loop
-- if in a loop, contains the address of the beginning of the innermost loop

PROGRAM_COUNTER = 1 -- keeps track of the current index/instruction to run

--[
-- Operation declarations
--]
function R_shift()
	CURRENT_REGISTER = CURRENT_REGISTER + 1
	if CURRENT_REGISTER > NUM_REGISTERS then
		CURRENT_REGISTER = 0
	end
	PROGRAM_COUNTER = PROGRAM_COUNTER + 1
end

function L_shift()
	CURRENT_REGISTER = CURRENT_REGISTER - 1
	if CURRENT_REGISTER < 1 then
		CURRENT_REGISTER = NUM_REGISTERS
	end
	PROGRAM_COUNTER = PROGRAM_COUNTER + 1
end

function Inc()
	REGISTERS[CURRENT_REGISTER] = REGISTERS[CURRENT_REGISTER] + 1
	if REGISTERS[CURRENT_REGISTER] > MAX_INT then
		REGISTERS[CURRENT_REGISTER] = 1
	end
	PROGRAM_COUNTER = PROGRAM_COUNTER + 1
end

function Dec()
	REGISTERS[CURRENT_REGISTER] = REGISTERS[CURRENT_REGISTER] - 1
	if REGISTERS[CURRENT_REGISTER] < 1 then
		REGISTERS[CURRENT_REGISTER] = MAX_INT
	end
	PROGRAM_COUNTER = PROGRAM_COUNTER + 1
end

function Begin_loop()
	PROGRAM_COUNTER = PROGRAM_COUNTER + 1
	table.insert(LOOP_STACK, PROGRAM_COUNTER)
end

function End_loop()
	if REGISTERS[CURRENT_REGISTER] == 1 then
		table.remove(LOOP_STACK)
		PROGRAM_COUNTER = PROGRAM_COUNTER + 1
	else
		PROGRAM_COUNTER = LOOP_STACK[#LOOP_STACK]
	end
end

function Input_one()
	-- get user input of one number
	local s = io.read("*n")
	REGISTERS[CURRENT_REGISTER] = s % MAX_INT
	PROGRAM_COUNTER = PROGRAM_COUNTER + 1
end

function Print_one()
	print("Value of register " .. CURRENT_REGISTER .. " is " .. REGISTERS[CURRENT_REGISTER])
	PROGRAM_COUNTER = PROGRAM_COUNTER + 1
end

--[
-- Function to visualize the state of the registers
--]
function Reg_dump()
	for i, v in ipairs(REGISTERS) do
		io.write(string.format("%d ", v))
	end
	print()
end

--[
-- Define a symbol lookup table, that associates each input symbol with the
-- corresponding function to run
--]
SYMBOL_TABLE = {
	["<"] = L_shift,
	[">"] = R_shift,
	["+"] = Inc,
	["-"] = Dec,
	["["] = Begin_loop,
	["]"] = End_loop,
	[","] = Input_one,
	["."] = Print_one,
}

-- Open and read the file into `input`
local file = io.open(FILENAME, "r")
if not file then
	error("could not open file: " .. FILENAME)
end
local input = file:read("*all")

-- split up the input file into characters, removing all whitespace
local inputArray = {}
for char in input:gmatch("%S") do
	table.insert(inputArray, char)
	print(char)
end

-- now all chars are stored in inputArray. Need to process them

-- run through every input symbol and execute them
while PROGRAM_COUNTER < #inputArray + 1 do
	SYMBOL_TABLE[inputArray[PROGRAM_COUNTER]]()
	-- Reg_dump()
end
