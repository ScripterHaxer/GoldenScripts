local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local window = library.CreateLib("EzPets - v0.1", "BloodTheme")

--AutoFarm Settings Init
getgenv().autofarmworld = "Spawn"
getgenv().autofarmarea = "Town"
getgenv().autofarmtarget = "All"

getgenv().eggtype = "Cracked Egg"
getgenv().eggamount = 1

getgenv().prefixcolor = "yellow"
getgenv().prefix = "EzPets"
getgenv().usernamecolor = "teal"
getgenv().username = game:GetService("Players").LocalPlayer.Name
getgenv().messagecolor = "rainbow=true"
getgenv().messageeffect = "boom"
getgenv().message = "Hey guys!"

--Farming
local farming_tab = window:NewTab("Farming")
local autofarm_section = farming_tab:NewSection("AutoFarm")
local autofarmsettings_section = farming_tab:NewSection("Settings")

--AutoFarm
autofarm_section:NewToggle("AutoFarm", "Toggle AutoFarm.", function(bool)
    getgenv().autofarm = bool
	if getgenv().autofarm then
		AutoFarm()
	end
end)

function AutoFarm()
	spawn(function()
		while wait() and getgenv().autofarm do
			if getgenv().autofarmtarget ~= "All" then
				for coin, v in pairs(game.Workspace['__THINGS']['__REMOTES']["get coins"]:InvokeServer({})[1]) do
					if game:GetService("Workspace")["__THINGS"].Coins:FindFirstChild(coin) then
						if game:GetService("Workspace")["__THINGS"].Coins[coin]:FindFirstChild("Shine2", true) then
							local targets_particlescolor = {
								["Magma Chest"] = "0 1 0.952941 0.254902 0 1 1 0.952941 0.254902 0 ",
								["Enchanted Chest"] = "0 0.745098 1 1 0 1 0.745098 1 1 0 ",
								["Haunted Chest"] = "0 0.639216 0.345098 1 0 1 0.639216 0.345098 1 0 "
							}

							if targets_particlescolor[getgenv().autofarmtarget] == tostring(game:GetService("Workspace")["__THINGS"].Coins[coin].Coin.Particles.Shine2.Color) then
								for i, pet in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Frame.Main.Pets:GetChildren()) do
									if pet.ClassName == 'TextButton' and pet.Equipped.Visible then
										game.Workspace['__THINGS']['__REMOTES']["join coin"]:InvokeServer({[1] = coin, [2] = {[1] = pet.name}})
										game.Workspace['__THINGS']['__REMOTES']["farm coin"]:FireServer({[1] = coin, [2] = pet.name})
									end
								end

								while game:GetService("Workspace")["__THINGS"].Coins:FindFirstChild(coin) do
									wait()
								end
							end
						end
					end
				end
			else
				for coin, location in pairs(game.Workspace['__THINGS']['__REMOTES']["get coins"]:InvokeServer({})[1]) do
					if getgenv().autofarm and location.w == getgenv().autofarmworld and location.a == string.gsub(getgenv().autofarmarea, " Island", "") then
						if game:GetService("Workspace")["__THINGS"].Coins:FindFirstChild(coin) then
							for i, pet in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Frame.Main.Pets:GetChildren()) do
								if pet.ClassName == 'TextButton' and pet.Equipped.Visible then
									game.Workspace['__THINGS']['__REMOTES']["join coin"]:InvokeServer({[1] = coin, [2] = {[1] = pet.name}})
									game.Workspace['__THINGS']['__REMOTES']["farm coin"]:FireServer({[1] = coin, [2] = pet.name})
								end
							end

							while game:GetService("Workspace")["__THINGS"].Coins:FindFirstChild(coin) do
								wait()
							end
						end
					end
				end
			end
		end
	end)
end

autofarm_section:NewToggle("Instant Collect", "Toggle Instant Collect.", function(bool)
    getgenv().instantcollect = bool
	if getgenv().instantcollect then
		InstantCollect()
	end
end)

function InstantCollect()
	spawn(function()
		while wait() and getgenv().instantcollect do
			for i, v in pairs(game:GetService("Workspace")["__THINGS"].Orbs:GetChildren()) do
				local args = {
					[1] = {
						[1] = {
							[1] = v.name
						}
					}
				}

				workspace.__THINGS.__REMOTES:FindFirstChild("claim orbs"):FireServer(unpack(args))
			end
		end
	end)
end

autofarm_section:NewToggle("Farming Stats", "Toggle Farming Stats (Credits: Gerard#0001).", function(bool)
	getgenv().stats = bool
	if getgenv().stats then
		Stats()
	end
end)

function Stats()
	local menus = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right
	local types = {"Fantasy Coins", "Coins", "Diamonds"}
	_G.MyTypes = {}

	function comma_value(amount)
		local formatted = amount
		while true do  
			formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
			if (k == 0) then
				break
			end
		end
		return formatted
	end

	function get(thistype)
		return string.gsub(game.Players.LocalPlayer.PlayerGui.Main.Right[thistype].Amount.Text, ",", "")
	end

	game:GetService("Players").LocalPlayer.PlayerGui.Main.Right.Coins.LayoutOrder = 99997
	game:GetService("Players").LocalPlayer.PlayerGui.Main.Right.UIListLayout.HorizontalAlignment = 2

	for i, v in pairs(types) do
		if not menus:FindFirstChild(v .. "2") then
			local tempmaker = menus:FindFirstChild(v):Clone()
			tempmaker.Name = tostring(tempmaker.Name .. "2")
			tempmaker.Parent = menus
			tempmaker.Size = UDim2.new(0, 200, 0, 35)
			_G.MyTypes[v] = tempmaker

		end
	end

	game:GetService("Players").LocalPlayer.PlayerGui.Main.Right.Diamonds2.Add.Visible = false

	for i, v in pairs(types) do
		spawn(function()
			local megatable = {}
			local imaginaryi = 1
			while wait(0.5) and getgenv().stats do
				local currentbal = get(v)
				megatable[imaginaryi] = currentbal
				local diffy = currentbal - (megatable[imaginaryi-120] or megatable[1])
				imaginaryi = imaginaryi + 1 
				_G.MyTypes[v].Amount.Text = tostring(comma_value(diffy) .." in 60s")
				_G.MyTypes[v]["Amount_odometerGUIFX"].Text = tostring(comma_value(diffy) .." in 60s")
			end

			_G.MyTypes[v]:Destroy()

		end)
	end
end

--AutoFarm Settings
local worlds = {}
for i, v in pairs(game:GetService("ReplicatedStorage").Game.Coins:GetChildren()) do
	table.insert(worlds, v.name)
end

autofarmsettings_section:NewDropdown("World", "Choose world where you want to AutoFarm.", worlds, function(choice)
    getgenv().autofarmworld = choice

	local areas = {}
	for i, v in pairs(game:GetService("ReplicatedStorage").Game.Coins[getgenv().autofarmworld]:GetChildren()) do
		table.insert(areas, v.name)
	end

	areas_dropdown:Refresh(areas)
end)

local areas = {}
for i, v in pairs(game:GetService("ReplicatedStorage").Game.Coins[getgenv().autofarmworld]:GetChildren()) do
	table.insert(areas, v.name)
end

areas_dropdown = autofarmsettings_section:NewDropdown("Area", "Choose area where you want to AutoFarm.", areas, function(choice)
    getgenv().autofarmarea = choice
end)

local targets = {"All"}
for i, v in pairs(game:GetService("ReplicatedStorage").Assets.CoinAssets:GetDescendants()) do
	if v.name == "Particles" and v.parent.name ~= "Super Chest" then
		table.insert(targets, v.parent.name)
	end
end

autofarmsettings_section:NewDropdown("Target", "Choose target you want to AutoFarm.", targets, function(choice)
	getgenv().autofarmtarget = choice
end)

--Pets
local pets_tab = window:NewTab("Pets")
local eggs_section = pets_tab:NewSection("Open Eggs")

local eggs = {}
for i, v in pairs(game:GetService("ReplicatedStorage").Game.Eggs:GetChildren()) do
	table.insert(eggs, v.name)
end

eggs_section:NewDropdown("Egg Type", "Choose egg type you want to Hatch.", eggs, function(choice)
	getgenv().eggtype = choice
end)

eggs_section:NewTextBox("Egg Amount", "Define egg amount you want to Hatch.", function(text)
	getgenv().eggamount = tonumber(text)
end)

eggs_section:NewButton("Start Hatching", "Start Hatching eggs.", function()
	spawn(function()
		for i = 1, getgenv().eggamount do
			local args = {
				[1] = {
					[1] = getgenv().eggtype,
					[2] = false
				}
			}

			workspace.__THINGS.__REMOTES:FindFirstChild("buy egg"):InvokeServer(unpack(args))

			wait(1)
		end
	end)
end)

--Movement
local movement_tab = window:NewTab("Movement")
local movement_section = movement_tab:NewSection("Movement")

--NoClip
movement_section:NewToggle("NoClip", "Toggle NoClip.", function(bool)
    getgenv().noclip = bool
	if getgenv().noclip then
		NoClip()
	end
end)

function NoClip()
	spawn(function()
		while getgenv().noclip do
				for i, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
					pcall(function()
						if v:IsA("BasePart") and v.CanCollide then
							v.CanCollide = false
						end
					end)
				end

			game:GetService("RunService").Stepped:Wait()
		end
	end)
end

--WalkSpeed
movement_section:NewSlider("WalkSpeed", "Modify your WalkSpeed.", 250, 16, function(value)
    getgenv().walkspeed = value
	if game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed ~= getgenv().walkspeed then
		game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().walkspeed
	end
end)

--JumpPower
movement_section:NewSlider("JumpPower", "Modify your JumpPower.", 250, 50, function(value)
    getgenv().jumppower = value
	if game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower ~= getgenv().jumppower then
		game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = getgenv().jumppower
	end
end)

--Chat
local chat_tab = window:NewTab("Chat")
local chat_section = chat_tab:NewSection("Chat")

chat_section:NewDropdown("Prefix Color", "Choose your Prefix Color.", {"Red", "Yellow", "Orange", "Green", "Teal", "Blue", "Purple", "Pink", "White", "Brown", "Black", "Grey"}, function(choice)
	getgenv().prefixcolor = string.lower(choice)
end)

chat_section:NewTextBox("Prefix", "Define your prefix.", function(text)
	getgenv().prefix = text
end)

chat_section:NewDropdown("Username Color", "Choose your Username Color.", {"Red", "Yellow", "Orange", "Green", "Teal", "Blue", "Purple", "Pink", "White", "Brown", "Black", "Grey"}, function(choice)
	getgenv().usernamecolor = string.lower(choice)
end)

chat_section:NewTextBox("Username", "Define your username.", function(text)
	getgenv().username = text
end)

chat_section:NewDropdown("Message Color", "Choose your Username Color.", {"Red", "Yellow", "Orange", "Green", "Teal", "Blue", "Purple", "Pink", "White", "Brown", "Black", "Grey", "Rainbow"}, function(choice)
	if choice == "Rainbow" then
		getgenv().messagecolor = "rainbow=true"
	else
		getgenv().messagecolor = "color="..string.lower(choice)
	end
end)

chat_section:NewDropdown("Message Effect", "Choose your Message Effect.", {"Boom", "Pop"}, function(choice)
	getgenv().messageeffect = string.lower(choice)
end)

chat_section:NewTextBox("Message", "Define your message.", function(text)
	getgenv().message = text
end)

chat_section:NewButton("Send", "Send your message.", function()
	local args = {
		[1] = "<color=".. getgenv().prefixcolor ..">[".. getgenv().prefix .. "] <color=".. getgenv().usernamecolor ..">[".. getgenv().username .."]: <".. getgenv().messageeffect .."=true><".. getgenv().messagecolor ..">"..getgenv().message,
		[2] = "All"
	}

	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
end)

--Others
local others_tab = window:NewTab("Others")
local others_section = others_tab:NewSection("Others")

others_section:NewButton("Unlock all Gamepasses", "Unlock all Gamepasses.", function()
	require(game:GetService("ReplicatedStorage").Framework.Modules.Client["5 | Gamepasses"]).Owns = function() return true end
end)

others_section:NewToggle("AutoCollect Rank Rewards", "Toggle AutoCollecting Rank Rewards.", function(bool)
	getgenv().autorankrewards = bool
	if getgenv().autorankrewards then
		AutoRankRewards()
	end
end)

function AutoRankRewards()
	spawn(function()
		while wait() and getgenv().autorankrewards do
			local args = {
				[1] = {}
			}

			workspace.__THINGS.__REMOTES:FindFirstChild("redeem rank rewards"):InvokeServer(unpack(args))
		end
	end)
end

others_section:NewToggle("AutoCollect VIP Rewards", "Toggle AutoCollecting VIP Rewards.", function(bool)
	getgenv().autoviprewards = bool
	if getgenv().autoviprewards then
		AutoVIPRewards()
	end
end)

function AutoVIPRewards()
	spawn(function()
		while wait() and getgenv().autoviprewards do
			local args = {
				[1] = {}
			}

			workspace.__THINGS.__REMOTES:FindFirstChild("redeem vip rewards"):InvokeServer(unpack(args))
			
			wait()
		end
	end)
end

--AntiAFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

--Settings
local settings_tab = window:NewTab("Settings")
local settings_section = settings_tab:NewSection("UI")

settings_section:NewKeybind("Toggle UI Keybind", "Bind your key to toggle UI.", Enum.KeyCode.RightShift, function()
	library:ToggleUI()
end)

--Credits
local credits_tab = window:NewTab("Credits")
local credits_section = credits_tab:NewSection("Credits")

credits_section:NewButton("Goldy#1337", "Main Developer.", function()
	setclipboard("Goldy#1337")
end)

credits_section:NewButton("Discord Server", "Join Discord Server!", function()
	setclipboard("https://discord.com/invite/rB78dXRfWD")
end)