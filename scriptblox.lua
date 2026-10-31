getgenv().Configs = {
    ["Key"] = ""; -- Để trống để dùng key đã lưu hoặc nhập qua UI
    ["Quest"] = {
        ["Evo Race V1"] = true;
        ["Evo Race V2"] = true;
        ["RGB Haki"] = true;
        ["Pull Lerver"] = true;
    };
    Sword = {
        "Dual-Headed Blade";
        "Smoke Admiral";
        "Wardens Sword";
        "Cutlass";
        "Katana";
        "Dual Katana";
        "Triple Katana";
        "Iron Mace";
        "Saber";
        "Pole (1st Form)";
        "Gravity Blade";
        "Longsword";
        "Rengoku";
        "Midnight Blade";
        "Soul Cane";
        "Bisento";
        "Yama";
        "Tushita";
        "Cursed Dual Katana";
    };
    Gun = {
        "Skull Guitar";
        "Kabucha";
        "Venom Bow";
        "Musket";
        "Flintlock";
        "Refined Slingshot"; 
        "Magma Blaster";
        "Dual Flintlock";
        "Cannon";
        "Bizarre Revolver";
        "Bazooka";
    };
    ["Auto Active Race V4"] = true;
    ["FPS Limit"] = 50;
    ["Boost FPS"] = false;
    ["Hop Fruits"] = true; 
    ["Hop Near"] = {Enabled = false; Distance = 500;};
    ["Webhook"] = {
        ["URL"] = ""; 
        ["Interval"] = 10;
    };
};
loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/kaitun.lua"))()
