let g:vimwiki_list = [
  \{'path': '~/vimwiki/',
  \ 'syntax': 'markdown', 'ext': '.md',
  \ 'links_space_char': '-',
  \ 'diary_rel_path': '.'
  \}
  \]
let g:vimwiki_auto_chdir = 0

let g:zettel_options = [
      \ {"front_matter": [["tags", "new"]]}
      \]
let g:zettel_format = "%Y-%m-%d-%H%M"


nnoremap gzo :ZettelOpen<CR>
nnoremap gzd :VimwikiDeleteFile<CR>
nnoremap gzn :ZettelNew<CR>
" use [[ for inserting links

nnoremap gdi :VimwikiDiaryIndex<CR>:VimwikiDiaryGenerateLinks<CR>
nnoremap gdd :VimwikiMakeDiaryNote<CR>
nnoremap gdt :VimwikiMakeTomorrowDiaryNote<CR>
nnoremap gdy : VimwikiMakeYesterdayDiaryNote<CR>

" autocmd does not work as expected
"augroup vimwikigroup
"    autocmd!
    " automatically update links on read diary
    "autocmd BufRead,BufNewFile diary.md VimwikiDiaryGenerateLinks
"#augroup end
"

"lua << EOF
"require'neuron'.setup {
"    virtual_titles = true,
"    mappings = true,
"    run = nil,
"    neuron_dir = "~/vimwiki",
"    leader = "gz",
"}
"EOF
