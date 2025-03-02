local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "gui_1"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Create Frame (Left Side)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 400)
Frame.Position = UDim2.new(0, 10, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui

-- Function to create buttons
local function createButton(text, position, callback)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(0, 230, 0, 40)
	Button.Position = position
	Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.Font = Enum.Font.SourceSansBold
	Button.TextSize = 20
	Button.Text = text
	Button.Parent = Frame
	Button.MouseButton1Click:Connect(callback)
	return Button
end

-- Function to create a TextBox
local function createTextBox(placeholder, position)
	local TextBox = Instance.new("TextBox")
	TextBox.Size = UDim2.new(0, 230, 0, 30)
	TextBox.Position = position
	TextBox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.Font = Enum.Font.SourceSans
	TextBox.TextSize = 18
	TextBox.PlaceholderText = placeholder
	TextBox.Parent = Frame
	return TextBox
end

-- Toggle Flying
local isFlying = false
local BodyVelocity = nil
local function toggleFly()
	local humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	if isFlying then
		humanoid.PlatformStand = false
		if BodyVelocity then
			BodyVelocity:Destroy()
			BodyVelocity = nil
		end
		isFlying = false
	else
		BodyVelocity = Instance.new("BodyVelocity", Character.HumanoidRootPart)
		BodyVelocity.Velocity = Vector3.new(0, 50, 0)
		BodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
		humanoid.PlatformStand = true
		isFlying = true
	end
end

createButton("Toggle Fly", UDim2.new(0, 10, 0, 10), toggleFly)

-- Skybox Changer
local SkyboxInput = createTextBox("Enter Skybox ID", UDim2.new(0, 10, 0, 60))

local function changeSkybox()
	local skyboxID = SkyboxInput.Text
	if skyboxID and skyboxID ~= "" then
		if not Lighting:FindFirstChild("CustomSky") then
			local sky = Instance.new("Sky")
			sky.Name = "CustomSky"
			sky.Parent = Lighting
		end
		local sky = Lighting:FindFirstChild("CustomSky")
		sky.SkyboxBk = "rbxassetid://" .. skyboxID
		sky.SkyboxDn = "rbxassetid://" .. skyboxID
		sky.SkyboxFt = "rbxassetid://" .. skyboxID
		sky.SkyboxLf = "rbxassetid://" .. skyboxID
		sky.SkyboxRt = "rbxassetid://" .. skyboxID
		sky.SkyboxUp = "rbxassetid://" .. skyboxID
	end
end

createButton("Apply Skybox", UDim2.new(0, 10, 0, 100), changeSkybox)

-- Player Title Changer
local TitleInput = createTextBox("Enter Player Title", UDim2.new(0, 10, 0, 150))

local function changeTitle()
	local newTitle = TitleInput.Text
	if newTitle and newTitle ~= "" then
		local nameTag = Character:FindFirstChild("NameTag")
		if not nameTag then
			nameTag = Instance.new("BillboardGui", Character)
			nameTag.Name = "NameTag"
			nameTag.Size = UDim2.new(0, 200, 0, 50)
			nameTag.Adornee = Character.Head
			nameTag.StudsOffset = Vector3.new(0, 2, 0)

			local textLabel = Instance.new("TextLabel", nameTag)
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
			textLabel.Font = Enum.Font.SourceSansBold
			textLabel.TextSize = 20
			textLabel.Text = newTitle
		else
			nameTag.TextLabel.Text = newTitle
		end
	end
end

createButton("Apply Title", UDim2.new(0, 10, 0, 190), changeTitle)

-- Toggle Random Skin Color
local isRandomizingSkin = false
local function toggleRandomSkin()
	isRandomizingSkin = not isRandomizingSkin
	if isRandomizingSkin then
		spawn(function()
			while isRandomizingSkin do
				for _, part in pairs(Character:GetChildren()) do
					if part:IsA("BasePart") then
						part.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
					end
				end
				wait(1) -- Change colors every second
			end
		end)
	end
end

createButton("Toggle Random Skin", UDim2.new(0, 10, 0, 230), toggleRandomSkin)

-- Place a Brick
local function placeBrick()
	local brick = Instance.new("Part")
	brick.Size = Vector3.new(4, 1, 4)
	brick.Position = HumanoidRootPart.Position - Vector3.new(0, 3, 0)
	brick.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
	brick.Anchored = true
	brick.Parent = workspace
end

createButton("Place Brick", UDim2.new(0, 10, 0, 270), placeBrick)

-- Play a Random Sound
local soundIDs = {
	"142376088", -- Example sound IDs (replace these with real ones)
	"904908246",
	"130776739",
	"184356506"
}

local function playRandomSound()
	local sound = Instance.new("Sound")
	sound.Parent = SoundService
	sound.SoundId = "rbxassetid://" .. soundIDs[math.random(1, #soundIDs)]
	sound.Volume = 5
	sound:Play()
end

createButton("Play Random Sound", UDim2.new(0, 10, 0, 310), playRandomSound)
