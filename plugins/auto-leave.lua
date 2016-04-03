do local function run(msg, matches) 
local bot_id = 177258945 
local receiver = get_receiver(msg)
    if matches[1] == 'lt' and is_sudo(msg) then
       channel_kick_user("channel#id"..msg.to.id, 'user#id'..bot_id, ok_cb, false)
       chat_del_user("chat#id"..msg.to.id, 'user#id'..bot_id, ok_cb, false)
    leave(receiver, ok_cb, false)
    elseif msg.service and msg.action.type == 'chat_add_user' or 'channel_invite_user' and msg.action.user.id == tonumber(bot_id) and not is_sudo(msg) then
       send_large_msg(receiver, '', ok_cb, false)
       chat_del_user(receiver, 'user#id'..bot_id, ok_cb, false)
       channel_kick_user("channel#id"..msg.to.id, 'user#id'..bot_id, ok_cb, 
false)
    leave(receiver, ok_cb, false)
    end end
 
return {
  patterns = {
    "^[8](lt)$",
    "^!!tgservice (.+)$",
  },
  run = run
}
end
