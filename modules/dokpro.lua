local simplehttp = require'simplehttp'
local iconv = require"iconv"
local iso2utf = iconv.new("utf-8", "iso-8859-15")
local utf2iso = iconv.new('iso-8859-15', 'utf-8')

local urlEncode = function(str)
	return str:gsub(
		'([^%w ])',
		function (c)
			return string.format ("%%%02X", string.byte(c))
		end
	):gsub(' ', '+')
end

local trim = function(s)
	return s:match('^()%s*$') and '' or s:match('^%s*(.*%S)')
end

local parseData = function(data)
	data = iso2utf:iconv(data)

	-- This page is a typical example of someone using XHTML+CSS+JS, while still
	-- coding like they used to back in 1998.
	data = data:gsub('\r', ''):match('<div id="kolonne_enkel"[^>]+>(.-)</div>'):gsub('&nbsp;', '')

	local words = {}
	local entryIndex = 1
	for entryData in data:gmatch('<table class="liten_ordliste">([^\n]+)') do
		local entry = {
			lookup = {},
			examples = {},
		}

		local insertAt
		for td in entryData:gmatch('<td[^>]->(.-)</td>') do
			-- Strip away HTML.
			local line = trim(td:gsub('<span class="b">([^%d]-)</span>', '%1'):gsub('</?[%w:]+[^>]-/?>', ''))
			line = line:gsub('%s%s+', ' ')

			if(#line > 0) then
				if(tonumber(line)) then
					insertAt = tonumber(line)
				elseif(not line:match('%s+')) then
					table.insert(entry.lookup, line)
				elseif(insertAt) then
					entry.examples[insertAt] = line
					insertAt = nil
				else
					entry.meaning = line
				end
			end
		end

		table.insert(words, entry)
	end

	return words
end

local handleInput = function(self, source, destination, word)
	local query = urlEncode(utf2iso:iconv(word))
	simplehttp(
		"http://www.nob-ordbok.uio.no/perl/ordbok.cgi?ordbok=bokmaal&bokmaal=+&OPP=" .. query,

		function(data)
			local words = parseData(data)

			local msgLimit = (512 - 16 - 65 - 10) - #self.config.nick - #destination
			-- size of the word + x0 url.
			local n =  #word + 23
			local out = {}
			for i=1, #words do
				local word = words[i]
				local lookup = table.concat(word.lookup, ', ')
				local message = string.format('\002[%s]\002: %s', lookup, word.meaning)

				n = n + #message
				if(n < msgLimit) then
					table.insert(out, message)
				else
					break
				end
			end

			if(#out > 0) then
				self:Msg('privmsg', destination, source, '%s | http://x0.no/dokpro/%s', table.concat(out, ', '), word)
			else
				self:Msg('privmsg', destination, source, '%s: %s', source.nick, 'Du suger, prøv igjen.')
			end
		end
	)
end

return {
	PRIVMSG = {
		['^!dokpro (.+)$'] = handleInput,
		['^!ordbok (.+)$'] = handleInput,
	},
}
