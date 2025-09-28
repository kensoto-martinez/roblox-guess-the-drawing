local gui = game.Players.LocalPlayer.PlayerGui
local word = gui:FindFirstChild("TheWord").Frame.word
local word_connection

local function CreateGui()
	local function CreateUICorner(obj: GuiObject)
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(.075, 0)
		corner.Parent = obj
		
		return corner
	end
	
	local function CreateUIStroke(obj: GuiObject)
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(0, 0, 0)
		stroke.Thickness = 2
		stroke.Parent = obj
		
		return stroke
	end
	
	local function CreateUIListLayout(obj: GuiObject)
		local list = Instance.new("UIListLayout")
		list.Padding = UDim.new(.025, 0)
		list.FillDirection = Enum.FillDirection.Vertical
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.HorizontalAlignment = Enum.HorizontalAlignment.Center
		list.HorizontalFlex = Enum.UIFlexAlignment.Fill
		list.VerticalAlignment = Enum.VerticalAlignment.Center
		list.VerticalFlex = Enum.UIFlexAlignment.SpaceBetween
		list.Parent = obj
		
		return list
	end
	
	--gui
	local s_gui = Instance.new("ScreenGui")
	s_gui.Name = "GTD"
	s_gui.ResetOnSpawn = false
	s_gui.Parent = gui
	
	--frame
	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = Color3.fromRGB(12, 61, 135)
	frame.BackgroundTransparency = .3
	frame.Position = UDim2.fromScale(.025, .025)
	frame.Size = UDim2.fromScale(.1, .75)
	frame.Parent = s_gui
	CreateUICorner(frame)
	CreateUIStroke(frame)
	CreateUIListLayout(frame)
	local grabber = Instance.new("UIDragDetector")
	grabber.Parent = frame

	--item 1
	local title_label = Instance.new("TextLabel")
	title_label.BackgroundTransparency = 1
	title_label.LayoutOrder = 1
	title_label.Size = UDim2.fromScale(1, .05)
	title_label.Font = Enum.Font.PatrickHand
	title_label.RichText = true
	title_label.Text = "<b>Guess the Drawing</b>"
	title_label.TextColor3 = Color3.fromRGB(0, 0, 0)
	title_label.TextScaled = true
	title_label.Parent = frame
	
	--item 2
	local inner_frame = Instance.new("Frame")
	inner_frame.BackgroundTransparency = 1
	inner_frame.LayoutOrder = 2
	inner_frame.Size = UDim2.fromScale(1, .9)
	inner_frame.Parent = frame
	CreateUIListLayout(inner_frame).VerticalFlex = Enum.UIFlexAlignment.Fill
	--inner text label
	local extra_info_label = title_label:Clone()
	extra_info_label.Size = UDim2.fromScale(1, .04)
	extra_info_label.Text = "Valid words:"
	extra_info_label.Parent = inner_frame
	--inner scrolling frame
	local scrolling_frame = Instance.new("ScrollingFrame")
	scrolling_frame.BackgroundColor3 = Color3.fromRGB(5, 24, 53)
	scrolling_frame.BackgroundTransparency = .5
	scrolling_frame.LayoutOrder = 2
	scrolling_frame.Size = UDim2.fromScale(1, .96)
	scrolling_frame.ScrollBarThickness = 18
	scrolling_frame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	scrolling_frame.Parent = inner_frame
	CreateUICorner(scrolling_frame)
	local inner_inner_list = CreateUIListLayout(scrolling_frame)
	inner_inner_list.VerticalFlex = Enum.UIFlexAlignment.None
	inner_inner_list.VerticalAlignment = Enum.VerticalAlignment.Top
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(.01, 0)
	
	--valid text label
	local valid_text_label = Instance.new("TextLabel")
	valid_text_label.BackgroundTransparency = 1
	valid_text_label.Size = UDim2.fromScale(1, .15)
	valid_text_label.Font = Enum.Font.PatrickHand
	valid_text_label.Text = "ExampleText"
	valid_text_label.TextColor3 = Color3.fromRGB(0, 0, 0)
	valid_text_label.TextScaled = true
	valid_text_label.Name = "ValidWordLabel"
	valid_text_label.Parent = game.ReplicatedStorage
	CreateUIStroke(valid_text_label).Thickness = .5
end

local function WordChanged()
	local word_length = #word.Text
	local list = loadstring(game:HttpGet("https://raw.githubusercontent.com/kensoto-martinez/roblox-guess-the-drawing/main/wordlist.lua"))()

	for i, word in ipairs(list[5]) do
		print(word)
	end
end

if word then
	--initialize gui and start sorting logic
	CreateGui()
	word_connection = word:GetPropertyChangedSignal("Text"):Connect(WordChanged)
else
	--warn player of error
	warn("Script error: game has either patched this script or the user changed the script.")
end

game.UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightAlt and word_connection then
		word_connection:Disconnect()
		word_connection = nil
		gui.GTD:Destroy()
		game.ReplicatedStorage.ValidWordLabel:Destroy()
	end
end)

print("Press Right Alt to remove gui.")