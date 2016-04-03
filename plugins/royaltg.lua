do
function run(msg, matches)
	  local chat = 'channel#id'..msg.to.id
       local id = "05000000a69a663d6b04000000000000b8d27be45735bb96"
      fwd_msg(chat, id, ok_cb, false)

end

return {
  patterns = {
"^[!/#]royaltg$"
  }, 
  run = run 
}

end
