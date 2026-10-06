-- ==========================================
-- AUTO FARM BANDIT - BLOX FRUITS (FULL SCRIPT)
-- Sử dụng RemoteEvent, bay cao 10 studs, attackId tăng dần
-- ==========================================

-- ==========================================
-- 1. CẤU HÌNH (Bạn có thể chỉnh sửa các thông số ở đây)
-- ==========================================
local CONFIG = {
    Y_OFFSET = 10,           -- Độ cao bay lên so với mặt đất (studs)
    ATTACK_DISTANCE = 60,    -- Tầm tấn công (studs)
    ATTACK_COOLDOWN = 0.5,   -- Thời gian chờ giữa các đòn đánh (giây)
    ENEMY_NAME = "Bandit",   -- Tên quái vật cần farm
    AUTO_RESPAWN_DELAY = 2,  -- Thời gian chờ sau khi hồi sinh (giây)
}

-- ==========================================
-- 2. SERVICES & BIẾN TOÀN CỤC
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local lastAttack = 0
local isFarming = true
local bodyPosition = nil

-- Bộ đếm attackId, bắt đầu từ một số ngẫu nhiên để tránh trùng lặp
local attackIdCounter = math.random(1000, 9999)

-- Lấy thư mục chứa RemoteEvent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")

-- ==========================================
-- 3. HÀM TÌM QUÁI GẦN NHẤT
-- ==========================================
local function GetClosestEnemy()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local hrp = char.HumanoidRootPart
    local closest = nil
    local shortest = math.huge
    
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end
    
    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        if enemy.Name == CONFIG.ENEMY_NAME then
            local eHrp = enemy:FindFirstChild("HumanoidRootPart")
            local eHum = enemy:FindFirstChild("Humanoid")
            if eHrp and eHum and eHum.Health > 0 then
                local d = (hrp.Position - eHrp.Position).Magnitude
                if d < shortest then
                    shortest = d
                    closest = eHrp
                end
            end
        end
    end
    return closest, shortest
end

-- ==========================================
-- 4. HÀM TẤN CÔNG BẰNG REMOTE EVENT (attackId tăng dần)
-- ==========================================
local function Attack(target)
    pcall(function()
        -- 1. Gửi lệnh đăng ký đòn đánh
        local registerAttack = Net:FindFirstChild("RE/RegisterAttack")
        if registerAttack then
            registerAttack:FireServer(0.1) -- Tốc độ đánh
        end
        
        -- 2. Gửi lệnh đánh trúng với attackId tăng dần
        local registerHit = Net:FindFirstChild("RE/RegisterHit")
        if registerHit and target then
            local targetPart = target:FindFirstChild("Head") or target
            if targetPart then
                -- Tăng bộ đếm lên 1 đơn vị
                attackIdCounter = attackIdCounter + 1
                local attackId = tostring(attackIdCounter)
                
                -- Cấu trúc tham số được khuyến nghị
                local argsHit = {targetPart, {}, [4] = attackId}
                registerHit:FireServer(unpack(argsHit))
            end
        end
    end)
end

-- ==========================================
-- 5. VÒNG LẶP CHÍNH (Xử lý bay và tấn công)
-- ==========================================
RunService.Heartbeat:Connect(function()
    if not isFarming then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Tạo BodyPosition để bay (nếu chưa có)
    if not bodyPosition or not bodyPosition.Parent then
        bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Name = "FarmBP"
        bodyPosition.MaxForce = Vector3.new(50000, 50000, 50000)
        bodyPosition.P = 8000
        bodyPosition.D = 800
        bodyPosition.Parent = hrp
    end
    
    -- Tìm quái
    local target, distance = GetClosestEnemy()
    
    if target then
        -- Bay đến quái (cao hơn đầu quái Y_OFFSET studs)
        local targetPos = Vector3.new(
            target.Position.X,
            target.Position.Y + CONFIG.Y_OFFSET,
            target.Position.Z
        )
        bodyPosition.Position = targetPos
        
        -- Tấn công nếu đủ gần
        if distance <= CONFIG.ATTACK_DISTANCE then
            if tick() - lastAttack >= CONFIG.ATTACK_COOLDOWN then
                lastAttack = tick()
                Attack(target)
            end
        end
    else
        -- Không có quái thì đứng yên tại chỗ
        bodyPosition.Position = hrp.Position
    end
end)

-- ==========================================
-- 6. XỬ LÝ KHI NHÂN VẬT HỒI SINH (RESPAWN)
-- ==========================================
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(CONFIG.AUTO_RESPAWN_DELAY)
    bodyPosition = nil
    print("Nhân vật đã hồi sinh, tiếp tục farm...")
end)

-- ==========================================
-- 7. PHÍM K BẬT/TẮT SCRIPT
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        isFarming = not isFarming
        print("=== Auto Farm: " .. (isFarming and "BẬT" or "TẮT") .. " ===")
        
        if not isFarming then
            if bodyPosition and bodyPosition.Parent then
                bodyPosition:Destroy()
                bodyPosition = nil
            end
        end
    end
end)

-- ==========================================
-- 8. THÔNG BÁO KHỞI ĐỘNG
-- ==========================================
print("╔══════════════════════════════════════╗")
print("║   AUTO FARM BANDIT (FULL) ĐÃ CHẠY!   ║")
print("╠══════════════════════════════════════╣")
print("║ - Quái: " .. CONFIG.ENEMY_NAME)
print("║ - Bay cao: " .. CONFIG.Y_OFFSET .. " studs")
print("║ - Tầm đánh: " .. CONFIG.ATTACK_DISTANCE .. " studs")
print("║ - Tốc độ đấm: " .. CONFIG.ATTACK_COOLDOWN .. " giây")
print("║ - AttackId: Bắt đầu từ " .. attackIdCounter .. " và tăng dần")
print("║ - Bấm phím K để BẬT/TẮT              ║")
print("╚══════════════════════════════════════╝")
