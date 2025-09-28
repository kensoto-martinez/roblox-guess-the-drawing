local gui = game.Players.LocalPlayer.PlayerGui
local word = gui:FindFirstChild("TheWord").Frame.word
local confirmed_word = gui:FindFirstChild("guessList").Frame.word

local extra_words = {}

local word_connection
local confirmed_word_connection

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
	valid_text_label.Size = UDim2.new(1, 0, 0, 15)
	valid_text_label.Font = Enum.Font.PatrickHand
	valid_text_label.Text = "ExampleText"
	valid_text_label.TextColor3 = Color3.fromRGB(0, 0, 0)
	valid_text_label.TextScaled = true
	valid_text_label.Name = "ValidWordLabel"
	valid_text_label.Parent = game.ReplicatedStorage
	CreateUIStroke(valid_text_label).Thickness = .5
end

local function WordChanged()
	local word_text = word.Text:lower()
	local scrolling_frame = gui.GTD.Frame.Frame.ScrollingFrame
	local list = loadstring(game:HttpGet("https://raw.githubusercontent.com/kensoto-martinez/roblox-guess-the-drawing/main/wordlist.lua"))()

	local function MatchesWord(str: string)
		for n = 1, #word_text do
			--get n'th character from word_text and given string
	        local word_char = word_text:sub(n, n)
	        local str_char = str:sub(n, n)
			--if word_text has an underscore, continue; if n'th character from both strings don't match, return false
	        if word_char ~= "_" and str_char ~= word_char then
	            return false
	        end
	    end
		--return true if string and word_text match, excluding underscores
	    return true
	end

	local function AddWordLabel(word_label_text: string)
		local text_label = game.ReplicatedStorage.ValidWordLabel:Clone()
		text_label.Text = word_label_text
		text_label.Parent = scrolling_frame
	end

	local function CheckMatchingWord(word_from_list: string)
		if MatchesWord(word_from_list) then
			--add valid word label if word matches with word_text
			AddWordLabel(word_from_list)
			valid_word_added = true
		end
	end

	--delete previous valid words
	for _, child in pairs(scrolling_frame:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end

	--make new valid word labels
	local valid_word_added = false
	if list[#word_text] then --don't make new labels for n-letter words that don't have an array
		for _, word_from_list in ipairs(list[#word_text]) do
			CheckMatchingWord(word_from_list)
		end
		--check alternate list as well
		if extra_words[#word_text] then
			for _, word_from_list in ipairs(extra_words[#word_text]) do
				CheckMatchingWord(word_from_list)
			end
		end
	end

	--if a valid word was not found, say so
	if not valid_word_added then
		AddWordLabel("No valid word found in current word bank.")
		--add an event that checks for the confirmed word after the round ends, and add it to the extra array
		confirmed_word_connection = confirmed_word:GetPropertyChangedSignal("Text"):Connect(function()
			extra_words[#confirmed_word.Text] = confirmed_word.Text:lower()
			confirmed_word_connection:Disconnect()
		end)
	end
end

if word and confirmed_word then
	--initialize gui and start word logic event
	CreateGui()
	WordChanged()
	word_connection = word:GetPropertyChangedSignal("Text"):Connect(WordChanged)
else
	--warn player of error
	warn("Script error: game has either moved the location of the revealing word in the game or you accidentally changed the 'word' variable to an invalid location.")
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
