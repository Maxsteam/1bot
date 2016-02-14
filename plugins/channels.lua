-- Checks if bot was disabled on specific chat
local function is_channel_dis( receiver )
	if not _config.dis_channels then
		return false
	end

	if _config.dis_channels[receiver] == nil then
		return false
	end

  return _config.disa_channels[receiver]
end

local function en_channel(receiver)
	if not _config.dis_channels then
		_config.disabled_channels = {}
	end

	if _config.dis_channels[receiver] == nil then
		return 'Channel isn\'t disabled'
	end
	
	_config.dis_channels[receiver] = false

	save_config()
	return "Channel re-enabled"
end

local function disable_channel( receiver )
	if not _config.dis_channels then
		_config.dis_channels = {}
	end
	
	_config.dis_channels[receiver] = true

	save_config()
	return "Channel disabled"
end

local function pre_process(msg)
	local receiver = get_receiver(msg)
	
	-- If sender is sudo then re-enable the channel
	if is_sudo(msg) then
	  if msg.text == "!channel en" then
	    ena_channel(receiver)
	  end
	end

  if is_channel_dis(receiver) then
  	msg.text = ""
  end

	return msg
end

local function run(msg, matches)
	local receiver = get_receiver(msg)
	-- Enable a channel
	if matches[1] == 'en' then
		return enable_channel(receiver)
	end
	-- Disable a channel
	if matches[1] == 'dis' then
		return disable_channel(receiver)
	end
end

return {
	description = "Plugin to manage channels. Enable or disable channel.", 
	usage = {
		"!channel en: enable current channel",
		"!channel dis: disable current channel" },
	patterns = {
		"^!channel? (en)",
		"^!channel? (dis)" }, 
	run = run,
	privileged = true,
	pre_process = pre_process
}
