-- 1. Tải thư viện Orion UI
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- 2. Tạo cửa sổ chính
local Window = OrionLib:MakeWindow({
    Name = "KHANGMODS",
    HidePremium = false,
    SaveConfig = false, -- Tắt lưu config cho đơn giản
    ConfigFolder = "HitboxTest"
})

-- 3. Tạo Tab
local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 4. Tạo thanh kéo (Slider) để chỉnh Hitbox
Tab:AddSlider({
    Name = "Hitbox",
    Min = 1,          -- Nhỏ nhất là 10
    Max = 50,         -- Lớn nhất là 200
    Default = 1,      -- Lúc mới mở thì để 50
    Color = Color3.fromRGB(225, 225, 225), -- Màu xanh lá
    Increment = 1,     -- Mỗi lần kéo nhảy 5 đơn vị
    ValueName = "Studs",
    Callback = function(Value)
        -- Lấy nhân vật của mình trực tiếp (không cần đợi)
        local char = game.Players.LocalPlayer.Character
        if not char then return end
        
        -- Tìm cục Hitbox
        local hitbox = char:FindFirstChild("Hitbox")
        if hitbox then
            -- 1. Đổi kích thước
            hitbox.Size = Vector3.new(Value, Value, Value)
            
            -- 2. Tạo khung xanh (nếu chưa có)
            local box = hitbox:FindFirstChild("HitboxOutline")
            if not box then
                box = Instance.new("SelectionBox")
                box.Name = "HitboxOutline"
                box.Adornee = hitbox
                box.Color3 = Color3.fromRGB(255, 192, 203)
                box.LineThickness = 0.0.1 -- Độ dày mỏng như bạn muốn
                box.Transparency = 0
                box.Parent = hitbox
            end
        end
    end    
})
