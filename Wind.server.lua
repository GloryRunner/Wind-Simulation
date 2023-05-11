local part = workspace.Part

local start_pos = Vector3.new(-1023, 5, -1023) -- to cover the entire baseplate
local stretch_factor = 1/5
local amplitude = 1
local vertical_constant = 10
local x_offset = 1
local period_length = 2 * math.pi / stretch_factor
local step_count = 60

function get_y(x)
	return amplitude * math.sin(stretch_factor * x) + vertical_constant
end

local function create_wave(z_pos)
	local beam_offset = period_length / step_count - 1
	local beams = {}
	for i = 1, step_count / 2 do
		local beam = Instance.new("Beam")
		local beam_a0 = Instance.new("Attachment")
		local beam_a1 = Instance.new("Attachment")
		beam.Attachment0 = beam_a0
		beam.Attachment1 = beam_a1
		beam_a0.Parent = part
		beam_a1.Parent = part
		beam.Parent = part
		
		if i == 1 then
			beam_a0.Position = start_pos
		end
		table.insert(beams, beam_a0)
		table.insert(beams, beam_a1)
	end
	
	task.spawn(function()
		while task.wait(0.05) do
			for i = 1, #beams do
				local beam = beams[i]
				if i == 1 then
					beam.Position = Vector3.new(beam.Position.X + x_offset, get_y(beam.Position.X + x_offset), z_pos)
				else
					local previous_beam = beams[i - 1]
					beam.Position = Vector3.new(previous_beam.Position.X + 0.25, get_y(previous_beam.Position.X + 1), z_pos)
				end
			end
		end
	end)
end




local current = start_pos.Z
local beam_count = 30
-- ratio of beams to z offset is 10 to 3
for i = 1, beam_count do
	current += (beam_count / 10) * 3
	create_wave(current)
end
