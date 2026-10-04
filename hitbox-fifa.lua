local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "KHANGMODS",
   LoadingTitle = "Đang tải...",
   LoadingSubtitle = "Chờ xíu nhé",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

local Tab = Window:CreateTab("Main", 4483362458)

Tab:CreateSlider({
   Name = "Hitbox",
   Range = {5, 60},
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 50,
   Flag = "HitboxSize",
   Callback = function(Value)
       -- 1. Dán tờ giấy ghi chú (SetAttribute)
       game.Players.LocalPlayer.Character:SetAttribute("Hitbox", Value)
       
       -- 2. Sửa luôn cục Part thật (vì game không tự đọc tờ giấy)
       local hitbox = game.Players.LocalPlayer.Character:FindFirstChild("Hitbox")
       if hitbox then
           hitbox.Size = Vector3.new(Value, Value, Value)
           
           -- Tạo khung xanh
           local box = hitbox:FindFirstChild("HitboxOutline")
           if not box then
               box = Instance.new("SelectionBox")
               box.Name = "HitboxOutline"
               box.Adornee = hitbox
               box.Color3 = Color3.fromRGB(12, 243, 20)
               box.LineThickness = 0.1 
               box.Transparency = 0
               box.Parent = hitbox
           end
       end
   end,
})
