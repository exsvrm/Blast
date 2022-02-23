keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTPmenu"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["UP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

Pmenu = {}
COLORCURRENTMENU = "~w~"
local color_white = {255, 255, 255}
local color_blue = {255, 255, 255}
local color_black = {0, 0, 0}
local defaultHeader = {"commonmenu", "interaction_bgd"}
local defaultMenu = { { name = "Empty" } }
local _intX, _intY = .24, .175
local _intW, _intH = .225, .035
local spriteW, spriteH = .225, .0500
local IsVisible = false

function MeasureStringWidth(str, font, scale)
	BeginTextCommandWidth("STRING")
	AddTextComponentSubstringPlayerName(str)
	SetTextFont(font or 0)
	SetTextScale(1.0, scale or 0)
	return EndTextCommandGetWidth(true)
end


function IsMouseInBounds(X, Y, Width, Height)
	local MX, MY = GetControlNormal(0, 239) + Width / 2, GetControlNormal(0, 240) + Height / 2
	return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end


function Pmenu:resetMenu()
	self.Data = { back = {}, currentMenu = "", intY = _intY, intX = _intX }
	self.Pag = { 1, 10, 1, 1 }
	self.Base = {
		Header = defaultHeader,
		Color = color_black,
		HeaderColor = color_blue,
		Title = MP and MP.user and MP.user.name or "Menu",
		Checkbox = { Icon = { [0] = {"helicopterhud", "hud_lock"}, [1] = {"commonmenu", "shop_tick_icon"}, [2] = {"helicopterhud", "hud_outline"} } }
	}
	self.Menu = {}
	self.Events = {}
	self.tempData = {}
	self.IsVisible = false
end


function stringsplit(inputstr, sep)
	if not inputstr then return end
	if sep == nil then
		sep = "%s"
	end
	local t = {} ; i = 1
	for str in string.BLASTatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end


function ShowTextMP(intFont, stirngText, floatScale, intPosX, intPosY, color, boolShadow, intAlign, addWarp)
	SetTextFont(intFont)
	SetTextScale(floatScale, floatScale)
	if boolShadow then
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
	end
	SetTextColour(color[1], color[2], color[3], 255)
	if intAlign == 0 then
		SetTextCentre(true)
	else
		SetTextJustification(intAlign or 1)
		if intAlign == 2 then
			SetTextWrap(.0, addWarp or intPosX)
		end
	end
	SetTextEntry("STRING")
	AddTextComponentString(stirngText)
	DrawText(intPosX, intPosY)
end


function IsMenuOpened()
	return IsVisible
end


function SetMenuVisible(bool)
	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
	IsVisible = bool
end


function Pmenu:CloseMenu(bypass)
	if self.IsVisible and (not self.Base.Blocked or bypass) then
		self.IsVisible = false
		if self.Events["onExited"] then self.Events["onExited"](self.Data, self) end
		PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		SetMenuVisible(false)
		self:resetMenu()
	end
end


function Pmenu:GetButtons(customMenu)
	local menu = customMenu or self.Data.currentMenu
	local menuData = self.Menu and self.Menu[menu]
	local allButtons = menuData and menuData.buttons
	if not allButtons then return {} end
	local tblFilter = {}
	allButtons = type(allButtons) == "function" and allButtons(self) or allButtons
	if not allButtons or type(allButtons) ~= "table" then return {} end
	if self.Events and self.Events["onLoadButtons"] then allButtons = self.Events["onLoadButtons"](self, menu, allButtons) or allButtons end
	for _,v in pairs(allButtons) do
		if v and type(v) == "table" and (v.canSee and (type(v.canSee) == "function" and v.canSee() or v.canSee == true) or v.canSee == nil) and (not menuData.filter or string.find(string.lower(v.name), menuData.filter)) then
			if v.customSlidenum then v.slidenum = type(v.customSlidenum) == "function" and v.customSlidenum() or v.customSlidenum end
			local max = type(v.slidemax) == "function" and v.slidemax(v, self) or v.slidemax
			if type(max) == "number" then
				local tbl = {}
				for i = 0, max do
					tbl[#tbl + 1] = i
				end
				max = tbl
			end

			if max then
				v.slidenum = v.slidenum or 1
				local slideName = max[v.slidenum]
				if slideName then
					v.slidename = slideName and type(slideName) == "table" and slideName.name or tostring(slideName)
				end
			end

			tblFilter[#tblFilter + 1] = v
		end
	end

	if #tblFilter <= 0 then tblFilter = defaultMenu end

	self.tempData = { tblFilter, #tblFilter }
	return tblFilter, #tblFilter

end


function Pmenu:OpenMenu(stringName, boolBack)

	if stringName and not self.Menu[stringName] then print("^1[Error] " ..stringName.. "") return end

	local newButtons, currentButtonsCount = self:GetButtons(stringName)
	--if not boolBack and (newButtons and newButtons[self.Pag[3]] and newButtons[self.Pag[3]].name ~= string.lower(stringName)) then
	if not boolBack and self.Data and self.Data.back then
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		self.Data.back[#self.Data.back + 1] = self.Data.currentMenu
	end

	if boolBack then
		PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		self.Data.back[#self.Data.back] = nil
	end

	local intSelect = boolBack and self.Pag[4] or 1
	local max = math.max(10, math.min(intSelect))
	self.Pag = { max - 9, max, intSelect, self.Pag[3] or 1 } -- min, max, current, ancien menu
	self.tempData = { newButtons, currentButtonsCount }
	self.Data.currentMenu = stringName
	if self.Events and self.Events["onButtonSelected"] then self.Events["onButtonSelected"](self.Data.currentMenu, self.Pag[3], self.Data.back, newButtons[1] or {}, self) end
end


function Pmenu:Back()
	local historyCount = #self.Data.back
	if historyCount == 0 and not self.Base.Blocked then
		self:CloseMenu()
	elseif historyCount - 1 == 0 and not self.Base.Blocked then
		self:CloseMenu()
	elseif historyCount - 1 > 0 and not self.Base.BackBlocked then
		self:OpenMenu(self.Data.back[#self.Data.back], true)
		if self.Events["onBack"] then self.Events["onBack"](self.Data, self) end
	end
end


function Pmenu:CreateMenu(table, tempData)
	if (self.Base and self.Base.Blocked and self.IsVisible and IsMenuOpened()) or not table then return end
	if not self.IsVisible and table then
		self:resetMenu()

		table.Base = table.Base or {}
		for i,v in pairs(table.Base) do
			if k == "Header" then RequestStreamedTextureDict(v[1]) SetStreamedTextureDictAsNoLongerNeeded(v[1]) end
			self.Base[i] = v
		end

		if not HasStreamedTextureDictLoaded("commonmenu") then
			RequestStreamedTextureDict("commonmenu", true)
		end

		if not HasStreamedTextureDictLoaded("helicopterhud") then
			RequestStreamedTextureDict("helicopterhud", true)
		end

		table.Data = table.Data or {}

		for i,v in pairs(table.Data) do
			self.Data[i] = v
		end

		table.Events = table.Events or {}

		for i,v in pairs(table.Events) do
			self.Events[i] = v
		end

		table.Menu = table.Menu or {}

		for i,v in pairs(table.Menu) do
			self.Menu[i] = v
		end

		self.Data.temp = tempData
		self.Base.CustomHeader = self.Base.Header and self.Base.Header[2] ~= "interaction_bgd"
		_intY = self.Base.CustomHeader and .205 or .17

		if self.Events["onButtonSelected"] then
			local allButtons, count = self:GetButtons()
			self.tempData = { allButtons, count }
			self.Events["onButtonSelected"](self.Data.currentMenu, 1, {}, allButtons[1] or {}, self)
		end

		self:OpenMenu(self.Data.currentMenu)

		local boolVisible = self.Base and self.Base.Blocked or not self.IsVisible
		self.IsVisible = boolVisible
		SetMenuVisible(boolVisible)
		if self.IsVisible and self.Events and self.Events["onOpened"] then self.Events["onOpened"](self.Data, self) end
	else
		self:CloseMenu(true)
	end

end


function Pmenu:ProcessControl()
	local keyT = IsInputDisabled and IsInputDisabled(2) and 0 or 1
	local boolUP, boolDOWN, boolRIGHT, boolLEFT = IsControlPressed(1, keys["UP"]), IsControlPressed(1, keys["DOWN"]), IsControlPressed(1, keys["RIGHT"]), IsControlPressed(1, keys["LEFT"])
	local currentMenu = self.Menu and self.Menu[self.Data.currentMenu]
	local currentButtons, currentButtonsCount = table.unpack(self.tempData)
	local currentBtn = currentButtons and currentButtons[self.Pag[3]]

	if currentMenu and currentMenu.refresh then
		self:GetButtons()
	end

	if (boolUP or boolDOWN) and currentButtonsCount and self.Pag[3] then
		PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FREEMODE_SOUNDSET", true)
		if boolDOWN and (self.Pag[3] < currentButtonsCount) or boolUP and (self.Pag[3] > 1) then
			self.Pag[3] = self.Pag[3] + (boolDOWN and 1 or -1)
			if currentButtonsCount > 10 and (boolUP and (self.Pag[3] < self.Pag[1]) or (boolDOWN and (self.Pag[3] > self.Pag[2]))) then
				self.Pag[1] = self.Pag[1] + (boolDOWN and 1 or -1)
				self.Pag[2] = self.Pag[2] + (boolDOWN and 1 or -1)
			end
		else
			self.Pag = { boolUP and currentButtonsCount - 9 or 1, boolUP and currentButtonsCount or 10, boolDOWN and 1 or currentButtonsCount, self.Pag[4] or 1 }
			if currentButtonsCount > 10 and (boolUP and (self.Pag[3] > self.Pag[2]) or (boolDOWN and (self.Pag[3] < self.Pag[1]))) then
				self.Pag[1] = self.Pag[1] + (boolDOWN and -1 or 1)
				self.Pag[2] = self.Pag[2] + (boolDOWN and -1 or 1)
			end
		end
		if self.Events["onButtonSelected"] then
			self.Events["onButtonSelected"](self.Data.currentMenu, self.Pag[3], self.Data.back, currentButtons[self.Pag[3]] or {}, self)
		end

		Citizen.Wait(100)

	end

	if (boolRIGHT or boolLEFT) and currentBtn then
		local slide = currentBtn.slide or currentMenu.slide or self.Events["onSlide"]
		if currentMenu.slidemax or currentBtn and currentBtn.slidemax or self.Events["onSlide"] or slide then
			local changeTo = currentMenu.slidemax and currentMenu or currentBtn.slidemax and currentBtn
			if changeTo and not changeTo.slidefilter or changeTo and not tableHasValue(changeTo.slidefilter, self.Pag[3]) then
				currentBtn.slidenum = currentBtn.slidenum or 0
				local max = type(changeTo.slidemax) == "function" and (changeTo.slidemax(currentBtn, self) or 0) or changeTo.slidemax
				if type(max) == "number" then
					local tbl = {}
					for i = 0, max do
						tbl[#tbl + 1] = i
					end
					max = tbl
				end

				currentBtn.slidenum = currentBtn.slidenum + (boolRIGHT and 1 or -1)
				if (boolRIGHT and (currentBtn.slidenum > #max) or boolLEFT and (currentBtn.slidenum < 1)) then
					currentBtn.slidenum = boolRIGHT and 1 or #max
				end

				local slideName = max[currentBtn.slidenum]
				currentBtn.slidename = slideName and type(slideName) == "table" and slideName.name or tostring(slideName)
				local Offset = MeasureStringWidth(currentBtn.slidename, 0, 0.35)

				currentBtn.offset = Offset
				if slide then slide(self.Data, currentBtn, self.Pag[3], self) end
				Citizen.Wait(currentMenu.slidertime or 175)
			end
		end

		if currentBtn.parentSlider ~= nil and ((boolLEFT and currentBtn.parentSlider < 1.5 + .25) or (boolRIGHT and currentBtn.parentSlider > .5 - .25)) then
			currentBtn.parentSlider = boolLEFT and round(currentBtn.parentSlider + .01, 2) or round(currentBtn.parentSlider - .01, 2)
			if self.Events["onSlider"] then self.Events["onSlider"](self, self.Data, currentBtn, self.Pag[3], allButtons, currentBtn.parentSlider - .25) end
			Citizen.Wait(10)
		end
	end

	if currentMenu and currentMenu.extra or currentBtn and currentBtn.opacity then
		if currentBtn.advSlider and IsDisabledControlPressed(0, 24) then
			local x, y, w = table.unpack(self.Data.advSlider)
			local left, right = IsMouseInBounds(x - 0.01, self.Height, .015, .03), IsMouseInBounds(x - w + 0.01, self.Height, .015, .03)
			if left or right then
				local advPadding = 1
				currentBtn.advSlider[3] = math.max(currentBtn.advSlider[1], math.min(currentBtn.advSlider[2], right and currentBtn.advSlider[3] - advPadding or left and currentBtn.advSlider[3] + advPadding ))
				self.Events["onAdvSlide"](self, self.Data, currentBtn, self.Pag[3], currentButtons)
			end
			Citizen.Wait(75)
		end
	end

	if IsControlJustPressed(1, 202) and UpdateOnscreenKeyboard() ~= 0 then
		self:Back()
		Citizen.Wait(100)
	end

	if self.Pag[3] and currentButtonsCount and self.Pag[3] > currentButtonsCount then
		self.Pag = { 1, 10, 1, self.Pag[4] or 1 }
	end
end


function Pmenu:drawMenuButton(button, intX, intY, boolSelected, intW, intH, intID)
	local tableColor, add, currentMenuData = boolSelected and (button.colorSelected or { 255, 255, 255, 255 }) or (button.colorFree or { 0, 0, 0, 100 }), .0, self.Menu[self.Data.currentMenu]
	DrawRect(intX, intY, intW, intH, tableColor[1], tableColor[2], tableColor[3], tableColor[4])
	tableColor = boolSelected and {0, 0, 0} or {255, 255, 255}

	local stringPrefix = (((button.r and (((MP and (MP.jobRank < button.r or MP.copRank < button.r)) or (button.rfunc and not button.rfunc())) and "~r~" or "")) or "") .. (self.Events["setPrefix"] and self.Events["setPrefix"](button, self.Data) or "")) or ""
	ShowTextMP(0, (Pmenu.FTU(button.price and "> " or "")) .. stringPrefix .. (Pmenu.FTU(button.name or "")), .275, intX - intW / 2 + .005, intY - intH / 2 + .0025, tableColor)

	local unkCheckbox = currentMenuData and currentMenuData.checkbox or button.checkbox ~= nil and button.checkbox
	local slide = button.slidemax and button or currentMenuData
	local slideExist = slide and slide.slidemax and (not slide.slidefilter or not tableHasValue(slide.slidefilter, intID))
	if button.name and self.Menu[string.lower(button.name)] and not currentMenuData.item and not slideExist then
		--DrawSprite("commonmenutu", "arrowright", intX + (intW / 2.2), intY, .009, .018, 0.0, tableColor[1], tableColor[2], tableColor[3], 255)
		add = .0125
	end

	if unkCheckbox ~= nil and (button.checkbox ~= nil or currentMenuData and currentMenuData.checkbox ~= nil) then
		local bool = unkCheckbox ~= nil and (type(unkCheckbox) == "function" and unkCheckbox(PlayerPedId(), button, self.Base.currentMenu, self)) or unkCheckbox
		bool = bool and bool == true and 1 or 0
		if not self.Base.Checkbox["Icon"] or self.Base.Checkbox["Icon"][bool] then
			local successIcon = self.Base.Checkbox["Icon"] and self.Base.Checkbox["Icon"][bool]
			if successIcon and successIcon[1] and successIcon[2] then
				local checkboxColor = boolSelected and {0, 0, 0} or {255, 255, 255}
				DrawSprite(successIcon[1], successIcon[2], intX + (intW / 2.2), intY, .013, .025, 0.0, checkboxColor[1], checkboxColor[2], checkboxColor[3], 255)
				return
			end
		end
	elseif slideExist or button.RightLabel or button.slidename then
		local max = slideExist and slide and (type(slide.slidemax) == "function" and slide.slidemax(button, self) or slide.slidemax)
		if (max and type(max) == "number" and max > 0 or type(max) == "table" and #max > 0) or not slideExist then
			local defaultIndex = slideExist and button.slidenum or 1
			local slideText = button.RightLabel and (type(button.RightLabel) == "function" and button.RightLabel(self) or button.RightLabelValue or button.RightLabel) or (button.slidename or (type(max) == "number" and (defaultIndex - 1) or type(max[defaultIndex]) == "table" and max[defaultIndex].name or tostring(max[defaultIndex])))
			slideText = tostring(slideText)
			if boolSelected and slideExist then
				DrawSprite("commonmenu", "arrowright", intX + (intW / 2) - .01025, intY + 0.0004, .009, .018, 0.0, tableColor[1], tableColor[2], tableColor[3], 255)
				button.offset = MeasureStringWidth(slideText, 0, .275)
				DrawSprite("commonmenu", "arrowleft", intX + (intW / 2) - button.offset - .016, intY + 0.0004, .009, .018, 0.0, tableColor[1], tableColor[2], tableColor[3], 255)
			end

			local textX = (not boolSelected or button.RightLabel) and -.004 or - .0135
			ShowTextMP(0, slideText, .275, intX + intW / 2 + textX,  intY - intH / 2 + .00375, tableColor, false, 2)
			intX = boolSelected and intX - .0275 or intX - .0125
		end
	end

	if button.parentSlider ~= nil then
		local rectX, rectY = intX + .0925, intY + 0.005
		local proW, proH = .1, 0.01
		DrawSprite("mpleaderboard", "leaderboard_female_icon", intX + (intW / 2) - .01025, intY + 0.0004, .0156, .0275, 0.0, tableColor[1], tableColor[2], tableColor[3], 255)
		DrawSprite("mpleaderboard", "leaderboard_male_icon", intX - .015, intY + 0.0004, .0156, .0275, 0.0, tableColor[1], tableColor[2], tableColor[3], 255)

		local slideW = proW * button.parentSlider
		DrawRect(rectX - proW / 2, rectY - proH / 2, proW, proH, 4, 32, 57, 255)
		DrawRect(rectX - slideW / 2, rectY - proH / 2, proW * .25, proH, 57, 116, 200, 255)

		DrawRect(rectX - proW / 2, rectY - proH / 2, .002, proH + 0.005, tableColor[1], tableColor[2], tableColor[3], 255)
	end

	local textBonus = (self.Events["setBonus"] and self.Events["setBonus"](button, self.Data.currentMenu, self)) or (button.amount and button.amount) or (button.price and "~g~" .. button.price .. "")
	if textBonus and string.len(textBonus) > 0 then
		ShowTextMP(0, textBonus, .275, intX + (intW / 2) - .005 - add,  intY - intH / 2 + .00375, tableColor, true, 2)
	end
	local result = (self.Events["lock"] and self.Events["lock"](button, self.Data.currentMenu, self)) or (button.lock and button.lock)
	if result then
		if type(result) == "table" then
			DrawSprite("commonmenu", "shop_lock", intX + (intW / 2.15), intY, .02, .034, 0.0, tableColor[1], tableColor[2], tableColor[3], 255)
		else
			DrawSprite("commonmenu", "shop_lock", intX + (intW / 2.15), intY, .02, .034, 0.0, tableColor[1], tableColor[2], tableColor[3], 255)
		end
	end
	local result = (self.Events["center"] and self.Events["center"](button, self.Data.currentMenu, self)) or (button.center and button.center)
	if result then
		if type(result) == "table" then
			ShowTextMP(0, Pmenu.FTU(result), .275, self.Width  - spriteW / 2, self.Height - intH / 2 + .0025, tableColor, false, 0)
		else
			ShowTextMP(0, Pmenu.FTU(result), .275, self.Width  - spriteW / 2, self.Height - intH / 2 + .0025, tableColor, false, 0)
		end
	end
end


function MultilineFormat(str, size)
	if tostring(str) then
		local PixelPerLine = _intW + .025
		local AggregatePixels = 0
		local output = ""
		local words = stringsplit(tostring(str), " ")

		for i = 1, #words do
			local offset = MeasureStringWidth(words[i], 0, size)
			AggregatePixels = AggregatePixels + offset
			if AggregatePixels > PixelPerLine then
				output = output .. "\n" .. words[i] .. " "
				AggregatePixels = offset + 0.003
			else
				output = output .. words[i] .. " "
				AggregatePixels = AggregatePixels + 0.003
			end
		end
		return output
	end
end


function Pmenu:DrawButtons(tableButtons)
	local padding, pd = 0.0175, 0.0475
	for intID, data in ipairs(tableButtons) do
		local shouldDraw = intID >= self.Pag[1] and intID <= self.Pag[2]
		if shouldDraw then
			local boolSelected = intID == self.Pag[3]
			self:drawMenuButton(data, self.Width - _intW / 2, self.Height, boolSelected, _intW, _intH - 0.005, intID)
			self.Height = self.Height + pd - padding
			if boolSelected and IsControlJustPressed(1, 201) and data.name ~= "Empty" and data.center ~= "Empty" then
				if self.Events["setCheckbox"] then self.Events["setCheckbox"](self.Data, data) end

				local slideEvent = data.slide or self.Events["onSlide"]
				if slideEvent or data.checkbox ~= nil then
					if not slideEvent then
						data.checkbox = not data.checkbox
					else
						slideEvent(self.Data, data, intID, self)
					end
				end

				local selectFunc, shouldContinue = self.Events["onSelected"], false
				if selectFunc then
					if data.slidemax and not data.slidenum and type(data.slidemax) == "table" then data.slidenum = 1 data.slidename = data.slidemax[1] end
					data.slidenum = data.slidenum or 1
					if data.RightLabel then
						data.RightLabelValue = nil
					end
					shouldContinue = selectFunc(self, self.Data, data, self.Pag[3], tableButtons)
				end

				if not shouldContinue and self.Menu[string.lower(data.name)] then
					self:OpenMenu(string.lower(data.name))

				end
			end
		end
	end
end


function Pmenu:DrawHeader(intCount)
	local parentHeader, childHeader = table.unpack(self.Base.Header)
	local boolHeader = parentHeader and string.len(parentHeader) > 0
	local currentMenu = self.Menu[self.Data.currentMenu]
	local stringCounter = currentMenu and currentMenu["customSub"] and currentMenu["customSub"]() or string.format("%s / %s", self.Pag[3], intCount)

	if boolHeader then
		local intH = self.Base.CustomHeader and 0.1025 or spriteH
		DrawSprite(parentHeader, childHeader, self.Width - spriteW / 2, self.Height - intH / 2, spriteW, intH, .0, self.Base.HeaderColor[1], self.Base.HeaderColor[2], self.Base.HeaderColor[3], 215)
		self.Height = self.Height - 0.03
		if not self.Base.CustomHeader then
			ShowTextMP(6, self.Base.Title, .55, 0.020, self.Height - intH / 2.5 + .0125, color_white)
		end
	end

	local ScaleformMovie = RequestScaleformMovie("MP_MENU_GLARE")
	while not HasScaleformMovieLoaded(ScaleformMovie) do
	Citizen.Wait(0)
	end
	if not self.Data.RemoveWorld then
	DrawScaleformMovie(ScaleformMovie, self.Width+ 0.163, self.Height + 0.349, spriteW + 0.5, _intH + 0.7835, 255, 255, 255, 255, 0)
	end

	self.Height = self.Height + 0.06
	local rectW, rectH = _intW, _intH - .005
	DrawRect(self.Width - rectW / 2, self.Height - rectH / 2, rectW, rectH, self.Base.Color[1], self.Base.Color[2], self.Base.Color[3], 255)


	if self.Data.TypeRed then
		COLORCURRENTMENU = "~HUD_COLOUR_REDDARK~"
	end

	if self.Data.TypeBlue then
		COLORCURRENTMENU = "~HUD_COLOUR_BLUE~"
	end

	if self.Data.TypeBlack then
		COLORCURRENTMENU = "~HUD_COLOUR_WHITE~"
	end

	self.Height = self.Height + 0.005
	ShowTextMP(0, string.upper(COLORCURRENTMENU..self.Data.currentMenu), .275, self.Width - rectW + .005, self.Height - rectH - 0.0015, color_white, true)

	self.Height = self.Height + 0.005
	ShowTextMP(0, stringCounter, .275, self.Width - rectW / 2 + .11, self.Height - _intH, color_white, true, 2)

	self.Height = self.Height + 0.005
end


function Pmenu:DrawHelpers(tableButtons)
	local hasHelp = self.Base.desc or self.Menu[self.Data.currentMenu] and self.Menu[self.Data.currentMenu].desc or tableButtons[self.Pag[3]] and tableButtons[self.Pag[3]].desc
	if hasHelp then
		local intH, scale = 0.0275, 0.275
		self.Height = self.Height - 0.015

		DrawRect(self.Width - _intW / 2, self.Height, _intW, 0.0025, 0, 0, 0, 255)

		local descText = MultilineFormat(hasHelp, scale)
		local Linecount = #stringsplit(descText, "\n")

		local nwintH = intH + (Linecount == 1 and 0 or ( (Linecount + 1) * 0.0075))
		self.Height = self.Height + intH / 2

		DrawSprite("commonmenu", "gradient_bgd", self.Width - _intW / 2, self.Height + nwintH / 2 - 0.015, _intW, nwintH, .0, 255, 255, 255, 255)
		ShowTextMP(0, descText, scale, self.Width - _intW + .005, self.Height - 0.01, color_white)
	end
end

function Pmenu:DrawExtra(tableButtons)
	ShowCursorThisFrame()
	DisableControlAction(0, 1, true)
	DisableControlAction(0, 2, true)
	DisableControlAction(0, 24, true)
	DisableControlAction(0, 25, true)

	local button = tableButtons[self.Pag[3]]
	if button and button.opacity ~= nil then
		local proW, proH = _intW, 0.055
		self.Height =  self.Height - 0.01
		DrawSprite("commonmenu", "gradient_bgd", self.Width - proW / 2, self.Height + proH / 2, proW, proH, 0.0, 255, 255, 255, 255)
		self.Height = self.Height + 0.005
		ShowTextMP(0, "0%", 0.275, self.Width - _intW + .005, self.Height, color_white, false, 1)
		ShowTextMP(0, "Opacity", 0.275, self.Width - _intW / 2, self.Height, color_white, false, 0)
		ShowTextMP(0, "100%", 0.275, self.Width - 0.005, self.Height, color_white, false, 2)

		self.Height = self.Height + .033
		local rectW, rectH = .215, 0.015
		local customW = rectW * ( 1 - button.opacity )
		local rectX, rectY = self.Width - rectW / 2 - 0.005, self.Height
		local customX = self.Width - customW / 2 - 0.005
		DrawRect(rectX, rectY, rectW, rectH, 245, 245, 245, 255)
		DrawRect(customX, rectY, customW, rectH, 87, 87, 87, 255)

		if IsDisabledControlPressed(0, 24) and IsMouseInBounds(rectX, rectY, rectW, rectH) then
			local mouseXPos = GetControlNormal(0, 239) - proH / 2
			button.opacity = math.max(0.0, math.min(1.0, mouseXPos / rectW + 0.081))
			self.Events["onSlide"](self.Data, button, self.Pag[3], self)
		end
		self.Height = self.Height + 0.025
	end

	if button and button.advSlider ~= nil then
		local proW, proH = _intW, 0.055
		DrawSprite("commonmenu", "gradient_bgd", self.Width - proW / 2, self.Height + proH / 2, proW, proH, 0.0, 255, 255, 255, 255)
		self.Height = self.Height + 0.005
		button.advSlider[3] = button.advSlider[3] or 0
		ShowTextMP(0, tostring(button.advSlider[1]), 0.275, self.Width - _intW + .005, self.Height, color_white, false, 1)
		ShowTextMP(0, "Variations", 0.275, self.Width - _intW / 2, self.Height, color_white, false, 0)
		ShowTextMP(0, tostring(button.advSlider[2]), 0.275, self.Width - 0.005, self.Height, color_white, false, 2)

		self.Height = self.Height + .03
		DrawSprite("commonmenu", "arrowright", self.Width - 0.01, self.Height, .015, .03, 0.0, 255, 255, 255, 255)
		DrawSprite("commonmenu", "arrowleft", self.Width - proW + 0.01, self.Height, .015, .03, 0.0, 255, 255, 255, 255)

		local rectW, rectH = .19, 0.015
		local rectX, rectY = self.Width - proW / 2, self.Height
		DrawRect(rectX, rectY, rectW, rectH, 87, 87, 87, 255)

		local sliderW = rectW / (button.advSlider[2] + 1)
		local sliderWFocus = button.advSlider[2] * (sliderW / 2)
		local customX = rectX - sliderWFocus + (sliderW * ( button.advSlider[3] / button.advSlider[2] )) * button.advSlider[2]
		DrawRect(customX, rectY, sliderW, rectH, 245, 245, 245, 255)

		self.Data.advSlider = { self.Width, self.Height, proW }
	end
end


function Pmenu:Draw()
	local tableButtons, intCount = table.unpack(self.tempData)
	self.Height = self.Base and self.Base.intY or _intY
	self.Width = self.Base and self.Base.intX or _intX

	if tableButtons and intCount and not self.Invisible then
		self:DrawHeader(intCount)
		self:DrawButtons(tableButtons)
		self:DrawHelpers(tableButtons)

		local currentMenu, currentButton = self.Menu[self.Data.currentMenu], self.Pag[3] and tableButtons and tableButtons[self.Pag[3]]

		if currentMenu and (currentMenu.extra or currentButton and currentButton.opacity) then
			self:DrawExtra(tableButtons)
		end

		if currentMenu and currentMenu.useFilter then
			local keyFilter = a[0]["F"]
			DisableControlAction(1, keyFilter, true)

			if IsDisabledControlJustPressed(1, keyFilter) then
				print("Blast")
			end
		end
	end
	if self.Events and self.Events["onRender"] then self.Events["onRender"](self, tableButtons, tableButtons[self.Pag[3]], self.Pag[3]) end
end


function CloseMenu(force)
	return Pmenu:CloseMenu(force)
end


function CreateMenu(arrayMenu, tempData)
	return Pmenu:CreateMenu(arrayMenu, tempData)
end


function OpenMenu(stringName)
	return Pmenu:OpenMenu(stringName)
end


CreateThread(function()
	while true do
		Wait(2)
		if Pmenu.IsVisible then
			Pmenu:Draw()
		end
	end
end)


CreateThread(function()
	while true do
		Wait(2)
		if Pmenu.IsVisible and not Pmenu.Invisible then
			Pmenu:ProcessControl()
		end
	end
end)


function Pmenu.FTU(str)
    return (str:gsub("^%l", string.upper))
end

print("^3Original blast menu initialized")