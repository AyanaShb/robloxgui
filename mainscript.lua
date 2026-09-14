local content = "-- D3D DUMP RESULT --\n\n"

local function dumpFolder(parentObj, indent)
    indent = indent or ""
    pcall(function()
        for _, v in ipairs(parentObj:GetChildren()) do
            content = content .. indent .. v.Name .. " [" .. v.ClassName .. "]\n"
            if #v:GetChildren() > 0 and indent:len() < 15 then
                dumpFolder(v, indent .. "  ")
            end
        end
    end)
end

content = content .. "=== REPLICATED STORAGE ===\n"
dumpFolder(ReplicatedStorage, "  ")

content = content .. "\n=== WORKSPACE (OBJECTS) ===\n"
pcall(function()
    for _, v in ipairs(Workspace:GetChildren()) do
        if v ~= Camera and v ~= LocalPlayer.Character then
            content = content .. "  " .. v.Name .. " [" .. v.ClassName .. "]\n"
        end
    end
end)

if writefile then
    pcall(function()
        writefile("DumpResult.txt", content)
    end)
    print("Berhasil! File tersimpan sebagai DumpResult.txt di folder workspace.")
else
    print("Executor tidak support writefile. Cek output di console.")
    print(content)
end
