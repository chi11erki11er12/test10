do
    -- library
    local repo = "https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/"
    local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
    local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
    local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
    Library:Notify("Anti-AFK loaded!")

    -- varbs
    local plr = game:GetService("Players").LocalPlayer
    local rep = game:GetService("ReplicatedStorage")
    local rebirthShop = require(rep.RebirthShopModule).rebirthShop
    local mod = require(rep.FunctionsModule)
    local wrk = game:GetService("Workspace")
    local Gamepass = plr.Data.gamepasses
    local rebMod = getsenv(plr.PlayerGui.mainUI.rebirthBackground.LocalScript)
    local rs = game:GetService("RunService")
    local vu = game:GetService("VirtualUser")
    -- anti afk
    plr.Idled:connect(function()
        vu:Button2Down(Vector2.new(0, 0), wrk.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), wrk.CurrentCamera.CFrame)
    end)

    -- tables
    local function shopTable()
        local shopTable = {}
        for _, v in next, rebirthShop do if rawget(v, "name") then table.insert(shopTable, v.name) end end
        return shopTable
    end
    local function getEggs()
        local newEggs = {unpack(require(rep.EggModule).Order)}
        for _, v in next, wrk.Eggs:GetChildren() do
            if not tostring(v):find("Robux") and not table.find(newEggs, tostring(v)) and
                not table.find(require(rep.EggModule).Order, tostring(v)) then
                table.insert(newEggs, tostring(v))
            end
        end
        return newEggs
    end
    local function giveRebirths()
        local rebirthsTable = {1, 5, 10}
        for _, v in next, rebirthShop do
            if rawget(v, "rebirthOption") then table.insert(rebirthsTable, v.rebirthOption) end
        end
        return rebirthsTable
    end
    local function giveZones()
        local zonesTable = {}
        for i, v in next, wrk.Zones:GetChildren() do table.insert(zonesTable, v.Name) end
        return zonesTable
    end

    -- functions
    local function teleportTo(pos) plr.Character.HumanoidRootPart.CFrame = pos.CFrame + Vector3.new(0, 5, 0) end
    function Invite()
        if not isfolder('Mint') then
            makefolder('Mint')
        end
        if isfile('Mint.txt') == false then
            (syn and syn.request or http_request)({
                Url = 'http://127.0.0.1:6463/rpc?v=1',
                Method = 'POST',
                Headers = {
                    ['Content-Type'] = 'application/json',
                    ['Origin'] = 'https://discord.com'
                },
                Body = game:GetService('HttpService'):JSONEncode({
                    cmd = 'INVITE_BROWSER',
                    args = {
                        code = 'JUEu7XFBXD'
                    },
                    nonce = game:GetService('HttpService'):GenerateGUID(false)
                }),
                writefile('Mint.txt', 'discord')
            })
        end
    end

    -- ui
    local Window = Library:CreateWindow({
        Title = "Mint Hub",
        Center = true,
        AutoShow = true,
        Size=UDim2.fromOffset(570, 620),
    })
    do
        local Tabs = {
            Main = Window:AddTab("Main"),
            ["UI Settings"] = Window:AddTab("UI Settings")
        }
        local lfFarm = Tabs.Main:AddLeftTabbox("Farming")
        local tFarm = lfFarm:AddTab("Farming")
        local rtPB = Tabs.Main:AddRightTabbox("Pets & Rebirth")
        local tP = rtPB:AddTab("Pets")
        local tB = rtPB:AddTab("Rebirths")
        local rtTP = Tabs.Main:AddRightTabbox("Teleportation")
        local tTP = rtTP:AddTab("Teleportation")
        local rtPLR = Tabs.Main:AddLeftTabbox("Local Player")
        local tPLR = rtPLR:AddTab("Local Player")
        local rtMisc = Tabs.Main:AddLeftTabbox("Misc")
        local tMisc = rtMisc:AddTab("Misc.")
        local rtCredits = Tabs.Main:AddRightTabbox("Credits")
        local tCredits = rtCredits:AddTab("Credits")
        local rtDisc = Tabs.Main:AddRightTabbox("Discord")
        local tDisc = rtDisc:AddTab("Discord")
        do -- clicking section
            tFarm:AddToggle("autoclick", {Text = "Auto click",Default = false,Tooltip = "Disable effects from game settings"}):AddKeyPicker("AutoplayerBind", {Default = "E",NoUI = true,SyncToggleState = true})
            tFarm:AddButton("Unlock x2 click boost", function() plr.Boosts.DoubleClicks.isActive.Value = true end)
            tFarm:AddDivider()
            tFarm:AddToggle("auto_wheel", {Text = "Auto collect wheel prize",Default = false})
            tFarm:AddToggle("autogifts", {Text = "Auto collect random gifts",Default = false})
            tFarm:AddToggle("auto_achievements", {Text = "Auto collect achievements",Default = false})
            tFarm:AddToggle("auto_chests", {Text = "Auto collect chests",Default = false,Tooltip = "This feature might cause lag"})
            tFarm:AddButton("Collect chests", function()
                for _, v in pairs(wrk.Chests:GetChildren()) do
                    rep.Events.Client.claimChestReward:InvokeServer(v.Name)
                end
            end)
            tFarm:AddDivider()
            tFarm:AddToggle("auto_jumps", {Text = "Auto buy jumps",Default = false})
            tFarm:AddToggle("auto_buy_buttons", {Text = "Auto buy rebirth buttons",Default = false,Tooltip = "This feature buy the pets aswell"})
        end
        do -- pets and rebirths
            tP:AddDropdown("egg", {Values = getEggs(),Default = "~~~",Multi = false,Text = "Eggs"})
            tP:AddToggle("auto_hatch", {Text = "Auto hatch",Default = false})
            tP:AddToggle("auto_x2_hatch", {Text = "Auto x2 hatch",Default = false})
            tP:AddToggle("auto_x3_chests", {Text = "Auto x3 hatch",Default = false})
            local luckB = tP:AddButton("Unlock x2 luck boost",function() plr.Boosts.DoubleLuck.isActive.Value = true end)
            luckB:AddTooltip("Might be visual, not sure")
            tP:AddDivider()
            tP:AddToggle("auto_best", {Text = "Auto equip best",Default = false})
            tP:AddButton("Instant mass delete", function()
                rep.Events.Client.petsTools.deleteUnlocked:FireServer()
            end)
            tP:AddButton("Craft shiny all", function()
                for _, v in next, plr.petOwned:GetChildren() do
                    rep.Events.Client.upgradePet:FireServer(v.name.Value, 1, v)
                end
            end)
            tP:AddButton("Craft golden all", function()
                for _, v in next, plr.petOwned:GetChildren() do
                    rep.Events.Client.upgradePet:FireServer(v.name.Value, 2, v)
                end
            end)
            tB:AddDropdown("rebirth", {Values = giveRebirths(),Default = "~~~",Multi = false,Text = "Rebirths"})
            tB:AddToggle("auto_rebirth", {Text = "Auto rebirth",Default = false})
            tB:AddInput("inf_rebirth", {Default = "~~~",Numeric = true,Finished = false})
            tB:AddToggle("auto_inf_rebirth", {Text = "Auto inf. rebirth",Default = false})
        end
        do -- teleport
            tTP:AddDropdown("zone", {Values = giveZones(),Default = "~~~",Multi = false,Text = "Zones"})
            tTP:AddButton("Teleport", function()
                teleportTo(wrk.Zones[Options.zone.Value].Island.Platform.UIPart)
            end)
        end
        do -- local player
            tPLR:AddSlider("walkspeed", {Text = "Walkspeed value",Default = 16,Min = 16,Max = 200,Rounding = 0,Compact = false})
            tPLR:AddSlider("jumppower", {Text = "Jumppower value",Default = 50,Min = 50,Max = 200,Rounding = 0,Compact = false})
        end
        do -- Misc.
            tMisc:AddButton("Collect all codes", function()
                local codesTable = {"150KCLICKS", "125KLUCK", "100KLIKES", "75KLIKES", "50KLikes", "30klikes",
                                    "20KLIKES", "freeautohatch", "175KLIKELUCK", "225KLIKECODE", "200KLIKECODE",
                                    "250KLIKECLICKS", "275K2XSHINY", "300SHINYCHANCE", "300DOUBLELUCK", "325CLICKS2","twitter100k",
                                    "tokcodeluck12", "LIKECLICK12", "2xlongluck350"}
                for _, v in pairs(codesTable) do rep.Events.Client.useTwitterCode:InvokeServer(v) end
            end)
            tMisc:AddButton("Unlock auto clicker gamepass",
                function() Gamepass.Value = Gamepass.Value .. ";autoclicker;" end)
            tMisc:AddButton("Unlock auto rebirth gamepass",
                function() Gamepass.Value = Gamepass.Value .. ";autorebirth;" end)
        end
        do -- Credits
            tCredits:AddLabel("Script: <font color='#3EB489'>Trustsense</font>")
            tCredits:AddLabel("Hot library: <font color='#ADD8E6'>wally</font>")
            tCredits:AddLabel("Additional Help: <font color='#5865F2'>Discord !0000</font>")
        end
        do
            tDisc:AddButton("Copy discord invite", function() setclipboard("https://discord.gg/JUEu7XFBXD") end)
            local DiscButton = tDisc:AddButton("Open discord invite", function() Invite() end)
            DiscButton:AddTooltip("You need to have discord open.")
        end
        do -- Ui settings
            local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
            MenuGroup:AddButton("Unload", function() Library:Unload() end)
            MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {Default = "End",NoUI = true,Text = "Menu keybind"})
            Library.ToggleKeybind = Options.MenuKeybind
            ThemeManager:SetLibrary(Library)
            SaveManager:SetLibrary(Library)
            SaveManager:IgnoreThemeSettings()
            SaveManager:SetIgnoreIndexes({"MenuKeybind"})
            ThemeManager:SetFolder("MyScriptHub")
            SaveManager:SetFolder("MyScriptHub/collectallpets!")
            SaveManager:BuildConfigSection(Tabs["UI Settings"])
            ThemeManager:ApplyToTab(Tabs["UI Settings"])
        end
    end

    -- script
    rs.RenderStepped:connect(function()
        if Toggles.autoclick.Value then getsenv(plr.PlayerGui.mainUI.HUDHandler).activateClick() end
        if Toggles.auto_wheel.Value then
            if plr.Data.freeSpinTimeLeft.Value == 0 then rep.Events.Client.spinWheel:InvokeServer() end
        end
        if Toggles.autogifts.Value then
            for i, v in pairs(getconnections(plr.PlayerGui.randomGiftUI.randomGiftBackground.Background.confirm.MouseButton1Click)) do v.Function() end
        end
        if Toggles.auto_achievements.Value then
            for i, v in next, plr.currentQuests:GetChildren() do
                if v.questCompleted.Value == true then rep.Events.Client.claimQuest:FireServer(v.Name) end
            end
        end
        if Toggles.auto_chests.Value then
            for _, v in next, wrk.Chests:GetChildren() do
                rep.Events.Client.claimChestReward:InvokeServer(v.Name)
            end
        end
        if Toggles.auto_jumps.Value then
            for _, v in next, wrk.Clouds:GetChildren() do
                rep.Events.Client.upgrades.upgradeDoubleJump:FireServer(v.Name, 1)
            end
        end
        if Toggles.auto_buy_buttons.Value then
            for _, v in next, shopTable() do rep.Events.Client.purchaseRebirthShopItem:FireServer(v) end
        end
        if Toggles.auto_hatch.Value then
            rep.Events.Client.purchaseEgg2:InvokeServer(wrk.Eggs[Options.egg.Value], false, false)
        end
        if Toggles.auto_x2_hatch.Value then
            rep.Events.Client.purchaseEgg2:InvokeServer(wrk.Eggs[Options.egg.Value], false, false, true)
        end
        if Toggles.auto_x3_chests.Value then
            rep.Events.Client.purchaseEgg2:InvokeServer(wrk.Eggs[Options.egg.Value], true, false)
        end
        if Toggles.auto_best.Value then
            if plr.PlayerGui.framesUI.petsBackground.Background.background.tools.equipBest.BackgroundColor3 ==
                Color3.fromRGB(64, 125, 255) then rep.Events.Client.petsTools.equipBest:FireServer() end
        end
        if Toggles.auto_rebirth.Value then rebMod.requestRebirth(tonumber(Options.rebirth.Value)) end
        if Toggles.auto_inf_rebirth.Value then rebMod.requestRebirth(tonumber(Options.inf_rebirth.Value)) end
        plr.Character.Humanoid.WalkSpeed = Options.walkspeed.Value
        plr.Character.Humanoid.JumpPower = Options.jumppower.Value
    end)
end
