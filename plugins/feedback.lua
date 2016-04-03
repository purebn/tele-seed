do
function run(msg, matches)
 local day = os.date("%d")
local feedback_hash = 'count_feedback:'..day..':'..msg.from.id
local is_feedback = redis:get(feedback_hash)
if matches[1] and is_admin(msg) and msg.to.type ~= 'channel' then return end
if is_feedback then
    receive = 'channel#id'..msg.to.id
    local msgp = "⛔️ شما در هر روز میتوانید یک پیام به ادمین بفرستید\nاین کار برای جلوگیری از اسپم طراحی شده است."
    send_large_msg(receive, msgp.."\n", ok_cb, false)

    elseif not is_feedback then
     redis:set(feedback_hash, true)

        name = user_print_name(msg.from)
        name2 = '#name : '..user_print_name(msg.from)..'\n\n'
         id = msg.from.id
         id2 = '#ID : '..msg.from.id..'\n\n'
         msgg = matches[1]
         msggg = '#Pm :\n'..matches[1]..'\n\n'
         nameuser = msg.from.username
         nameuser2 = '#Username :@'..msg.from.username..'\n\n'
   local msg = name2..id2..nameuser2..msggg
   receiver = 'channel#id1037941432'

      send_large_msg(receiver, msg.."\n", ok_cb, false)
return 'پیام شما با موفقیت ارسال و در صورت لزوم با شما تماس خواهد گرفته شد'
end
end
return {
    patterns = {
      "^[!/#]feedback (.*)$"
    },
    run = run,
}

end
