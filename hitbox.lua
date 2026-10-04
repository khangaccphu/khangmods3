local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "KHANGMODS",
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by tiktok: @bokhangtrn29",
   Theme = "Default",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

local Tab = Window:CreateTab("", 4483362458)

-- ==========================================
-- CHUẨN BỊ CODE HITBOX (Để bên ngoài Callback)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local HITBOX_SIZE   = Vector3.new(10, 10, 10)
local HITBOX_COLOUR = Color3.fromRGB(12, 243, 20)
local DEFAULT_SIZE  = Vector3.new(2, 2, 1)
local DEFAULT_COLOR = Color3.fromRGB(255, 255, 255)

-- Mặc định ban đầu là Tắt
getgenv().HBE = false

-- Hàm tìm cha của nhân vật (giữ nguyên của bạn)
local function GetCharParent()
      local CharParent
      repeat wait() until LocalPlayer.Character
      for _, char in pairs(Workspace:GetDescendants()) do
           if string.find(char.Name, LocalPlayer.Name) and char:FindFirstChild("Humanoid") then
                 charParent = char.Parent 
                 break
            end
        end
         return CharParent
end

local CHAR_PARENT = GetCharParent()

-- Vòng lặp chính: Chạy 1 lần duy nhất, kiểm tra công tắc HBE
RunService.RenderStepped:Connect(function()
    if not getgenv().HBE then return end -- Nếu tắt thì không làm gì
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = CHAR_PARENT:FindFirstChild(player.Name)
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                if hrp.Size ~= HITBOX_SIZE or hrp.Color ~= HITBOX_COLOUR then
                    hrp.Size = HITBOX_SIZE
                    hrp.Color = HITBOX_COLOUR
                    hrp.CanCollide = false
                    hrp.Transparency = 0.5
                end
            end
        end
    end
end)


local Toggle = Tab:CreateToggle({
   Name = "HITBOX PLAYER",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
       
       if Value == true then
           -- PHẦN BẬT
           getgenv().HBE = true
           print("Đã BẬT Hitbox!")
           
           -- Chạy ngay 1 lần cho những người đang có mặt
           for _, player in ipairs(Players:GetPlayers()) do
               if player ~= LocalPlayer and player.Character then
                   local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                   if hrp then
                       hrp.Size = HITBOX_SIZE
                       hrp.Color = HITBOX_COLOUR
                       hrp.CanCollide = false
                       hrp.Transparency = 0.5
                   end
               end
           end
           
       else
        
           getgenv().HBE = false
           print("Đã TẮT Hitbox!")
           
        
           for _, player in ipairs(Players:GetPlayers()) do
               if player ~= LocalPlayer and player.Character then
                   local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                   if hrp then
                       hrp.Size = DEFAULT_SIZE
                       hrp.Color = DEFAULT_COLOR
                       hrp.CanCollide = true
                       hrp.Transparency = 1
                   end
               end
           end
       end
       
   end,
})
