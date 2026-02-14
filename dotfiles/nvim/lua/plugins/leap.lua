local leap = require('leap')

-- default mappings have '/' and '?' as labels and those are annoying to type
leap.labels = 'sfnjklhodweimbuyvrgtaqpcxzSFNJKLHODWEIMBUYVRGTAQPCXZ'

vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

-- Highly recommended: define a preview filter to reduce visual noise
-- and the blinking effect after the first keypress
-- (see `:h leap.opts.preview`).
-- For example, skip preview if the first character of the match is
-- whitespace or is in the middle of an alphabetic word:
leap.opts.preview = function(ch0, ch1, ch2)
  return not (
    ch1:match('%s')
    or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
  )
end
