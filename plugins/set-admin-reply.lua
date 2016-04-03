do
    
  local function action_by_reply(extra, success, result)
    if result.from.username then
      user_name = '@'..result.from.username
    else
      user_name = ''
    end
    local text = result.from.peer_id
  channel_set_admin("channel#id"..result.to.peer_id, 'user#id'..result.from.peer_id, ok_cb, false)
 send_large_msg(extra.receiver, 'User ['..result.from.peer_id..'] added to adminlist')
  end

  local function run(msg, matches)
      if not is_owner(msg) then
          return 'Only owner can setadmin'
      end    
    if matches[1]:lower() == 'setadmin' and msg.reply_id then
      get_message(msg.reply_id, action_by_reply , {receiver=get_receiver(msg)})
    
    end
  end

  return {
    decription = 'test kick by_reply',
    usage = 'reply then type kick',
    patterns = {
      '^[!/#](setadmin)$',
    },
    run = run
  }

end