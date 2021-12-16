local nvimtree = prequire("nvim-tree")

if not nvimtree then
	return
end

nvimtree.setup({
	view = {
		width = 40
	}
})
