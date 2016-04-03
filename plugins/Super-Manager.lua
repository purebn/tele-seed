-- data saved to moderation.json
-- check moderation plugin
do

local function check_member(cb_extra, success, result)
   local receiver = cb_extra.receiver
   local data = cb_extra.data
   local msg = cb_extra.msg
   for k,v in pairs(result.members) do
      local member_id = v.peer_id
      if member_id ~= our_id then
          local username = v.username
          data[tostring(msg.to.id)] = {
              moderators = {[tostring(member_id)] = username},
              settings = {
                  set_name = string.gsub(msg.to.print_name, '_', ' '),
                  lock_link = 'no',
                  lock_sticker = 'no',
                  lock_pe = 'no',
				  lock_tgservice = 'no',
				  lock_member = 'no',				  
				  lock_rtl = 'no',
				  lock_tag = 'no',
				  lock_url = 'no',
                  flood = 'no',
                  }
            }
          save_data(_config.moderation.data, data)
          return send_large_msg(receiver, 'You have been promoted as moderator for this group.')
      end
    end
end

local function automodadd(msg)
    local data = load_data(_config.moderation.data)
  if msg.action.type == 'chat_created' then
      receiver = get_receiver(msg)
      chat_info(receiver, check_member,{receiver=receiver, data=data, msg = msg})
  else
      if data[tostring(msg.to.id)] then
        return reply_msg(msg.id,'SuperGroup is already added by ['..msg.from.id..']' , ok_cb, false)
      end
      if msg.from.username then
          username = msg.from.username
      else
          username = msg.from.print_name
      end
        -- create data array in moderation.json
      data[tostring(msg.to.id)] = {
          moderators ={[tostring(msg.from.id)] = username},
          settings = {
              set_name = string.gsub(msg.to.print_name, '_', ' '),
                  lock_link = 'no',
                  lock_sticker = 'no',
                  lock_pe = 'no',
				  lock_tgservice = 'no',
				  lock_member = 'no',				  
				  lock_rtl = 'no',
				  lock_tag = 'no',
				  lock_url = 'no',				  
                  flood = 'no',		  
              }
          }
      save_data(_config.moderation.data, data)
      return 'SuperGroup has been added, and @'..username..' has been promoted as moderator for this group.'
   end
end

local function modadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
        return "You're not admin"
    end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
        return reply_msg(msg.id,'SuperGroup is already added by ['..msg.from.id..']' , ok_cb, false)
  end
    -- create data array in moderation.json
  data[tostring(msg.to.id)] = {
      moderators ={},
      settings = {
          set_name = string.gsub(msg.to.print_name, '_', ' '),
                  lock_link = 'no',
                  lock_sticker = 'no',
                  lock_pe = 'no',
				  lock_tgservice = 'no',
				  lock_member = 'no',				  
				  lock_rtl = 'no',
				  lock_tag = 'no',
				  lock_url = 'no',				  
                  flood = 'no',	  
          }
      }
  save_data(_config.moderation.data, data)

   return reply_msg(msg.id,'Supergroup has been added by ['..msg.from.id..']', ok_cb, false)
end
local function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
        return "You're not admin"
    end
    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
  if not data[tostring(msg.to.id)] then
    return reply_msg(msg.id,'SuperGroup is not added.', ok_cb, false)
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)

  return reply_msg(msg.id,'SuperGroup has been removed by ['..msg.from.id..']', ok_cb, false)
end
local function create_group(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
        return "You're not admin!"
    end
    local group_creator = msg.from.print_name
    create_group_chat (group_creator, group_name, ok_cb, false)
	return 'Group '..string.gsub(group_name, '_', ' ')..' has been created.'
end

local function set_rules(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local data_cat = 'rules'
	data[tostring(msg.to.id)][data_cat] = rules
	save_data(_config.moderation.data, data)

	return 'SuperGroup rules has been set'
end

local function get_rules(msg, data)
    local data_cat = 'rules'
    if not data[tostring(msg.to.id)][data_cat] then
    return 'No rules available.'
     end
    local rules = data[tostring(msg.to.id)][data_cat]
    local rules = 'Rules:\n\n'..rules
    return rules
end


--lock/unlock supergroup links
local function lock_group_link(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_link_lock = data[tostring(msg.to.id)]['settings']['lock_link']
	if group_link_lock == 'yes' then
	    return 'Link sharing is already locked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_link'] = 'yes'
	    save_data(_config.moderation.data, data)
	end
	return 'Link sharing has been locked'
end

local function unlock_group_link(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_link_lock = data[tostring(msg.to.id)]['settings']['lock_link']
	if group_link_lock == 'no' then
	    return 'Link sharing is already unlocked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_link'] = 'no'
	    save_data(_config.moderation.data, data)
	return 'Link sharing has been unlocked'
	end
end

--lock/unlock supergroup stickers
local function lock_group_sticker(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_sticker_lock = data[tostring(msg.to.id)]['settings']['lock_sticker']
	if group_sticker_lock == 'yes' then
	    return 'Sticker sharing is already locked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_sticker'] = 'yes'
	    save_data(_config.moderation.data, data)
	end
	return 'Sticker sharing has been locked'
end

local function unlock_group_sticker(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_sticker_lock = data[tostring(msg.to.id)]['settings']['lock_sticker']
	if group_sticker_lock == 'no' then
	    return 'Sticker sharing is already unlocked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_sticker'] = 'no'
	    save_data(_config.moderation.data, data)
	return 'Sticker sharing has been unlocked'
	end
end

--lock/unlock supergroup persian
local function lock_group_persian(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_persian_lock = data[tostring(msg.to.id)]['settings']['lock_pe']
	if group_persian_lock == 'yes' then
	    return 'Persian language are already locked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_pe'] = 'yes'
	    save_data(_config.moderation.data, data)
	end
	return 'Persian language has been locked'
end

local function unlock_group_persian(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_persian_lock = data[tostring(msg.to.id)]['settings']['lock_pe']
	if group_persian_lock == 'no' then
	    return 'Persian language already unlocked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_pe'] = 'no'
	    save_data(_config.moderation.data, data)
	return 'Persian language has been unlocked'
	end
end

--lock/unlock supergroup flood 
local function lock_group_flood(msg, data)
    if not is_owner(msg) then
        return "Only owner can do it for now"
    end
    local group_flood_lock = data[tostring(msg.to.id)]['settings']['flood']
	if group_flood_lock == 'yes' then
	    return 'Group flood is locked'
	else
	    data[tostring(msg.to.id)]['settings']['flood'] = 'yes'
	    save_data(_config.moderation.data, data)
	end
	return 'Group flood has been locked'
end

local function unlock_group_flood(msg, data)
    if not is_owner(msg) then
        return "Only owner can do it for now"
    end
    local group_flood_lock = data[tostring(msg.to.id)]['settings']['flood']
	if group_flood_lock == 'no' then
	    return 'Group flood is not locked'
	else
	    data[tostring(msg.to.id)]['settings']['flood'] = 'no'
	    save_data(_config.moderation.data, data)
	return 'Group flood has been unlocked'
	end
end

--lock/unlock supergroup tgservice
local function lock_group_tgservice(msg, data)
    if not is_momod(msg) then
        return "Only owner can do it for now"
    end
    local group_tgservice_lock = data[tostring(msg.to.id)]['settings']['lock_tgservice']
	if group_tgservice_lock == 'yes' then
	    return 'Tgservice is locked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_tgservice'] = 'yes'
	    save_data(_config.moderation.data, data)
	end
	return 'Tgservice has been locked'
end

local function unlock_group_tgservice(msg, data)
    if not is_momod(msg) then
        return "Only owner can do it for now"
    end
    local group_tgservice_lock = data[tostring(msg.to.id)]['settings']['lock_tgservice']
	if group_tgservice_lock == 'no' then
	    return 'Tgservice is not locked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_tgservice'] = 'no'
	    save_data(_config.moderation.data, data)
	return 'Tgservice has been unlocked'
	end
end

-- lock/unlock supergroup member
local function lock_group_member(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_member_lock = data[tostring(msg.to.id)]['settings']['lock_member']
	if group_member_lock == 'yes' then
	    return 'Group members are already locked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_member'] = 'yes'
	    save_data(_config.moderation.data, data)
	end
	return 'Group members has been locked'
end

local function unlock_group_member(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_member_lock = data[tostring(msg.to.id)]['settings']['lock_member']
	if group_member_lock == 'no' then
	    return 'Group members are not locked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_member'] = 'no'
	    save_data(_config.moderation.data, data)
	return 'Group members has been unlocked'
	end
end

--lock/unlock supergroup rtl
local function lock_group_rtl(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_rtl_lock = data[tostring(msg.to.id)]['settings']['lock_rtl']
	if group_rtl_lock == 'yes' then
	    return 'Rtl is are already locked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_rtl'] = 'yes'
	    save_data(_config.moderation.data, data)
	end
	return 'Rtl has been locked'
end

local function unlock_group_rtl(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_rtl_lock = data[tostring(msg.to.id)]['settings']['lock_rtl']
	if group_rtl_lock == 'no' then
	    return 'Rtl is already unlocked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_rtl'] = 'no'
	    save_data(_config.moderation.data, data)
	return 'Rtl has been unlocked'
	end
end

--lock/unlock supergroup tag
local function lock_group_tag(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_tag_lock = data[tostring(msg.to.id)]['settings']['lock_tag']
	if group_tag_lock == 'yes' then
	    return 'Tag is are already locked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_tag'] = 'yes'
	    save_data(_config.moderation.data, data)
	end
	return 'Tag has been locked'
end

local function unlock_group_tag(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_tag_lock = data[tostring(msg.to.id)]['settings']['lock_tag']
	if group_tag_lock == 'no' then
	    return 'Tag is already unlocked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_tag'] = 'no'
	    save_data(_config.moderation.data, data)
	return 'Tag has been unlocked'
	end
end

--lock/unlock supergroup Url
local function lock_group_url(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_url_lock = data[tostring(msg.to.id)]['settings']['lock_url']
	if group_url_lock == 'yes' then
	    return 'Url is are already locked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_url'] = 'yes'
	    save_data(_config.moderation.data, data)
	end
	return 'Url has been locked'
end

local function unlock_group_url(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
    local group_url_lock = data[tostring(msg.to.id)]['settings']['lock_url']
	if group_url_lock == 'no' then
	    return 'Url is already unlocked'
	else
	    data[tostring(msg.to.id)]['settings']['lock_url'] = 'no'
	    save_data(_config.moderation.data, data)
	return 'Url has been unlocked'
	end
end

--del msg by reply -function
local function del_by_reply(extra, success, result)
    if result.to.peer_type == "channel" then
        delete_msg(result.id, ok_cb, false)
    end
end
local function callbackres(extra, success, result)
  --vardump(result)
	local user = result.peer_id
	local name = string.gsub(result.print_name, "_", " ")
	local channel = "channel#id"..extra.channelid
	send_large_msg(channel, user..'\n'..name)
end
--get id by reply
local function get_message_callback_id(extra, success, result)
  vardump(result) 
    if result.to.peer_type == 'channel' then
        local chat = 'channel#id'..result.to.peer_id
        send_large_msg(chat, result.from.peer_id)
    else
        return 'Use This in Your Groups'
    end
end
local function user_msgs(user_id, chat_id)
  local user_info
  local uhash = 'user:'..user_id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..user_id..':'..chat_id
  user_info = tonumber(redis:get(um_hash) or 0)
  return user_info
end

local function set_group_photo(msg, success, result)
  local data = load_data(_config.moderation.data)
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/photos/channel_photo_'..msg.to.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    channel_set_photo (receiver, file, ok_cb, false)
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(_config.moderation.data, data)
    data[tostring(msg.to.id)]['settings']['lock_photo'] = 'yes'
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, 'Photo saved!', ok_cb, false)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end

local function promote(receiver, member_username, member_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return send_large_msg(receiver, 'Group is not added.')
  end
  if data[group]['moderators'][tostring(member_id)] then
    return send_large_msg(receiver, member_username..' is already a moderator.')
  end
  channel_add_mod(receiver, "user#id"..member_id, ok_cb, false)
  data[group]['moderators'][tostring(member_id)] = member_username
  save_data(_config.moderation.data, data)
  return send_large_msg(receiver, member_username..' has been promoted.')
end
local function promote_by_reply(extra, success, result)
  vardump(result)
    local msg = result
    local full_name = (msg.from.first_name or '')..' '..(msg.from.last_name or '')
    if msg.from.username then
      member_username = '@'.. result.from.username
    else
      member_username = full_name
    end
    local member_id = msg.from.peer_id
    if msg.to.peer_type == 'channel' then
      return promote("channel#id"..msg.to.peer_id, member_username, member_id)
    end  
end
local function demote(receiver, member_username, member_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return send_large_msg(receiver, 'Group is not added.')
  end
  if not data[group]['moderators'][tostring(member_id)] then
    return send_large_msg(receiver, member_username..' is not a moderator.')
  end
  channel_rem_mod(receiver, "user#id"..member_id, ok_cb, false)
  data[group]['moderators'][tostring(member_id)] = nil
  save_data(_config.moderation.data, data)
  return send_large_msg(receiver, member_username..' has been demoted.')
end
local function demote_by_reply(extra, success, result)
  vardump(result)
    local msg = result
    local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
    if result.from.username then
      member_username = '@'..result.from.username
    else
      member_username = full_name
    end
    local member_id = result.from.peer_id
    if result.to.peer_type == 'channel' then
      return demote("channel#id"..msg.to.peer_id, member_username, member_id)
    end  
end
local function promote_demote_res(extra, success, result)
  vardump(result)
	local member_id = result.peer_id
	local member_username = "@"..result.username
	local channel_id = extra.channel_id
	local mod_cmd = extra.mod_cmd
	local receiver = "channel#id"..channel_id
	if mod_cmd == "promote" then
	  return promote(receiver, member_username, member_id)
	elseif mod_cmd == "demote" then
	  return demote(receiver, member_username, member_id)
	end
end
local function setowner_by_reply(extra, success, result)
  local msg = result
  local receiver = 'channel#id'..msg.to.peer_id
  local data = load_data(_config.moderation.data)
  local name_log = msg.from.print_name:gsub("_", " ")
  data[tostring(msg.to.peer_id)]['set_owner'] = tostring(msg.from.peer_id)
      save_data(_config.moderation.data, data)
      local text = msg.from.print_name:gsub("_", " ").." is the owner now"
      return send_large_msg(receiver, text)
end
local function get_admin(extra, success, result)
  --vardump(result)
    local name = extra.name
    local receiver = extra.receiver
    local text = "List admins :\n"
    local i = 1
    for k,user in ipairs(result) do
        local username = (user.username or '')
        text = text ..i..'- @'..username..' ['..user.peer_id..'] \n'
        i = i + 1
    end
    send_large_msg(receiver, text)
end
local function get_bot(extra, success, result)
  vardump(result)
    local name = extra.name
    local receiver = extra.receiver
    local text = "List bots :\n"
    local i = 1
    for k,user in ipairs(result) do
        local id = user.peer_id
        local botname = user.print_name
		local username = (user.username or 'None')
        if string.sub(username:lower(), -3) == "bot" then
            local username = "@"..user.username
            text = text ..i.."-"..username.." ["..id.."]\n"
            i = i + 1
        end
    end
    send_large_msg(receiver, text)
end
local function stats_chat(extra, success, result, msg)
     receiver = get_receiver(extra.msg)
     local data = load_data(_config.moderation.data)
     local text = "Group stats for  "..result.title.."\n\n"
     .."Admins : "..result.admins_count.."\n"
     .."Users : "..result.participants_count.."\n"     
     .."Kicked : "..result.kicked_count.."\n"
     .."ID : "..result.peer_id
     return send_large_msg(receiver, text)
end
local function modlist(msg)
  local data = load_data(_config.moderation.data)
  local groups = "groupa"
  --if not data[tostring(groups)][tostring(msg.to.id)] then
    --return 'Group is not added.'
  --end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['moderators']) == nil then --fix way
    return 'No moderator in this group.'
  end
  local i = 1
  local message = '\nList of moderators for ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
    message = message ..i..'- '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end
-- show group settings
local function show_group_settings(msg, data)
    if not is_momod(msg) then
        return "For moderators only!"
    end
  local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
    if data[tostring(msg.to.id)]['settings']['flood_msg_max'] then
      NUM_MSG_MAX = tonumber(data[tostring(msg.to.id)]['settings']['flood_msg_max'])
      print('custom'..NUM_MSG_MAX)
    else
      NUM_MSG_MAX = 5
    end
  end	
    local settings = data[tostring(msg.to.id)]['settings']
    local text = "SuperGroup settings:\n"
    .."\nLock Links : "..settings.lock_link..""
	.."\nLock Sticker : "..settings.lock_sticker..""
	.."\nLock Persian : "..settings.lock_pe..""
	.."\nLock Tgservice : "..settings.lock_tgservice..""
	.."\nLock Member : "..settings.lock_member..""
	.."\nLock Rtl : "..settings.lock_rtl..""
	.."\nLock Tag : "..settings.lock_tag..""
	.."\nLock Url : "..settings.lock_url..""		
	.."\nLock flood : "..settings.flood..""
	.."\nSpam sensitivity : "..NUM_MSG_MAX
	return text
end
function run(msg, matches)
    --vardump(msg)
---add/rem supergroups  
  if matches[1] == 'add' then
    return modadd(msg)
  end
  if matches[1] == 'rem' then
    return modrem(msg)
  end
    if matches[1] == 'cgp' and matches[2] then
        group_name = matches[2]
        return create_group(msg)
    end
    if not is_chat_msg(msg) then
	    return ""
	end
    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    if msg.media and is_chat_msg(msg) and is_momod(msg) then
    	if msg.media.type == 'photo' and data[tostring(msg.to.id)] then
    		if data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' then
    			load_photo(msg.id, set_group_photo, msg)
    		end
    	end
    end
    if data[tostring(msg.to.id)] then
		local settings = data[tostring(msg.to.id)]['settings']
		if matches[1] == 'setrules' then
		    rules = matches[2]
		    return set_rules(msg, data)
		end
		if matches[1] == 'rules' then
		    return get_rules(msg, data)
		end
		-- supergroup setabout
       if matches[1] == "setabout" and is_momod(msg) then
          channel = "channel#id"..msg.to.id
          about = matches[2]
	   channel_set_about(channel, about, ok_cb, false)
	     return reply_msg(msg.id, "Description has been set.\n\nSelect the chat again to see the changes", ok_cb, false)
      end	
        -- supergroups setadmin	  
       if matches[1] == "setadmin" and is_owner(msg) then
          channel = "channel#id"..msg.to.id
          user = matches[2]
	   channel_set_admin(channel, user, ok_cb, true)
         return "User ["..matches[2].."] added to adminlist"
      end
	  -- supergroups removeadmin
       if matches[1] == "remadmin" and is_owner(msg) then
          channel = "channel#id"..msg.to.id
          user = matches[2]
	   channel_rem_admin(channel, user, ok_cb, true)
       return "User ["..msg.to.id.."] removed from adminlist"
      end	 
--lock supergroup 		
		if matches[1] == 'lock' then 
		    if matches[2] == 'links' then
		        return lock_group_link(msg, data)
		    end
			if matches [2] == 'sticker' then
			     return lock_group_sticker(msg, data)
			end	 
			if matches[2] == 'persian' then
			     return lock_group_persian(msg, data)
			end	 
			if matches[2] == 'flood' then
			     return lock_group_flood(msg, data)
			end	
			if matches[2] == 'tgservice' then
			     return lock_group_tgservice(msg, data)
			end	
			if matches[2] == 'member' then
			     return lock_group_member(msg, data)
			end	
			if matches[2] == 'rtl' then
			     return lock_group_rtl(msg, data)
			end	
			if matches[2] == 'tag' then
			     return lock_group_tag(msg, data)
			end
			if matches[2] == 'url' then
			     return lock_group_url(msg, data)
			end				
        end
		
--unlock supergroup		
		if matches[1] == 'unlock' then --group unlock *
		    if matches[2] == 'links' then
		        return unlock_group_link(msg, data)
		    end
			if matches[2] == 'sticker' then
			     return unlock_group_sticker(msg, data)
			end	
			if matches[2] == 'persian' then
			     return unlock_group_persian(msg, data)
			end
			if matches[2] == 'flood' then
			     return unlock_group_flood(msg, data)
			end	
			if matches[2] == 'tgservice' then
			     return unlock_group_tgservice(msg, data)
			end	
			if matches[2] == 'member' then
			     return unlock_group_member(msg, data)
			end	
			if matches[2] == 'rtl' then
			     return unlock_group_rtl(msg, data)
			end	
			if matches[2] == 'tag' then
			     return unlock_group_tag(msg, data)
			end
			if matches[2] == 'url' then
			     return unlock_group_url(msg, data)
			end			
		end
		if matches[1] == 'settings'then
		    return show_group_settings(msg, data)
		end
     --link/newlink -- link pv/newlink pv -- /savelink
    if matches[1] == 'relink' and is_momod(msg)then
	local function callback_link (extra , success, result)
	local receiver = get_receiver(msg)
		if success == 0 then
			send_large_msg(receiver, '*Error: Invite link failed*\nReason: Not creator.')
			data[tostring(msg.to.id)]['settings']['set_link'] = nil
			save_data(_config.moderation.data, data)
		else
		
			send_large_msg(receiver, "Relinked Link by ["..msg.from.id.."]")
			data[tostring(msg.to.id)]['settings']['set_link'] = result
			save_data(_config.moderation.data, data)
		end
	end
	export_channel_link(receiver, callback_link, false)
end
    if matches[1] == 'savelink' and is_owner(msg) then
	data[tostring(msg.to.id)]['settings']['set_link'] = 'waiting'
	save_data(_config.moderation.data, data)
	return 'Please send me the link now!'
end
	if msg.text then
		if msg.text:match("^(https://telegram.me/joinchat/%S+)$") and data[tostring(msg.to.id)]['settings']['set_link'] == 'waiting' and is_owner(msg) then
			data[tostring(msg.to.id)]['settings']['set_link'] = msg.text
			save_data(_config.moderation.data, data)
			return "New link set by ["..msg.from.id.."]"
		end
	end
	if matches[1] == 'getlink' then
		if not is_momod(msg) then
			return
		end
		local group_link = data[tostring(msg.to.id)]['settings']['set_link']
		if not group_link then
			return "Create a link using /relink first !"
		end
	return "Group link:\n"..group_link
end
    if matches[1] == 'getlink pv' then
      if not is_momod(msg) then
        return "For moderators only!"
      end
      local group_link = data[tostring(msg.to.id)]['settings']['set_link']
      if not group_link then 
        return "Create a link using /relink first !"
      end
    	send_large_msg('user#id'..msg.from.id, "Group link:\n"..group_link)
       return "Link was sent to a private chat!"
   end  
	if matches[1] == 'relink pv' and is_owner(msg) then
		local function link_callback (extra , success, result)
			local receiver = extra.receiver
			if success == 0 then
				return "Error!"
			end
			data[tostring(msg.to.id)]['settings']['set_link'] = result
			save_data(_config.moderation.data, data)
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			send_large_msg(receiver, "Newlink send to your private chat")
			send_large_msg('user#'..msg.from.id, "new group link :\n"..group_link)
		end
	   local receiver = 'channel#'..msg.to.id
	return export_channel_link(receiver, link_callback, {receiver = receiver})
  end
  if matches[1] == "setflood" then
    if not is_momod(msg) then
      return "For moderators only!"
    end
    if tonumber(matches[2]) < 5 or tonumber(matches[2]) > 20 then
      return "Wrong number, range [5-20]"
    end
    local flood_max = matches[2]
    data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
    save_data(_config.moderation.data, data)
    return "Group flood has been set to "..flood_max
  end
    if matches[1] == 'setowner' and matches[2] then
      if not is_owner(msg) then
        return "For owner only!"
      end
      data[tostring(msg.to.id)]['set_owner'] = matches[2]
      save_data(_config.moderation.data, data)
      local text = matches[2].." added as owner"
      return text
    end
    if matches[1] == 'setowner' and not matches[2] then
      if not is_owner(msg) then
        return "only for the owner!"
      end
      if type(msg.reply_id)~="nil" then
          msgr = get_message(msg.reply_id, setowner_by_reply, false)
      end
    end
    if matches[1] == 'owner' then
      local group_owner = data[tostring(msg.to.id)]['set_owner']
      if not group_owner then 
        return "no owner,ask admins in support groups to set owner for your group"
      end
      return "SuperGroup owner is ["..group_owner..']'
    end
  if matches[1] == "promote" and not matches[2] then
    if not is_owner(msg) then
	  return "Only the owner can promote new moderator"
	end
	if type(msg.reply_id)~= "nil" then
	  msgr = get_message(msg.reply_id, promote_by_reply, false)
	end
  end
  if matches[1] == "promote" and matches[2] then
    if not is_owner(msg) then
	  return "Only owner can do promote!"
	end
	if string.gsub(matches[2], "@", "") == msg.from.username and not is_owner(msg) then
	  return "You can't demote yourself"
	end
	local cbres_extra = {
	  channel_id = msg.to.id,
	  mod_cmd = 'promote'
	}
	local username = matches[2]
	local username = string.gsub(matches[2], "@", "")
	return resolve_username(username, promote_demote_res, cbres_extra)
  end
  if matches[1] == "modlist" then
    return modlist(msg)
  end
  if matches[1] == "botlist" then
    local receiver = get_receiver(msg)
    local name = string.gsub(msg.to.print_name, '_', ' ')
    channel_get_users("channel#id"..msg.to.id, get_bot, {receiver=receiver, name=name})
  end  
  if matches[1] == "admins" then
    if not is_momod(msg) then
      return "For moderators only"
    end
    local receiver = get_receiver(msg)
    local name = string.gsub(msg.to.print_name, '_', ' ')
    channel_get_admins("channel#id"..msg.to.id, get_admin, {receiver=receiver, name=name})
  end  
  if matches[1] == "demote" and not matches[2] then
    if not is_owner(msg) then
	  return "Only owner can demote moderator!"
	end
	if type(msg.reply_id)~="nil" then
	  msgr = get_message(msg.reply_id, demote_by_reply, false)
	end
  end
  if matches[1] == "demote" and matches[2] then
    if not is_owner(msg) then
	  return "Only owner can do demote!"
	end
	if string.gsub(matches[2], "@", "") == msg.from.username and not is_owner(msg) then
	  return "You can't demote yourself!"
	end
	local cbres_extra = {
	  channel_id = msg.to.id,
	  mod_cmd = 'demote'
	}
	local username = matches[2]
	local username = string.gsub(matches[2], "@", "")
	return resolve_username(username, promote_demote_res, cbres_extra)
  end
	--- upgrade chat to supergroups
  if matches[1] == "tosuper" and is_owner(msg) then
    if msg.to.type == 'channel' then
	  return "*Error : Already a SuperGroup."
	end
    upgrade_chat("chat#id"..msg.to.id, ok_cb, false)
	send_large_msg("chat#id"..msg.to.id, "Group has been upgraded to a SuperGroup.")
  end
-- info supergroups
 if matches[1]:lower() == 'info' and not matches[2] then
  local receiver = get_receiver(msg)
  local Reply = msg.reply_id
  if msg.reply_id then
    msgr = get_message(msg.reply_id, action_by_reply, 
{receiver=receiver, Reply=Reply})
  else
  if msg.from.username then
   Username = '@'..msg.from.username
   else
   Username = ''
   end
  if msg.from.phone then
   phone = '+ '..msg.from.phone
   else
   phone = ''
   end   
   local text = '#First name : '..(msg.from.first_name or '')..'\n'
   local text = text..'#Last name : '..(msg.from.last_name or '')..'\n'
   local text = text..'#Username : '..Username..'\n'
   local text = text..'#ID : '..msg.from.id..'\n\n'
   local text = text..'#phone : '..phone..'\n'
    local um_hash = 'msgs:'..msg.from.id..':'..msg.to.id
  user_info_msgs = tonumber(redis:get(um_hash) or 0)
  --text = text..'#Total messages : '..user_info_msgs..'\n\n'
    if msg.to.type == 'channel' then
  text = text..'#Group name : '..msg.to.title..'\n'
     text = text..'#Group ID : '..msg.to.id
    end
 text = text..''
    return reply_msg(msg.id, text, ok_cb, true)
    end
  end 
-- get supergroup admins|users|kicked|id  
  if matches[1] == "stats" and is_momod(msg) then
  channel_info('channel#id'..msg.to.id, stats_chat, {msg=msg})
  end	  
-- get id supergrous  or user
 if matches[1] == 'id' then
    if msg.to.type == "user" then
      return ""
    end
    if type(msg.reply_id) ~= "nil" then
      id = get_message(msg.reply_id, get_message_callback_id, false)
	elseif matches[1] == "id" then
	  return "👥chat id : ➣  "..msg.to.id.."\n👤user id : ➣  "..msg.from.id 
	end
  end
-- res_user  
  if matches[1] == "res" and is_owner(msg) then
    local cbres_extra = {
	  channelid = msg.to.id
	}
	local username = matches[2]
	local username = username:gsub("@","")
	return resolve_username(username, callbackres, cbres_extra)
  end 
-- del msg by reply  
  if matches[1] == "del" and not is_momod and msg.reply_id then
    msgr = get_message(msg.reply_id, del_by_reply, get_receiver(msg))
  end     
  -- kick user this supergroup
  if matches[1]:lower() == 'kickme' then-- /kickme
  local receiver = get_receiver(msg)
    if msg.to.type == 'channel' then
      local name = user_print_name(msg.from)
      channel_kick_user("channel#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
    end
end
 if msg.text:match("msg.to.id") then
    return reply_msg(msg.id, msg.to.id, ok_cb, true)
 elseif msg.text:match("msg.to.peer_id") then
    return reply_msg(msg.id, msg.to.peer_id, ok_cb, false)
 elseif msg.text:match("msg.from.id") then
    return reply_msg(msg.id, msg.from.id, ok_cb, true)
 elseif msg.text:match("msg.from.peer_id") then
    return reply_msg(msg.id, msg.from.peer_id, ok_cb, false)
 end
  if matches[1] == "clean" then
    if not is_owner(msg) then
	  return "Only owner can clean!"
	end
  if matches[2] == "modlist" then
    if next(data[tostring(msg.to.id)]['moderators']) == nil then --fix way
       return 'No moderator in this group.'
    end
	  local message = '\nList of moderators for ' .. string.gsub(msg.to.print_name, '_', '') .. ':\n'
	  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
	    channel_rem_mod("channel#id"..msg.to.id, "user#id"..k, ok_cb, true)
		data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
		save_data(_config.moderation.data, data)
	  end
	  return "Modlist has been cleaned"
	end
	if matches[2] == "rules" then
	  data[tostring(msg.to.id)]['rules'] = nil
	  save_data(_config.moderation.data, data)
	  return "Rules has been cleaned"
	end
	if matches[2] == "about" then
	channel_set_about("channel#id"..msg.to.id, '', ok_cb, true)
	  local data_cat = 'description'
	  data[tostring(msg.to.id)][data_cat] = nil
	  save_data(_config.moderation.data, data)
	  return "Description has been cleaned"
    end
 end  
	if matches[1] == 'setname' and is_momod(msg) then
		local new_name = string.gsub(matches[2], '_', ' ')
	    data[tostring(msg.to.id)]['settings']['set_name'] = new_name
	    save_data(_config.moderation.data, data) 
	    local group_name_set = data[tostring(msg.to.id)]['settings']['set_name']
	    local to_rename = 'channel#id'..msg.to.id
	rename_channel(to_rename, group_name_set, ok_cb, false)
end	
	if matches[1] == 'setphoto' and is_momod(msg) then
		 data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
	     save_data(_config.moderation.data, data)
	  return 'Please send me new group photo now'
		end 
	end   		
end


return {
  description = "Plugin to manage group chat.", 
  usage = {
    "!creategroup <group_name> : Create a new group (admin only)",
    "!setabout <description> : Set group description",
    "!about : Read group description",
    "!setrules <rules> : Set group rules",
    "!rules : Read group rules",
    "!setname <new_name> : Set group name",
    "!setphoto : Set group photo",
    "!group <lock|unlock> name : Lock/unlock group name",
    "!group <lock|unlock> photo : Lock/unlock group photo",
    "!group <lock|unlock> member : Lock/unlock group member",		
    "!group settings : Show group settings"
    },
  patterns = {	
    "^[!/#](add)$",
    "^[!/#](rem)$",  
    "^[!/#](cgp) (.*)$",
	"^[!/#](tosuper)$",
    "^[!/#](setrules) (.*)$",
    "^[!/#](rules)$",
	"^[!/#](setabout) (.*)$",
    "^[!/#](setname) (.*)$",
    "^[!/#](setphoto)$",
	"^[!/#](setadmin) (%d+)$",
    "^[!/#](remadmin) (%d+)$",	
	"^[/!#](promote)$",
	"^[/!#](demote)$",	
	"^[/!#](setowner)$",		
	"^[/!#](promote) (.*)$",
	"^[/!#](demote) (.*)$",
	"^[/!#](setowner) (%d+)$",	
	"^[/!#](owner)$",
	"^[/!#](modlist)$",	
    "^[/!#](botlist)$",
    "^[/!#](admins)$",	
    "^[!/#](lock) (.*)$",
    "^[!/#](unlock) (.*)$",
    "^[!/#](settings)$",
	"^[/!#](clean) (.*)$",	
    "^[!/#](kickme)$",
	"^[!/#](res) (.*)$",
    "^[/!#](setflood) (%d+)$",
	"^[#!/](savelink)$",	
    "^[!/#](getlink)$",
    "^[!/#](relink)$",
    "^[!/#](getlink pv)$",
    "^[!/#](relink pv)$",	
    "^[!/#](info)$",
    "^[!/#](stats)$",    	
    "^[!/#](id)$",
    "^[!/#](del)$",	
    "^(https://telegram.me/joinchat/%S+)$",	
    "^!!tgservice (.+)$",
    "%[(photo)%]",
  }, 
  run = run,
}

end


