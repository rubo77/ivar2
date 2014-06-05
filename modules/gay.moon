FABULOUS_COLORS = {4, 7, 9, 10, 12, 13, 6}

i = 0

gayify = (s) ->
  if s == "" return ""
  s\gsub "[%z\1-\127\194-\244][\128-\191]*", (c) ->
    ret = string.format("\03%02d%s", FABULOUS_COLORS[i + 1], c)
    i = (i + 1) % #FABULOUS_COLORS
    return ret

PRIVMSG:
  '^%pgay (.+)$': (source, destination, arg) =>
      @Msg 'privmsg', destination, source, gayify arg
