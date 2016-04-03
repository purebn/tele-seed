do local _ = {
  disabled_channels = {
    ["channel#id1021702168"] = false,
    ["channel#id1030134438"] = false,
    ["channel#id1031652918"] = false,
    ["channel#id1034034237"] = false,
    ["channel#id1037941432"] = false
  },
  enabled_plugins = {
    "anti-spam",
    "banhammer",
    "Super-Manager",
    "download_media",
    "feedback",
    "lock-tgservice",
    "mute",
    "rem-admin-reply",
    "royaltg",
    "set-admin-reply",
    "plugins",
    "reload",
    "welcome",
    "lock_url",
    "robot",
    "del",
    "auto-leave",
    "lock_tag"
  },
  moderation = {
    data = "data/moderation.json"
  },
  sudo_users = {
    174747020,
    140529465
  }
}
return _
end