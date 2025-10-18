local XKHub = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui
local screenGui
local activeNotifications = {}
local notificationSpacing = 0.1
local basePosition = 0.025

function XKHub:Initialize()
    playerGui = player:WaitForChild("PlayerGui")
    
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "XKHubNotificationGui"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui
    
    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            for _, notif in ipairs(activeNotifications) do
                if notif and notif.Parent then
                    notif:Destroy()
                end
            end
            activeNotifications = {}
        end)
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

function XKHub:UpdateNotificationPositions()
    for i, notif in ipairs(activeNotifications) do
        if notif and notif.Parent then
            local targetPosition = basePosition + ((i - 1) * notificationSpacing)
            local tween = TweenService:Create(
                notif,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0.5, 0, targetPosition, 0)}
            )
            tween:Play()
        end
    end
end

function XKHub:Notification(title, message, duration)
    duration = duration or 3
    
    if not screenGui or not screenGui.Parent then
        self:Initialize()
    end
    
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "Notification"
    notificationFrame.Size = UDim2.new(0.4, 0, 0.09, 0)
    notificationFrame.Position = UDim2.new(0.5, 0, -0.12, 0)
    notificationFrame.AnchorPoint = Vector2.new(0.5, 0)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ZIndex = 100
    notificationFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notificationFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(125, 85, 255)
    stroke.Thickness = 2
    stroke.Parent = notificationFrame
    
    local iconImage = Instance.new("ImageLabel")
    iconImage.Name = "Icon"
    iconImage.Size = UDim2.new(0, 50, 0, 50)
    iconImage.Position = UDim2.new(0.04, 0, 0.5, 0)
    iconImage.AnchorPoint = Vector2.new(0, 0.5)
    iconImage.BackgroundTransparency = 1
    iconImage.Image = "rbxassetid://97837015726495"
    iconImage.ScaleType = Enum.ScaleType.Fit
    iconImage.ZIndex = 101
    iconImage.Parent = notificationFrame
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Size = UDim2.new(0.75, 0, 0.35, 0)
    titleFrame.Position = UDim2.new(0.18, 0, 0.12, 0)
    titleFrame.BackgroundTransparency = 1
    titleFrame.ZIndex = 101
    titleFrame.Parent = notificationFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "XK Hub"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.RobotoCondensed
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.ZIndex = 102
    titleLabel.Parent = titleFrame
    
    local messageFrame = Instance.new("Frame")
    messageFrame.Name = "MessageFrame"
    messageFrame.Size = UDim2.new(0.75, 0, 0.55, 0)
    messageFrame.Position = UDim2.new(0.18, 0, 0.45, 0)
    messageFrame.BackgroundTransparency = 1
    messageFrame.ZIndex = 101
    messageFrame.Parent = notificationFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, 0, 1, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message or ""
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.TextSize = 15
    messageLabel.TextWrapped = true
    messageLabel.Font = Enum.Font.RobotoCondensed
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.ZIndex = 102
    messageLabel.Parent = messageFrame
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://4590662766"
    sound.Volume = 0.8
    sound.Parent = notificationFrame
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
    
    table.insert(activeNotifications, 1, notificationFrame)
    
    local tweenIn = TweenService:Create(
        notificationFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, 0, basePosition, 0)}
    )
    tweenIn:Play()
    
    tweenIn.Completed:Connect(function()
        self:UpdateNotificationPositions()
    end)
    
    delay(duration, function()
        if not notificationFrame or not notificationFrame.Parent then
            return
        end
        
        local tweenOut = TweenService:Create(
            notificationFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, -0.12, 0)}
        )
        tweenOut:Play()
        
        tweenOut.Completed:Connect(function()
            for i, notif in ipairs(activeNotifications) do
                if notif == notificationFrame then
                    table.remove(activeNotifications, i)
                    break
                end
            end
            
            if notificationFrame and notificationFrame.Parent then
                notificationFrame:Destroy()
            end
            
            self:UpdateNotificationPositions()
        end)
    end)
end

return XKHub