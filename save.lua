-- Save System for Settings
-- Simple and easy to use

local Save = {}
local HttpService = game:GetService("HttpService")

-- Khởi tạo save system với tên file tùy chỉnh
function Save.new(fileName)
    local self = {}
    self.FileName = fileName or "settings.json"
    self.Settings = {}
    
    -- Ghi settings vào file
    function self:Write(data)
        local success, err = pcall(function()
            local json = HttpService:JSONEncode(data)
            writefile(self.FileName, json)
        end)
        
        if success then
            self.Settings = data
            return true
        else
            warn("Failed to write settings:", err)
            return false
        end
    end
    
    -- Đọc settings từ file
    function self:Read()
        local success, result = pcall(function()
            if isfile(self.FileName) then
                local contents = readfile(self.FileName)
                return HttpService:JSONDecode(contents)
            else
                return nil
            end
        end)
        
        if success and result then
            self.Settings = result
            return result
        else
            return {}
        end
    end
    
    -- Lấy dữ liệu dưới dạng text/JSON string
    function self:Text()
        local success, result = pcall(function()
            if isfile(self.FileName) then
                return readfile(self.FileName)
            else
                return ""
            end
        end)
        
        if success then
            return result
        else
            return ""
        end
    end
    
    -- Export settings thành JSON string
    function self:Export(data)
        data = data or self.Settings
        local success, result = pcall(function()
            return HttpService:JSONEncode(data)
        end)
        
        if success then
            return result
        else
            return ""
        end
    end
    
    -- Import settings từ JSON string
    function self:Import(jsonString)
        local success, result = pcall(function()
            return HttpService:JSONDecode(jsonString)
        end)
        
        if success and result then
            self.Settings = result
            self:Write(result)
            return true, result
        else
            warn("Failed to import settings")
            return false, {}
        end
    end
    
    -- Xóa file
    function self:Delete()
        local success = pcall(function()
            if isfile(self.FileName) then
                delfile(self.FileName)
            end
        end)
        
        if success then
            self.Settings = {}
            return true
        else
            return false
        end
    end
    
    -- Kiểm tra file có tồn tại không
    function self:Exists()
        return isfile(self.FileName)
    end
    
    -- Lấy tên file
    function self:GetFileName()
        return self.FileName
    end
    
    -- Đổi tên file
    function self:SetFileName(newFileName)
        self.FileName = newFileName
    end
    
    -- Tạo backup
    function self:Backup(backupName)
        backupName = backupName or self.FileName:gsub(".json", "_backup.json")
        local success = pcall(function()
            if isfile(self.FileName) then
                local contents = readfile(self.FileName)
                writefile(backupName, contents)
            end
        end)
        
        return success
    end
    
    -- Khôi phục từ backup
    function self:Restore(backupName)
        backupName = backupName or self.FileName:gsub(".json", "_backup.json")
        local success, result = pcall(function()
            if isfile(backupName) then
                local contents = readfile(backupName)
                writefile(self.FileName, contents)
                return HttpService:JSONDecode(contents)
            end
        end)
        
        if success and result then
            self.Settings = result
            return true, result
        else
            return false, {}
        end
    end
    
    return self
end

-- Tạo save instance mặc định
function Save:Init(fileName)
    return Save.new(fileName)
end

return Save
