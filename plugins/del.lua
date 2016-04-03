﻿do
local function pre_process(msg)
  if not msg.text and msg.media then
    msg.text = '['..msg.media.type..']'
  end
  return msg
end
local function del_by_reply(extra, success, result)
  vardump(result)
    if result.to.peer_type == "channel" then
        delete_msg(result.id, ok_cb, false)
    end
end
function status_msg(msg, trigger)
  local data = load_data(_config.moderation.data)
  local strict_settings = data[tostring(msg.to.id)]['settings']['strict']
  local status = trigger..""
  if strict_settings == "yes" then
    channel_kick_user("channel#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
	delete_msg(msg.id, ok_cb, false)
	status = status..""
  else
    delete_msg(msg.id, ok_cb, false)
	status = status..""
  end
  send_large_msg(get_receiver(msg), status)
end
local function run(msg, matches)
  local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
    if data[tostring(msg.to.id)]['settings']['lock_link'] == "yes" then
      if msg.text:match("telegram.me") and not is_momod(msg) then
		  delete_msg(msg.id, ok_cb, true)
      end
      if msg.media then
        if msg.media.caption:match("telegram.me") and not is_momod(msg) then
          delete_msg(msg.id, ok_cb, true)
        end
      end
    end
  end
  if data[tostring(msg.to.id)] then
    if data[tostring(msg.to.id)]['settings']['lock_sticker'] == "yes" then
	  if msg.media then
	    if msg.media.caption == "sticker.webp" and not is_momod(msg) then
	      delete_msg(msg.id,ok_cb, true)
	    end
	  end
	end
	if data[tostring(msg.to.id)]['settings']['lock_pe'] == "yes" then
	  if msg.text:match('[\216-\219][\128-\191]') and not is_momod(msg) then
	    local trigger = ""
	    status_msg(msg, trigger)
	  end
	end
  end
  if data[tostring(msg.to.id)] then
    if data[tostring(msg.to.id)]['settings']['lock_rtl'] == "yes" then
	  if msg.text:match('‮') or msg.text:match('‏') and not is_momod(msg) then
	    local trigger = ""
	    status_msg(msg, trigger)
	  end
	end
  end
  if matches[1] == "del" and is_momod(msg) then
    if type(msg.reply_id)~= "nil" then
      msgreply = get_message(msg.reply_id, del_by_reply, false)
	end
  end
  return 
end
return {
  patterns = {
    "(telegram.me)",
	'‮', -- rtl
	'‏', -- other rtl
	"%[(photo)%]",
	"([\216-\219][\128-\191])",
	--"^[!/#](del)$",
	'%[(document)%]',
	"^!!tgservice (.+)$"
  },
  run = run,
  pre_process = pre_process
}
end
