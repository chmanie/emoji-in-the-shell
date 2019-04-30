# emoji alpha version
insert_emoji () {
  local word_at_cursor="${LBUFFER/*( |\'|\")/}"
  local query=${word_at_cursor:-' '}
  local current_path=${0:a:h}
  if [ ! -f $current_path/emojis ]; then
    local header="I just generated new emojis for you. You're welcome!"
    cat $current_path/emojilib/emojis.json | jq -r 'to_entries | map([.key, .value.char] | join(" ")) | join ("\n")|@text' > emojis
  fi
  local emoji_line=$(cat $current_path/emojis | fzf-tmux -d 15% --header=$header -q $query)
  local emoji=$(echo $emoji_line | awk '{ print $2 }')
  LBUFFER=${LBUFFER%${~word_at_cursor}}${emoji}
}
zle -N insert_emoji
bindkey '^e' insert_emoji
