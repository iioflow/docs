print("^:::::::::::::^")
note = {}
note[1] = {45,43,50}
note[2] = {55,64}
note[3] = {69,74,76,79}
note[4] = {86,83,81,72,79}
len = {3,2,4,5}

vol = {0,0,0,0}
seq = {1,1,1,1}

pos = {0,0,0,0}
sp = {0,0,0,0}

panic = function(ch)
	for n=0,127 do midi_note_off(n,0,ch) end
end


for n=1,4 do
	--panic(n)
	midi_note_on(note[n][seq[n]],127,n)
end

arc_refresh()

function tick()
	-- only one metro so we don't check n
	for n=1,4 do
		arc_led_all(n,0)
		pos[n] = pos[n] + sp[n]
		if pos[n] < 0 then
			midi_note_off(note[n][seq[n]],127,n)
			seq[n] = ((seq[n] - 2) % len[n]) + 1
			midi_note_on(note[n][seq[n]],127,n)
			pos[n] = pos[n] % 1024
			--ps("%d %d",n,seq[n])
		elseif pos[n] > 1023 then
			midi_note_off(note[n][seq[n]],127,n)
			seq[n] = (seq[n] % len[n]) + 1
			midi_note_on(note[n][seq[n]],127,n)
			pos[n] = pos[n] % 1024
			--ps("%d %d",n,seq[n])
		end

		for m=1,len[n] do arc_led(n,32+m*2,1) end
		arc_led_rel(n,32+seq[n]*2,9)

		point(n,pos[n])
		
		--midi_cc(cc[n][k].cc,c)
	end
	arc_refresh()
end

m = metro.new(tick,33)


function arc(n,d)
	sp[n] = clamp(sp[n] + d,-32,32)
end

function arc_key(z)
	for n=1,4 do sp[n] = 0 end
end

-- draw point 1-1024
function point(n,x)
	--local xx = math.floor(linlin(0,127,1,768,127-x)) + 128 + 512
	local c = x >> 4
	arc_led_rel(n,c%64+1,15)
	arc_led_rel(n,(c+1)%64+1,x%16)
	arc_led_rel(n,(c+63)%64+1,15-(x%16))
end


