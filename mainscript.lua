local fileName = "TableLog_" .. math.random(1000, 9999) .. ".txt"
writefile(fileName, "--- DETAIL ISI TABEL FIRESERVER ---\n\n")

-- Fungsi pembantu untuk membaca isi tabel secara mendalam (recursive)
local function dumpTable(tbl, indent)
    indent = indent or ""
    local result = ""
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            result = result .. indent .. tostring(k) .. " = Table: \n"
            result = result .. dumpTable(v, indent .. "  ")
        else
            result = result .. indent .. tostring(k) .. " = " .. tostring(v) .. " (" .. type(v) .. ")\n"
        end
    end
    return result
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" and self.Name == "Main" then
        local textEntry = string.format("[FireServer] Remote: %s\n", tostring(self.Name))
        
        for i, v in ipairs(args) do
            if type(v) == "table" then
                textEntry = textEntry .. string.format("   Arg %d (Table):\n", i)
                textEntry = textEntry .. dumpTable(v, "      ")
            else
                textEntry = textEntry .. string.format("   Arg %d: %s (%s)\n", i, tostring(v), type(v))
            end
        end
        textEntry = textEntry + "----------------------------------------\n"
        
        appendfile(fileName, textEntry)
    end
    
    return oldNamecall(self, ...)
end)

print("Logger tabel aktif! Cek file: " .. fileName)
