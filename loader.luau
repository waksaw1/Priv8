local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to loaded!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = WindUI:CreateWindow({
    Title = "GTM Priv8",
    Icon = "rbxassetid://76359922617088",
    Author = "Fish It | Premium",
    Folder = "VORA_HUB",
    Size = UDim2.fromOffset(260, 290),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
    User = {
        Enabled = false,
        Anonymous = false,
        Callback = function()
            WindUI:SetTheme("Dark")
        end,
    },                                                            
})

Window:SetToggleKey(Enum.KeyCode.G)

WindUI:Notify({
    Title = "VORA HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({
    Title = "Info",
    Icon = "info",
})

local Section = Tab1:Section({
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab1:Button({
    Title = "Discord",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/9Jqm9UsKer")
            WindUI:Notify({Title = "Discord", Content = "Link Copied To Clipboard", Duration = 3}) 
        end
    end
})


local Section = Tab1:Section({
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17,
})

------------------ Remote --------------------------
local S = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    RunService = game:GetService("RunService"),
    HttpService = game:GetService("HttpService"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    Camera = workspace.CurrentCamera,
    Workspace = workspace,
}

local player = S.Players.LocalPlayer
local RS = S.ReplicatedStorage
local hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart") or player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")

--// Modules
local Net = RS.Packages._Index["sleitnick_net@0.2.0"].net
local Replion = require(RS.Packages.Replion)
local FishingController = require(RS.Controllers.FishingController)
local ItemUtility = require(RS.Shared.ItemUtility)
local VendorUtility = require(RS.Shared.VendorUtility)
local Data = Replion.Client:WaitReplion("Data")
local Items = RS:WaitForChild("Items")

--// Remotes
local RE = {
    FavoriteItem = Net:FindFirstChild("RE/FavoriteItem"),
    FavoriteStateChanged = Net:FindFirstChild("RE/FavoriteStateChanged"),
    FishingCompleted = Net:FindFirstChild("RE/FishingCompleted"),
    FishCaught = Net:FindFirstChild("RE/FishCaught"),
    TextNotification = Net:FindFirstChild("RE/TextNotification"),
    EquipItem = Net:FindFirstChild("RE/EquipItem"),
    ActivateAltar = Net:FindFirstChild("RE/ActivateEnchantingAltar"),
    EquipTool = Net:FindFirstChild("RE/EquipToolFromHotbar"),
    EvReward  = Net:FindFirstChild("RE/ClaimEventReward"),
}

local RF = {
    PurchaseRod = Net:FindFirstChild("RF/PurchaseFishingRod"),
    PurchaseBait = Net:FindFirstChild("RF/PurchaseBait"),
    PurchaseWeather = Net:FindFirstChild("RF/PurchaseWeatherEvent"),
    ChargeRod = Net:FindFirstChild("RF/ChargeFishingRod"),
    Minigame = Net:FindFirstChild("RF/RequestFishingMinigameStarted"),
    UpdateSell = Net:FindFirstChild("RF/UpdateAutoSellThreshold"),
    SpecialEvent = Net:FindFirstChild("RF/SpecialDialogueEvent"),
    SellItem = Net:FindFirstChild("RF/SellItem"),
}

----------------------------------------------------------------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Config = {
    InstantCancelDelay = 1.7,
    InstantCompleteDelay = 1.4
}
------------------ Variable ------------------------
_G.AutoFarm = false
_G.AutoRod = false
local AutoSellAnjay = false
_G.InfiniteJump = false
_G.AutoKaitun = false
_G.Radar = false
_G.AntiAFK = false
_G.AutoReconnect = false
autoFavEnabled = false

------------------ Fishing logic -------------------]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetService = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local chargeRod = NetService:WaitForChild("RF/ChargeFishingRod")
local startMinigame = NetService:WaitForChild("RF/RequestFishingMinigameStarted")
local completeFishing = NetService:WaitForChild("RE/FishingCompleted")
local equipTool = NetService:WaitForChild("RE/EquipToolFromHotbar")
local sellAllItems = NetService:WaitForChild("RF/SellAllItems")
local cancelFishing = NetService:WaitForChild("RF/CancelFishingInputs")
local enchan = NetService:WaitForChild("RE/ActivateEnchantingAltar")
local oxygenRemote = NetService:WaitForChild("URE/UpdateOxygen")
local function rod()
    NetService:WaitForChild("RE/EquipToolFromHotbar"):FireServer(1)
end
local function sell()
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/SellAllItems"):InvokeServer()
end
local function radar()
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/UpdateFishingRadar"):InvokeServer(true)
end
local function autoon()
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/UpdateAutoFishingState"):InvokeServer(true)
end

local function autosell()
    while AutoSellAnjay do
        sell()
        task.wait(selldelay)
    end
end

--------------------------------------- Fishing Logic V2 ------------------------------------------------
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local REBaitSpawned = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/BaitSpawned"]
    REBaitSpawned.OnClientEvent:Connect(function(playerWhoSpawned, baitName, position)
        if _G.Instant then
            wait(0.5)        
     
            pcall(function()
                ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]:InvokeServer(2)
                ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/RequestFishingMinigameStarted"]:InvokeServer(-1.25, 1)
            end)
        end
    end)


------------------- Fishing Logic ------------------
local function Blantant()
    task.spawn(function()
        cancelFishing:InvokeServer()
        task.wait(Config.InstantCancelDelay)
        chargeRod:invokeServer(1)
        startMinigame:InvokeServer(-1, 0.1, 1761532005.497536)
        task.wait(Config.InstantCompleteDelay)
        completeFishing:FireServer()
    end)
end

local function BlantantRandom()
    task.spawn(function()
        cancelFishing:InvokeServer()
        task.wait(Config.InstantCancelDelay)
        chargeRod:invokeServer(1)
        task.wait(0.21)
        startMinigame:InvokeServer(-1, 0.1, 1761532005.497536)
        task.wait(Config.InstantCompleteDelay)
        completeFishing:FireServer()
    end)
end

local function SuperFishing()
    Blantant()
end

local function SuperFishingRandom()
    BlantantRandom()
end

_G.Blantant = 2.0

local function startblantant()
    if blantantruning then return end
    blantantruning = true
    rod()
    task.spawn(function()
    while blantantruning do
        local start = tick()
        SuperFishing()
        while blantantruning and tick() - start < _G.Blantant do
            task.wait()
        end
    end
    end)
end

local function startblantantrandom()
    if blantantrandomruning then return end
    blantantrandomruning = true
    rod()
    task.spawn(function()
    while blantantrandomruning do
        local start = tick()
        SuperFishingRandom()
        while blantantrandomruning and tick() - start < _G.Blantant do
            task.wait()
        end
    end
    end)
end

local function stopblantant()
    if blantantruning then return end
    blantantruning = false
end

local function stopblantantrandom()
    if blantrandomantruning then return end
    blantantrandomruning = false
end

local function instant()
    while _G.AutoFarm do
        chargeRod:InvokeServer(1)
        startMinigame:InvokeServer(-1, 0.1)
        task.wait(delayfishing)
        completeFishing:FireServer()
    end
end

local function icancel()
    charge()
    task.wait(0)
    lempar()
    task.wait(0)
    cancel()
    task.wait(20)
end

local function legit()
    autoon()
    task.wait(delayfishing)
    completeFishing:FireServer()
end

------------------- Main Tab -----------------------
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "landmark"
})

local MainSection = MainTab:Section({
    Title = "Main",
    TextXAlignment = "Left",
    TextSize = 17,
})

local AutoRod = MainTab:Toggle({
    Title = "Auto Rod",
    Desc = false,
    Icon = false,
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(Value) 
        _G.AutoRod = Value
        if Value then
            rod()
        else return end
    end
})

local CurrentOption = "Instant"

local Dropdown = MainTab:Dropdown({
    Title = "Mode",
    Desc = false,
    Values = { "Instant", "Legit" },
    Value = "Instant",
    Multi = false,
    AllowNone = false,
    Callback = function(Option)
        CurrentOption = Option
        WindUI:Notify({
            Title = "Mode Selected",
            Content = "Mode: " .. Option,
            Duration = 3,
            Icon = "check"
        })
    end
})

local AutoFarm = MainTab:Toggle({
    Title = "Auto Farm",
    Desc = false,
    Icon = false,
    Type = "Toggle",
    Value = false,
    Callback = function(Value)
        _G.AutoFarm = Value

        if Value then
            if CurrentOption == "Instant" then
                WindUI:Notify({
                    Title = "AutoFarm",
                    Content = "Instant Mode ON",
                    Duration = 3
                })

                task.spawn(function()
                    while _G.AutoFarm and CurrentOption == "Instant" do
                        pcall(instant)
                        task.wait(0.1)
                    end
                end)

            elseif CurrentOption == "Legit" then
                WindUI:Notify({
                    Title = "AutoFarm",
                    Content = "Legit Mode ON",
                    Duration = 3
                })

                task.spawn(function()
                    while _G.AutoFarm and CurrentOption == "Legit" do
                        pcall(function()
                            -- mulai lempar pancing
                            FishingController:RequestChargeFishingRod(Vector2.new(0, 0), true)

                            local guid = FishingController.GetCurrentGUID and FishingController:GetCurrentGUID()
                            if guid then
                                -- selama masih di minigame, klik dengan delay random biar “human-like”
                                while _G.AutoFarm and CurrentOption == "Legit" 
                                    and guid == FishingController:GetCurrentGUID() do

                                    FishingController:FishingMinigameClick()
                                    task.wait(math.random(1, 10) / 100) -- 0.08–0.25 detik
                                end
                            end
                        end)
                        task.wait(0.25)
                    end
                end)
            end

        else
            WindUI:Notify({
                Title = "AutoFarm",
                Content = "AutoFarm OFF",
                Duration = 3
            })

            -- stop semua mode saat toggle OFF
            _G.AutoFarm = false
            pcall(autooff)
            pcall(cancel)
        end
    end
})


MainTab:Input({ 
    Title = "Fishing Delay",
    Placeholder = "Contoh: 1.0",
    Default = 1.0,
    Callback = function(value)
        delayfishing = value
    end
})


------------------------------------------------------------------------------






-------------------------------------------------------------------------------

local SellSection = MainTab:Section({
    Title = "Sell",
    Icon = "hand-coins",
    TextXAlignment = "Left",
    TextSize = 17,
})

local AutoSell = MainTab:Toggle({
    Title = "Auto Sell",
    Desc = false,
    Icon = false,
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(Value) 
        AutoSellAnjay = Value
        if Value then
            autosell()
        end
    end
})

MainTab:Input({ 
    Title = "Sell Delay",
    Placeholder = "Contoh: 30",
    Default = 30,
    Callback = function(value)
        selldelay = value
    end
})

------------------ Player Tab ------------------
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user"
})

PlayerTab:Input({ 
    Title = "Walk Speed",
    Placeholder = "Contoh: 18",
    Default = 18,
    Callback = function(value)
        game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = value
    end
})

PlayerTab:Input({ 
    Title = "Jump Power",
    Placeholder = "Contoh: 2.0",
    Default = 2.0,
    Callback = function(value)
        game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").JumpPower = value
    end
})

local UserInputService = game:GetService("UserInputService")

local InfiniteJump = PlayerTab:Toggle({
    Title = "Infinite Jump",
    Desc = false,
    Icon = false,
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(Value)
        _G.InfiniteJump = Value

        if Value then
            print("✅ Infinite Jump Active")

            -- Buat koneksi satu kali
            InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                if _G.InfiniteJump then
                    local character = Player.Character or Player.CharacterAdded:Wait()
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            print("❌ Infinite Jump Inactive")
            end
        end
})

local FlyGui = PlayerTab:Button({
    Title = "FlyGui V3",
    Desc = false,
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        Notify("Fly GUI Activated")
    end
})

local Shop = Window:Tab({
    Title = "Shop",
    Icon = "badge-dollar-sign",
})

Shop:Section({   
    Title = "Buy Rod",  
    TextXAlignment = "Left",  
    TextSize = 17,  
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")  
local RFPurchaseFishingRod = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]  

local rods = {  
    ["Luck Rod"] = 79,  
    ["Carbon Rod"] = 76,  
    ["Grass Rod"] = 85,  
    ["Demascus Rod"] = 77,  
    ["Ice Rod"] = 78,  
    ["Lucky Rod"] = 4,  
    ["Midnight Rod"] = 80,  
    ["Steampunk Rod"] = 6,  
    ["Chrome Rod"] = 7,  
    ["Astral Rod"] = 5,  
    ["Ares Rod"] = 126,  
    ["Angler Rod"] = 168,
    ["Bamboo Rod"] = 258
}  

local rodNames = {  
    "Luck Rod (350 Coins)", "Carbon Rod (900 Coins)", "Grass Rod (1.5k Coins)", "Demascus Rod (3k Coins)",  
    "Ice Rod (5k Coins)", "Lucky Rod (15k Coins)", "Midnight Rod (50k Coins)", "Steampunk Rod (215k Coins)",  
    "Chrome Rod (437k Coins)", "Astral Rod (1M Coins)", "Ares Rod (3M Coins)", "Angler Rod (8M Coins)",
    "Bamboo Rod (12M Coins)"
}  

local rodKeyMap = {  
    ["Luck Rod (350 Coins)"]="Luck Rod",  
    ["Carbon Rod (900 Coins)"]="Carbon Rod",  
    ["Grass Rod (1.5k Coins)"]="Grass Rod",  
    ["Demascus Rod (3k Coins)"]="Demascus Rod",  
    ["Ice Rod (5k Coins)"]="Ice Rod",  
    ["Lucky Rod (15k Coins)"]="Lucky Rod",  
    ["Midnight Rod (50k Coins)"]="Midnight Rod",  
    ["Steampunk Rod (215k Coins)"]="Steampunk Rod",  
    ["Chrome Rod (437k Coins)"]="Chrome Rod",  
    ["Astral Rod (1M Coins)"]="Astral Rod",  
    ["Ares Rod (3M Coins)"]="Ares Rod",  
    ["Angler Rod (8M Coins)"]="Angler Rod",
    ["Bamboo Rod (12M Coins)"]="Bamboo Rod"
}  

local selectedRod = rodNames[1]  

Shop:Dropdown({  
    Title = "Select Rod",  
    Values = rodNames,  
    Value = selectedRod,  
    Callback = function(value)  
        selectedRod = value  
    end  
})  

Shop:Button({  
    Title="Buy Rod",  
    Callback=function()  
        local key = rodKeyMap[selectedRod]  
        if key and rods[key] then  
            local success, err = pcall(function()  
                RFPurchaseFishingRod:InvokeServer(rods[key])  
            end)  
            if success then  
                WindUI:Notify({Title="Rod Purchase", Content="Purchased "..selectedRod, Duration=3})  
            else  
                WindUI:Notify({Title="Rod Purchase Error", Content=tostring(err), Duration=5})  
            end  
        end  
    end  
})

local Section = Shop:Section({
    Title = "Buy Baits",
    TextXAlignment = "Left",
    TextSize = 17,
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")  
local RFPurchaseBait = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]  

local baits = {
    ["TopWater Bait"] = 10,
    ["Lucky Bait"] = 2,
    ["Midnight Bait"] = 3,
    ["Chroma Bait"] = 6,
    ["Dark Mater Bait"] = 8,
    ["Corrupt Bait"] = 15,
    ["Aether Bait"] = 16
}

local baitNames = {
    "TopWater Bait (100 Coins)",
    "Lucky Bait (1k Coins)",
    "Midnight Bait (3k Coins)",
    "Chroma Bait (290k Coins)",
    "Dark Mater Bait (630k Coins)",
    "Corrupt Bait (1.15M Coins)",
    "Aether Bait (3.7M Coins)"
}

local baitKeyMap = {
    ["TopWater Bait (100 Coins)"] = "TopWater Bait",
    ["Lucky Bait (1k Coins)"] = "Lucky Bait",
    ["Midnight Bait (3k Coins)"] = "Midnight Bait",
    ["Chroma Bait (290k Coins)"] = "Chroma Bait",
    ["Dark Mater Bait (630k Coins)"] = "Dark Mater Bait",
    ["Corrupt Bait (1.15M Coins)"] = "Corrupt Bait",
    ["Aether Bait (3.7M Coins)"] = "Aether Bait"
}

local selectedBait = baitNames[1]  

Shop:Dropdown({  
    Title = "Select Bait",  
    Values = baitNames,  
    Value = selectedBait,  
    Callback = function(value)  
        selectedBait = value  
    end  
})  

Shop:Button({  
    Title = "Buy Bait",  
    Callback = function()  
        local key = baitKeyMap[selectedBait]  
        if key and baits[key] then  
            local success, err = pcall(function()  
                RFPurchaseBait:InvokeServer(baits[key])  
            end)  
            if success then  
                WindUI:Notify({Title = "Bait Purchase", Content = "Purchased " .. selectedBait, Duration = 3})  
            else  
                WindUI:Notify({Title = "Bait Purchase Error", Content = tostring(err), Duration = 5})  
            end  
        end  
    end  
})

Shop:Section({
    Title = "Buy Weather Event",
    Icon = "cloud-drizzle",
    TextXAlignment = "Left",
    TextSize = 17,
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RFPurchaseWeatherEvent = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]

-- Data cuaca
local weathers = {
    ["Wind"] = "Wind",
    ["Cloudy"] = "Cloudy",
    ["Snow"] = "Snow",
    ["Storm"] = "Storm",
    ["Radiant"] = "Radiant",
    ["Shark Hunt"] = "Shark Hunt"
}

-- Nama tampilan
local weatherNames = {
    "Windy (10k Coins)",
    "Cloudy (20k Coins)",
    "Snow (15k Coins)",
    "Stormy (35k Coins)",
    "Radiant (50k Coins)",
    "Shark Hunt (300k Coins)"
}

-- Mapping nama → key internal
local weatherKeyMap = {
    ["Windy (10k Coins)"] = "Wind",
    ["Cloudy (20k Coins)"] = "Cloudy",
    ["Snow (15k Coins)"] = "Snow",
    ["Stormy (35k Coins)"] = "Storm",
    ["Radiant (50k Coins)"] = "Radiant",
    ["Shark Hunt (300k Coins)"] = "Shark Hunt"
}

local selectedWeathers = {}
local autoBuyRunning = false

Shop:Dropdown({
    Title = "Select Weather Events",
    Values = weatherNames,
    Value = selectedWeathers,
    Multi = true,
    Callback = function(values)
        selectedWeathers = values
    end
})

-- Toggle untuk mulai beli semua weather terpilih terus-menerus
Shop:Toggle({
    Title = "Auto Buy Selected Weathers",
    Desc = "Continuously purchase all selected weather events while ON",
    Default = false,
    Callback = function(state)
        autoBuyRunning = state

        if state then
            if #selectedWeathers == 0 then
                WindUI:Notify({
                    Title = "⚠️ No Selection",
                    Content = "Please select at least one weather event before enabling.",
                    Duration = 3
                })
                autoBuyRunning = false
                return
            end

            WindUI:Notify({
                Title = "🌤️ Auto Buy Enabled",
                Content = "Auto-purchase started. It will keep buying until turned off.",
                Duration = 3
            })

            -- Jalankan loop di thread terpisah
            task.spawn(function()
                while autoBuyRunning do
                    for _, selected in ipairs(selectedWeathers) do
                        local key = weatherKeyMap[selected]
                        if key and weathers[key] then
                            local success, err = pcall(function()
                                RFPurchaseWeatherEvent:InvokeServer(weathers[key])
                            end)
                        else
                            WindUI:Notify({
                                Title = "⚠️ Invalid Weather",
                                Content = "Invalid selection: " .. tostring(selected),
                                Duration = 3
                            })
                        end
                    end

                    task.wait(2) -- jeda antar siklus beli (atur sesuai kebutuhan)
                end
            end)
        else
            WindUI:Notify({
                Title = "🛑 Auto Buy Disabled",
                Content = "Weather auto-purchase stopped.",
                Duration = 3
            })
        end
    end
})


local Shop = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

Shop:Section({ 
    Title = "Island",
    Icon = "tree-palm",
    TextXAlignment = "Left",
    TextSize = 17,
})

local IslandLocations = {
    ["Admin Event"] = Vector3.new(-1981, -442, 7428),
    ["Ancient Jungle"] = Vector3.new(1518, 1, -186),
    ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
    ["Crater Island"] = Vector3.new(997, 1, 5012),
    ["Crystal Cavern"] = Vector3.new(-1841, -456, 7186),
    ["Enchant Room"] = Vector3.new(3221, -1303, 1406),
    ["Enchant Room 2"] = Vector3.new(1480, 126, -585),
    ["Esoteric Island"] = Vector3.new(1990, 5, 1398),
    ["Fisherman Island"] = Vector3.new(-175, 3, 2772),
    ["Halloween"] = Vector3.new(2106, 81, 3295),
    ["Kohana Volcano"] = Vector3.new(-545.302429, 17.1266193, 118.870537),
    ["Konoha"] = Vector3.new(-603, 3, 719),
    ["Lost Isle"] = Vector3.new(-3643, 1, -1061),
    ["Sacred Temple"] = Vector3.new(1498, -23, -644),
    ["Sysyphus Statue"] = Vector3.new(-3783.26807, -135.073914, -949.946289),
    ["Treasure Room"] = Vector3.new(-3600, -267, -1575),
    ["Tropical Grove"] = Vector3.new(-2091, 6, 3703),
    ["Underground Cellar"] = Vector3.new(2135, -93, -701),
    ["Weather Machine"] = Vector3.new(-1508, 6, 1895),
}

local SelectedIsland = nil

local IslandDropdown = Shop:Dropdown({
    Title = "Select Island",
    Values = (function()
        local keys = {}
        for name in pairs(IslandLocations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedIsland = Value
    end
})

Shop:Button({
    Title = "Teleport to Island",
    Callback = function()
        if SelectedIsland and IslandLocations[SelectedIsland] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(IslandLocations[SelectedIsland])
        end
    end
})

Shop:Section({ 
    Title = "Fishing Spot",
    TextXAlignment = "Left",
    TextSize = 17,
})

local FishingLocations = {
    ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
    ["Konoha"] = Vector3.new(-603, 3, 719),
    ["Levers 1"] = Vector3.new(1475,4,-847),
    ["Levers 2"] = Vector3.new(882,5,-321),
    ["levers 3"] = Vector3.new(1425,6,126),
    ["levers 4"] = Vector3.new(1837,4,-309),
    ["Sacred Temple"] = Vector3.new(1475,-22,-632),
    ["Spawn"] = Vector3.new(33, 9, 2810),
    ["Sysyphus Statue"] = Vector3.new(-3693,-136,-1045),
    ["Underground Cellar"] = Vector3.new(2135,-92,-695),
    ["Volcano"] = Vector3.new(-632, 55, 197),
}

local SelectedFishing = nil

local FishingDropdown = Shop:Dropdown({
    Title = "Select Spot",
    Values = (function()
        local keys = {}
        for name in pairs(FishingLocations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedFishing = Value
    end
})

Shop:Button({
    Title = "Teleport to Fishing Spot",
    Callback = function()
        if SelectedFishing and FishingLocations[SelectedFishing] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(FishingLocations[SelectedFishing])
        end
    end
})

local Section = Shop:Section({
    Title = "Location NPC",
    TextXAlignment = "Left",
    TextSize = 17,
})

local NPC_Locations = {
    ["Alex"] = Vector3.new(43,17,2876),
    ["Aura kid"] = Vector3.new(70,17,2835),
    ["Billy Bob"] = Vector3.new(84,17,2876),
    ["Boat Expert"] = Vector3.new(32,9,2789),
    ["Esoteric Gatekeeper"] = Vector3.new(2101,-30,1350),
    ["Jeffery"] = Vector3.new(-2771,4,2132),
    ["Joe"] = Vector3.new(144,20,2856),
    ["Jones"] = Vector3.new(-671,16,596),
    ["Lava Fisherman"] = Vector3.new(-593,59,130),
    ["McBoatson"] = Vector3.new(-623,3,719),
    ["Ram"] = Vector3.new(-2838,47,1962),
    ["Ron"] = Vector3.new(-48,17,2856),
    ["Scott"] = Vector3.new(-19,9,2709),
    ["Scientist"] = Vector3.new(-6,17,2881),
    ["Seth"] = Vector3.new(107,17,2877),
    ["Silly Fisherman"] = Vector3.new(97,9,2694),
    ["Tim"] = Vector3.new(-604,16,609),
}

local SelectedNPC = nil

local NPCDropdown = Shop:Dropdown({
    Title = "Select NPC",
    Values = (function()
        local keys = {}
        for name in pairs(NPC_Locations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedNPC = Value
    end
})

Shop:Button({
    Title = "Teleport to NPC",
    Callback = function()
        if SelectedNPC and NPC_Locations[SelectedNPC] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(NPC_Locations[SelectedNPC])
        end
    end
})

local Section = Shop:Section({
    Title = "Event Teleporter",
    TextXAlignment = "Left",
    TextSize = 17,
})

-- ⚙️ Auto Event TP System (Multi-select Dropdown + Spam Teleport)

local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(c)
	character = c
	hrp = c:WaitForChild("HumanoidRootPart")
end)

-- Settings
local megCheckRadius = 150

-- Control states
local autoEventTPEnabled = false
local selectedEvents = {}
local createdEventPlatform = nil

-- Event configurations (with priority)
local eventData = {
	["Worm Hunt"] = {
		TargetName = "Model",
		Locations = {
			Vector3.new(2190.85, -1.4, 97.575), 
			Vector3.new(-2450.679, -1.4, 139.731), 
			Vector3.new(-267.479, -1.4, 5188.531),
			Vector3.new(-327, -1.4, 2422)
		},
		PlatformY = 107,
		Priority = 1,
		Icon = "fish"
	},
	["Megalodon Hunt"] = {
		TargetName = "Megalodon Hunt",
		Locations = {
			Vector3.new(-1076.3, -1.4, 1676.2),
			Vector3.new(-1191.8, -1.4, 3597.3),
			Vector3.new(412.7, -1.4, 4134.4),
		},
		PlatformY = 107,
		Priority = 2,
		Icon = "anchor"
	},
	["Ghost Shark Hunt"] = {
		TargetName = "Ghost Shark Hunt",
		Locations = {
			Vector3.new(489.559, -1.35, 25.406), 
			Vector3.new(-1358.216, -1.35, 4100.556), 
			Vector3.new(627.859, -1.35, 3798.081)
		},
		PlatformY = 107,
		Priority = 3,
		Icon = "fish"
	},
	["Shark Hunt"] = {
		TargetName = "Shark Hunt",
		Locations = {
			Vector3.new(1.65, -1.35, 2095.725),
			Vector3.new(1369.95, -1.35, 930.125),
			Vector3.new(-1585.5, -1.35, 1242.875),
			Vector3.new(-1896.8, -1.35, 2634.375)
		},
		PlatformY = 107,
		Priority = 4,
		Icon = "fish"
	},
}

local eventNames = {}
for name in pairs(eventData) do
	table.insert(eventNames, name)
end

-- Utility
local function destroyEventPlatform()
	if createdEventPlatform and createdEventPlatform.Parent then
		createdEventPlatform:Destroy()
		createdEventPlatform = nil
	end
end

local function createAndTeleportToPlatform(targetPos, y)
	destroyEventPlatform()

	local platform = Instance.new("Part")
	platform.Size = Vector3.new(5, 1, 5)
	platform.Position = Vector3.new(targetPos.X, y, targetPos.Z)
	platform.Anchored = true
	platform.Transparency = 1
	platform.CanCollide = true
	platform.Name = "EventPlatform"
	platform.Parent = Workspace
	createdEventPlatform = platform

	hrp.CFrame = CFrame.new(platform.Position + Vector3.new(0, 3, 0))
end

-- Main function
local function runMultiEventTP()
	while autoEventTPEnabled do
		local sorted = {}
		for _, e in ipairs(selectedEvents) do
			if eventData[e] then
				table.insert(sorted, eventData[e])
			end
		end
		table.sort(sorted, function(a, b) return a.Priority < b.Priority end)

		for _, config in ipairs(sorted) do
			local foundTarget, foundPos = nil, nil

			if config.TargetName == "Model" then
				local menuRings = Workspace:FindFirstChild("!!! MENU RINGS")
				if menuRings then
					for _, props in ipairs(menuRings:GetChildren()) do
						if props.Name == "Props" then
							local model = props:FindFirstChild("Model")
							if model and model.PrimaryPart then
								for _, loc in ipairs(config.Locations) do
									if (model.PrimaryPart.Position - loc).Magnitude <= megCheckRadius then
										foundTarget = model
										foundPos = model.PrimaryPart.Position
										break
									end
								end
							end
						end
						if foundTarget then break end
					end
				end
			else
				for _, loc in ipairs(config.Locations) do
					for _, d in ipairs(Workspace:GetDescendants()) do
						if d.Name == config.TargetName then
							local pos = d:IsA("BasePart") and d.Position or (d.PrimaryPart and d.PrimaryPart.Position)
							if pos and (pos - loc).Magnitude <= megCheckRadius then
								foundTarget = d
								foundPos = pos
								break
							end
						end
					end
					if foundTarget then break end
				end
			end

			if foundTarget and foundPos then
				createAndTeleportToPlatform(foundPos, config.PlatformY)
			end
		end
		task.wait(0.05) -- spam speed
	end
	destroyEventPlatform()
end

-- UI Controls (Dropdown + Toggle)
Shop:Dropdown({
	Title = "Select Events",
	Values = eventNames,
	Multi = true,
	AllowNone = true,
	Callback = function(values)
		selectedEvents = values
		print("[EventTP] Selected Events:", table.concat(values, ", "))
	end
})

Shop:Toggle({
	Title = "Auto Event TP",
	Icon = "zap",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		autoEventTPEnabled = state
		if state then
			task.spawn(runMultiEventTP)
		else
		end
	end
})



local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

local Toggle = SettingsTab:Toggle({
    Title = "AntiAFK",
    Desc = "Prevent Roblox from kicking you when idle",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local VirtualUser = game:GetService("VirtualUser")

        if state then
            task.spawn(function()
                while _G.AntiAFK do
                    task.wait(60)
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end
            end)

            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AntiAFK loaded!",
                Text = "Coded By nat.sh",
                Button1 = "Nigger",
                Duration = 5
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AntiAFK Disabled",
                Text = "Stopped AntiAFK",
                Duration = 3
            })
        end
    end
})

local Toggle = SettingsTab:Toggle({
    Title = "Auto Reconnect",
    Desc = "Automatic reconnect if disconnected",
    Icon = false,
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        if state then
            task.spawn(function()
                while _G.AutoReconnect do
                    task.wait(2)

                    local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    if reconnectUI then
                        local prompt = reconnectUI:FindFirstChild("promptOverlay")
                        if prompt then
                            local button = prompt:FindFirstChild("ButtonPrimary")
                            if button and button.Visible then
                                firesignal(button.MouseButton1Click)
                            end
                        end
                    end
                end
            end)
        end
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer.Character
local overhead = Player:WaitForChild("HumanoidRootPart"):WaitForChild("Overhead")

SettingsTab:Section({
    Title = 'Hide Identity Features',
    TextXAlignment = 'Left',
    TextSize = 17,
})

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Overhead = HRP:WaitForChild("Overhead")

local header = Overhead.Content.Header
local levelLabel = Overhead.LevelContainer.Label

-- default text
local defaultHeader = header.Text
local defaultLevel = levelLabel.Text
local customHeader = defaultHeader
local customLevel = defaultLevel
local keepHidden = false
local rgbThread = nil

-- input untuk custom nama
SettingsTab:Input({
    Title = "Hide Name",
    Placeholder = "Input Name",
    Default = defaultHeader,
    Callback = function(value)
        customHeader = value
        if keepHidden then
            header.Text = customHeader
        end
    end
})

-- input untuk custom level
SettingsTab:Input({
    Title = "Hide Level",
    Placeholder = "Input Level",
    Default = defaultLevel,
    Callback = function(value)
        customLevel = value
        if keepHidden then
            levelLabel.Text = customLevel
        end
    end
})

-- toggle RGB effect
SettingsTab:Toggle({
    Title = "Hide Identity",
    Default = false,
    Callback = function(state)
        keepHidden = state

        if state then
            -- ubah nama & level ke custom
            header.Text = customHeader
            levelLabel.Text = customLevel

            -- mulai efek RGB kelap-kelip
            if rgbThread then
                task.cancel(rgbThread)
            end

            rgbThread = task.spawn(function()
                local hue = 0
                while keepHidden do
                    hue = (hue + 0.005) % 1
                    local color = Color3.fromHSV(hue, 1, 1)
                    pcall(function()
                        header.TextColor3 = color
                        levelLabel.TextColor3 = color
                    end)
                    task.wait(0.03) -- semakin kecil semakin cepat
                end
            end)
        else
            -- matikan RGB & balikin ke warna default
            if rgbThread then
                task.cancel(rgbThread)
                rgbThread = nil
            end
            header.Text = defaultHeader
            levelLabel.Text = defaultLevel
            header.TextColor3 = Color3.fromRGB(255, 255, 255)
            levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
})


game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
    local hrp = newChar:WaitForChild("HumanoidRootPart")
    local overhead = hrp:WaitForChild("Overhead")
    local header = overhead.Content.Header
    local levelLabel = overhead.LevelContainer.Label
    if keepHidden then
        header.Text = customHeader
        levelLabel.Text = customLevel
    end
end)

SettingsTab:Section({ 
    Title = "Server",
    TextXAlignment = "Left",
    TextSize = 17,
})

SettingsTab:Button({
    Title = "Rejoin Server",
    Desc = "Reconnect to current server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

SettingsTab:Button({
    Title = "Server Hop",
    Desc = "Switch to another server",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        
        local function GetServers()
            local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"
            local response = HttpService:JSONDecode(game:HttpGet(url))
            return response.data
        end

        local function FindBestServer(servers)
            for _, server in ipairs(servers) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    return server.id
                end
            end
            return nil
        end

        local servers = GetServers()
        local serverId = FindBestServer(servers)

        if serverId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, game.Players.LocalPlayer)
        else
            warn("⚠️ No suitable server found!")
        end
    end
})

-- Pastikan WindUI sudah diload
-- local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

-- Modules Roblox
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local REFishCaught = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishCaught"]

-- 🧭 Buat tab WindUI
local Exclusive = Window:Tab({
    Title = "Exclusive",
    Icon = "star",
})

-- 🌐 Variabel global
_G.Wurl = _G.Wurl or ""
_G.WebhookEnabled = _G.WebhookEnabled or false

-- 🔗 HTTP Request
local req = (syn and syn.request) or (http and http.request) or http_request or request

local function isValidWebhookURL(url)
    return string.find(url, "discord%.com") and string.find(url, "webhook")
end

-- 🎣 Fungsi kirim webhook
local function sendFishWebhook(fishName, weight, imageUrl, rarity)
    if not _G.WebhookEnabled or _G.Wurl == "" then return end
    if not isValidWebhookURL(_G.Wurl) then
        warn("❌ Webhook tidak valid atau kosong")
        return
    end

    local embed = {
        title = "🎣 Ikan Tertangkap Anjay!",
        color = 0x8e44ad, -- warna ungu khas VoraHub
        fields = {
            { name = "🐟 Nama Ikan", value = "**" .. tostring(fishName) .. "**", inline = true },
            { name = "⚖️ Berat", value = tostring(weight) .. " kg", inline = true },
            { name = "🌈 Rarity", value = tostring(rarity), inline = true },
            { name = "👤 Pemancing", value = player.Name, inline = false }
        },
        thumbnail = { url = imageUrl or "https://cdn.discordapp.com/attachments/1430527420468953159/1434772063964631070/Screenshot_20251103-110106.jpg" },
        footer = { text = "VoraHub • " .. os.date("%A, %X") }
    }

    local data = {
        username = "🎣 VoraHub Webhook",
        avatar_url = "https://cdn.discordapp.com/attachments/1430527420468953159/1434772063964631070/Screenshot_20251103-110106.jpg",
        embeds = { embed }
    }

    local success, result = pcall(function()
        return req({
            Url = _G.Wurl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data)
        })
    end)

    if success then
        print(string.format("✅ [%s] %s (%.2fkg) terkirim ke webhook", rarity, fishName, weight))
    else
        warn("⚠️ Gagal kirim webhook:", result)
    end
end

-- 🧠 Anti-spam supaya 1 ikan = 1 notifikasi
local lastFish, lastTime = nil, 0

REFishCaught.OnClientEvent:Connect(function(fishName, fishData)
    if not fishName then return end

    local itemData = nil
    if typeof(fishData) == "table" and fishData.Id then
        itemData = ItemUtility:GetItemData(fishData.Id)
    end

    local displayName = (itemData and itemData.Name) or tostring(fishName)
    local fishImage = (itemData and itemData.Image)
        or "https://cdn.discordapp.com/attachments/1430527420468953159/1434772063964631070/Screenshot_20251103-110106.jpg"
    local weight = 0
    local rarity = "Unknown"

    if typeof(fishData) == "table" then
        weight = tonumber(string.format("%.2f", fishData.Weight or 0)) or 0
    end

    if itemData and itemData.Data and itemData.Data.Tier then
        local tier = itemData.Data.Tier
        if tier == 1 then rarity = "Common"
        elseif tier == 2 then rarity = "Uncommon"
        elseif tier == 3 then rarity = "Rare"
        elseif tier == 4 then rarity = "Epic"
        elseif tier == 5 then rarity = "Legend"
        elseif tier == 6 then rarity = "Mythic"
        elseif tier == 7 then rarity = "Secret" end
    end

    local currentTime = tick()
    if lastFish == displayName and (currentTime - lastTime) < 1.5 then
        return
    end
    lastFish = displayName
    lastTime = currentTime

    sendFishWebhook(displayName, weight, fishImage, rarity)
end)

-- ⚙️ WindUI Input & Toggle
Exclusive:Input({
    Title = "Webhook URL",
    Value = _G.Wurl,
    InputIcon = "link",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(url)
        _G.Wurl = url
        if url == "" then
            print("❌ Webhook kosong")
        else
            print("✅ Webhook diatur ke:", url)
        end
    end
})

Exclusive:Toggle({
    Title = "Aktifkan Webhook",
    Value = _G.WebhookEnabled,
    Callback = function(state)
        _G.WebhookEnabled = state
        if state then
            print("✅ Webhook aktif untuk semua ikan (Tier 1–7)")
        else
            print("⛔ Webhook dimatikan")
        end
    end
})

local PremiumSection = Exclusive:Section({
    Title = "Premium",
    TextXAlignment = "Left",
    TextSize = 17,
})

Exclusive:Toggle({
    Title = "Remove Fishing Animations",
    Default = false,
    Callback = function(value)
        _G.BlockFishingAnimations = value
        
        if value then
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local AnimationController = require(ReplicatedStorage.Controllers.AnimationController)
            AnimationController.PlayAnimation = function() return nil end
            AnimationController.StopAnimation = function() end

            local spr = require(ReplicatedStorage.Packages.spr)
            spr.target = function() return {} end
            spr.stop = function() end

            local FishingController = require(ReplicatedStorage.Controllers.FishingController)
            local originalInit = FishingController.Init or function() end
            local originalStart = FishingController.Start or function() end

            FishingController.Init = function(self)
                originalInit(self)
            end

            FishingController.Start = function(self)
                originalStart(self)
            end
        end
    end
})

local freezeConnection
local originalCFrame

Exclusive:Toggle({
    Title = "Freeze Character",
    Default = false,
    Callback = function(state)
        _G.FreezeCharacter = state
        if state then
            local character = game.Players.LocalPlayer.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    originalCFrame = root.CFrame
                    freezeConnection = game:GetService("RunService").Heartbeat:Connect(function()
                        if _G.FreezeCharacter and root then
                            root.CFrame = originalCFrame
                        end
                    end)
                end
            end
        else
            if freezeConnection then
                freezeConnection:Disconnect()
                freezeConnection = nil
            end
        end
    end
})

Exclusive:Toggle({
    Title = "Disable Notification",
    Default = true,
    Callback = function(state)
        disableNotifs = state
        if state then
            for _, ev in ipairs({
                Net["RE/ObtainedNewFishNotification"],
                Net["RE/TextNotification"],
                Net["RE/ClaimNotification"]
            }) do
                if ev and ev.OnClientEvent then
                    for _, conn in ipairs(getconnections(ev.OnClientEvent)) do
                        conn:Disconnect()
                    end
                end
            end
        end
    end
})

Exclusive:Section({
    Title = "Blantant",
})

Exclusive:Toggle({ 
    Title = "Blantant",
    Value = Config.AutoFishInstant,
    Callback = function(state)
    if state then
        startblantant()
    else
        blantantruning = false
        stopblantant()
    end
    end
})

Exclusive:Toggle({ 
    Title = "Blantant Random",
    Value = Config.AutoFishInstantRandom,
    Callback = function(state)
    if state then
        startblantantrandom()
    else
        blantantrandomruning = false
        stopblantantrandom()
    end
    end
})

Exclusive:Input({ 
    Title = "Cancel Delay",
    Placeholder = "Contoh: 1.7",
    Default = tostring(Config.InstantCancelDelay),
    Callback = function(value)
        local numValue = tonumber(value) 
        if numValue and numValue > 0 then
            Config.InstantCancelDelay = numValue
        end
    end
})

Exclusive:Input({ 
    Title = "Complete Delay",
    Placeholder = "Contoh: 1.4",
    Default = tostring(Config.InstantCompleteDelay),
    Callback = function(value)
        local numValue = tonumber(value) 
        if numValue and numValue > 0 then
            Config.InstantCompleteDelay = numValue
        end
    end
})

local CFG = Window:Tab({
    Title = "Config",
    Icon = "file",
})

CFG:Section({
    Title = 'Config Features',
    TextXAlignment = 'Left',
    TextSize = 17,
})

local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("fishit")

local configElems = {
    AA = A,
    BB = B,
    CC = C,
    DD = D,
    EE = E,
    FF = F,
    GG = G,
    HH = H,
    II = I,
    JJ = J,
    KK = K,
    LL = L,
    MM = MU,
    NN = N,
    OO = O,
    pp = p,
    QQ = Q,
    RR = R,
    SS = S,
    TT = TU,
    UU = U,
    VV = V,
    WW = WU,
}
for n, e in pairs(configElems) do myConfig:Register(n, e) end

function myConfig:ApplyAll(skip)
    for _, e in pairs(configElems) do
        if e and e.Value ~= nil and e.Callback then
            e
                .Callback(e.Value, skip)
        end
    end
end

local autoFile = "workspace/WindUI/" .. Window.Folder .. "/config/fishit/autoload.txt"
function configNotify(ok, successMsg, failMsg)
    notify(ok and successMsg or failMsg, 3)
end

CFG:Button({
    Title = "Save Config",
    Callback = function()
        configNotify(myConfig:Save(),
            "Config Saved\nYour config got saved now!", "Save Failed\nTry again.")
    end
})
CFG:Button({
    Title = "Load Config",
    Callback = function()
        local ok = myConfig:Load()
        if ok then myConfig:ApplyAll() end
        configNotify(ok, "Config Loaded\nConfig has been applied back...", "Load Failed\nMissing file.")
    end
})
CFG:Button({
    Title = "Set Auto Load",
    Callback = function()
        writefile(autoFile, "fishit")
        notify("Auto Load Set\nConfig will auto load next time.", 3)
    end
})
CFG:Button({
    Title = "Reset Auto Load",
    Callback = function()
        if isfile(autoFile) then delfile(autoFile) end
        notify("Auto Load Reset\nLoad manually if needed.", 3)
    end
})

spawn( LPH_NO_VIRTUALIZE( function()
    if isfile(autoFile) and readfile(autoFile) == "fishit" then
        local ok = myConfig:Load()
        if ok then myConfig:ApplyAll(true) end
        configNotify(ok, "Auto Load Success\nConfig has been applied back...", "Auto Load Failed\nMissing file.")
    end
end))

--// ANTI IDLE
local GC = getconnections or get_signal_cons
if GC then
    for _, v in pairs(GC(player.Idled)) do
        if v.Disable then
            v:Disable()
        elseif v.Disconnect then
            v:Disconnect()
        end
    end
else
    local VirtualUser = cloneref and cloneref(game:GetService("VirtualUser")) or game:GetService("VirtualUser")
    player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
