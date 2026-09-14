-- Script Universal Safe Dumper (Tanpa Require() agar tidak Crash)
local success, result = pcall(function()
    local output = "=== SAFE MAP & SERVICE DUMP ===\n\n"
    
    local function deepScan(parent, depth)
        if depth > 4 then return end -- Batasi kedalaman agar tidak infinite loop
        local successChildren, children = pcall(function()
            return parent:GetChildren()
        end)
        
        if not successChildren or not children then return end

        for _, child in ipairs(children) do
            local indent = string.rep("  ", depth)
            local className = "Unknown"
            pcall(function() className = child.ClassName end)
            
            output ..= string.format("%s- %s [%s]\n", indent, child.Name, className)
            
            -- Jika menemukan Remote atau Folder penting, intip lebih dalam
            if child:IsA("Folder") or child:IsA("Model") or child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or child:IsA("ModuleScript") then
                deepScan(child, depth + 1)
            end
        end
    end

    output ..= "[REPLICATED STORAGE]\n"
    deepScan(game:GetService("ReplicatedStorage"), 1)
    
    output ..= "\n[WORKSPACE TARGET]\n"
    deepScan(workspace, 1)

    return output
end)

if success and result then
    if writefile then
        pcall(function()
            writefile("dump.txt", result)
        end)
    end
    if setclipboard then
        setclipboard(result)
    end
    print("Dump aman selesai! Cek file dump.txt atau clipboard.")
else
    local errText = "Error: " .. tostring(result)
    if setclipboard then setclipboard(errText) end
    warn(errText)
end
