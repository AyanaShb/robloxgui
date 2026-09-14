-- Salin dan jalankan skrip ini lewat Executor Anda untuk membelokkan peluru secara otomatis
local ReplicatedStorage = game:GetService("ReplicatedStorage")

task.spawn(function()
    pcall(function()
        local ugcFolder = ReplicatedStorage:FindFirstChild("Ugc") or ReplicatedStorage
        local projectileManagerModule = ugcFolder:FindFirstChild("ProjectileManager", true)
        
        if projectileManagerModule then
            local ProjectileManager = require(projectileManagerModule)
            if ProjectileManager and rawget(ProjectileManager, "CreateProjectile") then
                local oldCreate = ProjectileManager.CreateProjectile
                ProjectileManager.CreateProjectile = function(self, p41, ...)
                    if p41 and p41.direction and typeof(p41.direction) == "Vector3" then
                        -- Membelokkan arah vektor peluru ke kanan
                        local rotCFrame = CFrame.new(Vector3.zero, p41.direction) * CFrame.Angles(0, math.rad(-30), 0)
                        p41.direction = rotCFrame.LookVector
                    end
                    return oldCreate(self, p41, ...)
                end
                print("Auto-hook peluru belok ke kanan berhasil!")
            end
        end
    end)
end)
