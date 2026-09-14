local fileName = "HookLog_" .. math.random(1000, 9999) .. ".txt"
local logData = "--- LOG PEMANGGILAN REMOTE/FIRESERVER ---\n\n"

-- Buat file awal agar siap diisi
writefile(fileName, logData)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" then
        local textEntry = string.format("[FireServer] Remote: %s\n", tostring(self.Name))
        
        for i, v in ipairs(args) do
            textEntry = textEntry .. string.format("   Arg %d: %s (%s)\n", i, tostring(v), typeof(v))
        end
        textEntry = textEntry .. "----------------------------------------\n"
        
        -- Tambahkan data secara otomatis ke file txt di folder executor
        appendfile(fileName, textEntry)
    end
    
    return oldNamecall(self, ...)
end)

print("Berhasil! File log tersimpan dengan nama: " .. fileName)
