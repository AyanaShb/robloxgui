local content = "-- GC DUMP --\n"
pcall(function()
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" then
            pcall(function()
                for k, _ in pairs(v) do
                    if tostring(k):lower():find("ammo") or tostring(k):lower():find("speed") or tostring(k):lower():find("damage") then
                        content = content .. "Key: " .. tostring(k) .. "\n"
                    end
                end
            end)
        end
    end
end)
writefile("GCDump.txt", content)
print("Selesai scan GC!")
