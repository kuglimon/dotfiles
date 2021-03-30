setxkbmap -layout fi

# Bind esc to capslock
setxkbmap -option caps:escape

# Spotify and I seem to have a disagreement whether playing only the first six
# seconds of a song constitutes to a pleasant playback experience. I don't even
# know if this really works - it fixed playback once so I guess it's science
# now. We're doing this on every boot so I don't have to waste a second of my
# life figuring out why I pay for a service which doesn't work.
rm ~/.config/spotify/Users/**/local-files.bnk

eval $(ssh-agent)

exec i3
