return {
	["^:(%S+) PRIVMSG (%S+) :!gcalc (.+)$"] = function(self, src, dest, msg)
		msg = utils.escape(msg):gsub('%s', '+')
		local content, status = utils.http("http://www.google.com/search?q=" .. msg)
		if(content) then
			local ans = content:match('<h2 .-><b>(.-)</b></h2><div')
			if(ans) then
				self:msg(dest, src, "%s: %s", src:match"^([^!]+)", ans)
			else
				self:msg(dest, src, '%s: %s', src:match"^([^!]+)", 'Do you want some air with that fail?')
			end
		end
	end
}