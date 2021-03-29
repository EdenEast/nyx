function eden#util#center_lines(lines) abort
  let l:longest = max(map(copy(a:lines), 'strwidth(v:val)'))
  let l:center = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (l:longest / 2)) . v:val')
  return l:center
endfunction
