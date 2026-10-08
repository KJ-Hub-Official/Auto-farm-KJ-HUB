-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("--------------------------------------------------")
print("⏳ [KJ HUB] Starting Initialization...")

-- Screen Notification Helper
local function ShowNotification(text, duration)
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "KJ_Notify"
        sg.ResetOnSpawn = false
        sg.Parent = PlayerGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 260, 0, 45)
        frame.Position = UDim2.new(0.5, -130, 0.1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(10, 15, 20)
        frame.BorderSizePixel = 0
        frame.Parent = sg

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 255, 128)
        stroke.Thickness = 1.5
        stroke.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(240, 255, 240)
        label.TextSize = 13
        label.Font = Enum.Font.SourceSansBold
        label.Text = text
        label.TextWrapped = true
        label.Parent = frame

        task.delay(duration or 4, function()
            sg:Destroy()
        end)
    end)
end

ShowNotification("⏳ [KJ HUB] Script Loaded!", 3)

-- Configuration & Theme
local PrimaryColor = Color3.fromRGB(0, 255, 128)
local DarkBackground = Color3.fromRGB(10, 15, 20)
local TextWhite = Color3.fromRGB(240, 255, 240)
local TextAccent = Color3.fromRGB(50, 255, 150)

-- Translation Dictionary
local Translations = {
    ["[Pp][Rr][Oo][Dd][Ii][Gg][Yy]%s*[Hh][Uu][Bb]"] = "KJ HUB",
    ["[Pp][Rr][Oo][Dd][Ii][Gg][Yy]"] = "KJ",
    ["PRODIGY HUB"] = "KJ HUB",
    ["Prodigy Hub"] = "KJ Hub",
    ["prodigy hub"] = "kj hub",
    ["prodigy"] = "kj",
    ["PRODIGY"] = "KJ",
    ["LEVON HUB"] = "KJ HUB",
    ["Levon Hub"] = "KJ Hub",
    ["levon hub"] = "kj hub",
    ["levon"] = "kj",
    ["LEVON"] = "KJ"
}

local HandledScreenGuis = {}

local function ProcessElement(element)
    if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
        local text = element.Text
        if type(text) == "string" and text ~= "" then
            for pattern, replacement in pairs(Translations) do
                text = string.gsub(text, pattern, replacement)
            end
            element.Text = text
        end
    end
end

-- Process current PlayerGui elements
task.spawn(function()
    print("🔍 [KJ HUB] Scanning PlayerGui...")
    local count = 0
    for _, descendant in ipairs(PlayerGui:GetDescendants()) do
        ProcessElement(descendant)
        count = count + 1
    end
    print("✅ [KJ HUB] Processed " .. tostring(count) .. " elements in PlayerGui.")

    PlayerGui.DescendantAdded:Connect(function(descendant)
        pcall(function() ProcessElement(descendant) end)
    end)
end)

-------------------------------------------------------------------
-- PAYLOAD EXECUTION WITH DETAILED LOGGING
-------------------------------------------------------------------
local KJ_GitHub_Payload = "https://raw.githubusercontent.com/KJ-Hub-Official/KJ-ANTI-CHASE/main/script.lua"

print("🔄 [KJ HUB] Attempting HttpGet to GitHub...")

task.spawn(function()
    local getSuccess, result = pcall(function()
        return game:HttpGet(KJ_GitHub_Payload)
    end)

    if not getSuccess then
        warn("❌ [KJ HUB] HttpGet Failed! Error Details: " .. tostring(result))
        ShowNotification("❌ HttpGet Failed! Check console (F9)", 5)
        return
    end

    if type(result) ~= "string" or #result == 0 then
        warn("❌ [KJ HUB] Payload fetched, but content was EMPTY.")
        ShowNotification("❌ Payload Empty!", 4)
        return
    end

    print("✅ [KJ HUB] Raw Payload Fetched (" .. tostring(#result) .. " bytes). Compiling loadstring...")

    local fn, parseErr = loadstring(result)
    if not fn then
        warn("❌ [KJ HUB] Syntax Error in Remote Payload: " .. tostring(parseErr))
        ShowNotification("❌ Remote Script Syntax Error!", 5)
        return
    end

    print("🚀 [KJ HUB] Executing Remote Payload...")
    local execSuccess, execErr = pcall(fn)

    if execSuccess then
        print("🎉 [KJ HUB] Payload executed successfully!")
        ShowNotification("✅ [KJ HUB] Anti-Chase Loaded!", 4)
    else
        warn("❌ [KJ HUB] Runtime Error inside Payload: " .. tostring(execErr))
        ShowNotification("❌ Payload Runtime Error! Check F9", 5)
    end
end)

print("--------------------------------------------------")
