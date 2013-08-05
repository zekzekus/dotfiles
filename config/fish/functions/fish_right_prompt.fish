function fish_right_prompt
	if set -q VIRTUAL_ENV
        echo -n -s (set_color -b blue white) (basename "$VIRTUAL_ENV") (set_color normal)
    end
end
