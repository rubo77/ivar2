local os = require 'os'
local iconv = require'iconv'
local dbi = require 'DBI'
require'logging.console'
local log = logging.console()


local patterns = {
	-- X://Y url
	"^(https?://%S+)",
    "^<(https?://%S+)>",
	"%f[%S](https?://%S+)",
	-- www.X.Y url
	"^(www%.[%w_-%%]+%.%S+)",
	"%f[%S](www%.[%w_-%%]+%.%S+)",
}

-- RFC 2396, section 1.6, 2.2, 2.3 and 2.4.1.
local smartEscape = function(str)
	local pathOffset = str:match("//[^/]+/()")

	-- No path means nothing to escape.
	if(not pathOffset) then return str end
	local prePath = str:sub(1, pathOffset - 1)

	-- lowalpha: a-z | upalpha: A-Z | digit: 0-9 | mark: -_.!~*'() |
	-- reserved: ;/?:@&=+$, | delims: <>#%" | unwise: {}|\^[]` | space: <20>
	local pattern = '[^a-zA-Z0-9%-_%.!~%*\'%(%);/%?:@&=%+%$,<>#%%"{}|\\%^%[%] ]'
	local path = str:sub(pathOffset):gsub(pattern, function(c)
		return ('%%%02X'):format(c:byte())
	end)

	return prePath .. path
end

-- save url to db
local handleUrl = function(self, source, destination, msg, url)
    local nick = source.nick

    log:info(string.format('Inserting URL into db. %s,%s, %s, %s', nick, destination, msg, url))
    -- TODO save connection
    local dbh = DBI.Connect('PostgreSQL', self.config.dbname, self.config.dbuser, self.config.dbpass, self.config.dbhost, self.config.dbport)

    -- check status of the connection
    -- local alive = dbh:ping()
    
    -- create a handle for an insert
    local insert = dbh:prepare('INSERT INTO urls(nick,channel,url,message) values(?,?,?,?)')

    -- execute the handle with bind parameters
    local stmt, err = insert:execute(nick, destination, url, msg)

    -- commit the transaction
    dbh:commit()
    
    --local ok = dbh:close()
end

return {
	PRIVMSG = {
		function(self, source, destination, argument)
			-- We don't want to pick up URLs from commands.
			if(argument:sub(1,1) == '!') then return end

			local tmp = {}
			local tmpOrder = {}
			local index = 1
			for split in argument:gmatch('%S+') do
				for i=1, #patterns do
					local _, count = split:gsub(patterns[i], function(url)
						if(url:sub(1,4) ~= 'http') then
							url = 'http://' .. url
						end

						url = smartEscape(url)

						if(not tmp[url]) then
							table.insert(tmpOrder, url)
							tmp[url] = index
						else
							tmp[url] = string.format('%s+%d', tmp[url], index)
						end
					end)

					if(count > 0) then
						index = index + 1
						break
					end
				end
			end

			if(#tmpOrder > 0) then

				for i=1, #tmpOrder do
					local url = tmpOrder[i]
                    handleUrl(self, source, destination, argument, url)
				end
			end
        end,
    }
}
