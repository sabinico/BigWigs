﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Hydross the Unstable"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local inTomb = {}
local debuff = {0, 10, 25, 50, 100, 250, 500}
local currentPerc = nil
local fmt = string.format
local CheckInteractDistance = CheckInteractDistance
local count = 1
local pName = nil
local stop

local tooltip

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Hydross",

	start_trigger = "I cannot allow you to interfere!",

	mark = "Mark",
	mark_desc = "Show warnings and counters for marks.",
	hydross_trigger = "Mark of Hydross",
	corruption_trigger = "Mark of Corruption",
	hydross_bar = "%s%% - Mark of Hydross",
	corruption_bar = "%s%% - Mark of Corruption",

	stance = "Stance changes",
	stance_desc = "Warn when Hydross changes stances.",
	poison_stance_trigger = "Aaghh, the poison...",
	water_stance_trigger = "Better, much better.",
	poison_stance = "Hydross is now poisoned!",
	water_stance = "Hydross is now cleaned again!",

	sludge = "Vile Sludge",
	sludge_desc = "Notify of players afflicted by Vile Sludge.",
	sludge_message = "Vile Sludge: %s",

	tomb = "Water Tomb",
	tomb_desc = "Notify of players afflicted by Water Tomb.",
	tomb_message = "Water Tomb: %s",

	icon = "Vile Sludge Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Vile Sludge(requires promoted or higher).",

	debuff_warn = "Mark at %s%%!",

	afflict_trigger = "^(%S+) (%S+) afflicted by (.*).$",
} end)

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Ich kann nicht zulassen, dass ihr Euch einmischt!",

	mark = "Mal",
	mark_desc = "Zeigt Warnungen und Anzahl des Mals.",

	stance = "Phasenwechsel",
	stance_desc = "Warnt wenn Hydross der Unstete seine Phase wechselt.",

	sludge = "\195\156bler Schlamm",
	sludge_desc = "Warnt welche Spieler von \195\156bler Schlamm betroffen sind.",

	icon = "\195\156bler Schlamm Icon",
	icon_desc = "Platziert ein Schlachtzugssymbol auf dem Spieler, welcher von \195\156bler Schlamm betroffen ist (ben\195\182tigt 'bef\195\182rdert' oder h\195\182her)",

	tomb = "Wassergrab",
	tomb_desc = "Warnt welche Spieler von Wassergrab betroffen sind.",

	start_trigger = "Ich kann nicht zulassen, dass Ihr Euch einmischt!",

	hydross_trigger = "Mal von Hydross",
	corruption_trigger = "Mal der der Verderbnis",

	hydross_bar = "Mal von Hydross - %s%%",
	corruption_bar = "Mal der Verderbnis - %s%%",

	debuff_warn = "Mal bei %s%%!",

	poison_stance_trigger = "Aahh, das Gift...",
	water_stance_trigger = "Besser, viel besser.",

	poison_stance = "Hydross ist nun vergiftet!",
	water_stance = "Hydross ist wieder gereinigt!",

	afflict_trigger = "^([^%s]+) ([^%s]+) von (.*) betroffen",

	sludge_message = "\195\156bler Schlamm: %s",
	tomb_message = "Wassergrab: %s",
} end)

L:RegisterTranslations("koKR", function() return {
	start_trigger = "방해하도록 놔두지 않겠습니다!",

	mark = "징표",
	mark_desc = "징표에 대한 경고와 카운터를 표시합니다.",
	hydross_trigger = "히드로스의 징표",
	corruption_trigger = "타락의 징표",
	hydross_bar = "히드로스의 징표 - %s%%",
	corruption_bar = "타락의 징표 - %s%%",

	stance = "태세 변경",
	stance_desc = "불안정한 히드로스의 태세 변경 시 경고합니다.",
	poison_stance_trigger = "으아아, 독이...",
	water_stance_trigger = "아... 기분이 훨씬 좋군.",
	poison_stance = "히드로스 오염!",
	water_stance = "히드로스 정화!",

	sludge = "타락의 진흙",
	sludge_desc = "타락의 진흙에 걸린 플레이어를 알립니다.",
	sludge_message = "타락의 진흙: %s",

	tomb = "수중 무덤",
	tomb_desc = "수중 무덤에 걸린 플레이어를 알립니다.",
	tomb_message = "수중 무덤: %s",

	icon = "전술 표시",
	icon_desc = "타락의 진흙에 걸린 플레이어에 전술 표시를 지정합니다 (승급자 이상 권한 필요).",

	debuff_warn = "징표 - %s%%!",

	afflict_trigger = "^([^|;%s]*)(%s+)(.*)에 걸렸습니다%.$",
} end)

L:RegisterTranslations("frFR", function() return {
	start_trigger = "Je ne peux pas vous laisser nous gêner !",

	mark = "Marque",
	mark_desc = "Affiche les alertes et les compteurs des marques.",
	hydross_trigger = "Marque d'Hydross",
	corruption_trigger = "Marque de corruption",
	hydross_bar = "%s%% - Marque d'Hydross",
	corruption_bar = "%s%% - Marque de corruption",

	stance = "Changements d'état",
	stance_desc = "Préviens quand Hydross l'Instable change d'état.",
	poison_stance_trigger = "Aaarrgh, le poison…",
	water_stance_trigger = "Ça va mieux. Beaucoup mieux.",
	poison_stance = "Hydross est maintenant empoisonné !",
	water_stance = "Hydross est de nouveau sain !",

	sludge = "Vase abominable",
	sludge_desc = "Préviens quand un joueur est affecté par la Vase abominable.",
	sludge_message = "Vase abominable : %s",

	tomb = "Tombe aquatique",
	tomb_desc = "Préviens quand des joueurs sont affectés par la Tombe aquatique.",
	tomb_message = "Tombe aquatique : %s",

	icon = "Icône Vase abominable",
	icon_desc = "Place une icône de raid sur le joueur affecté par la Vase abominable (nécessite d'être promu ou mieux).",

	debuff_warn = "Marque à %s%% !",

	afflict_trigger = "^(%S+) (%S+) les effets [de|2]+ (.*).$",
} end)

L:RegisterTranslations("zhCN", function() return {
	start_trigger = "我不能允许你们介入！",

	mark = "印记",
	mark_desc = "显示印记警报及计数。",
	hydross_trigger = "海度斯印记",
	corruption_trigger = "腐蚀印记",
	hydross_bar = "<海度斯印记 - %s%%>",
	corruption_bar = "<腐蚀印记 - %s%%>",

	stance = "形态改变",
	stance_desc = "海度斯毒性改变。",
	poison_stance_trigger = "啊……毒性侵袭了我……",
	water_stance_trigger = "感觉好多了。",
	poison_stance = "毒形态!",
	water_stance = "水形态!",

	sludge = "肮脏的淤泥怪",
	sludge_desc = "当临近的队友变成肮脏的淤泥怪发出警报。",
	sludge_message = "肮脏的淤泥怪：>%s<！",

	tomb = "水之墓",
	tomb_desc = "当临近队友成为水之墓发出警报。",
	tomb_message = "水之墓：>%s<！",

	icon = "肮脏的淤泥怪标记",
	icon_desc = "为受到肮脏的淤泥怪的队友打上标记。(需要权限)",

	debuff_warn = "印记施放于 %s%%!",

	afflict_trigger = "^(%S+)受(%S+)了(.*)效果的影响。$",
} end)

L:RegisterTranslations("zhTW", function() return {
	start_trigger = "我不准你涉入這件事!",

	mark = "印記",
	mark_desc = "印記警報及計數",
	hydross_trigger = "海卓司印記",
	corruption_trigger = "墮落印記",
	hydross_bar = "海卓司印記(冰霜) - %s%%",
	corruption_bar = "墮落印記(自然) - %s%%",

	stance = "形態改變",
	stance_desc = "當 不穩定者海卓司 改變型態時發出警報",
	poison_stance_trigger = "啊，毒……",
	water_stance_trigger = "很好，舒服多了。",
	poison_stance = "海卓司轉為毒型態！",
	water_stance = "海卓司轉為水狀態！",

	sludge = "混濁污泥",
	sludge_desc = "當隊友受到混濁污泥時提示。",
	sludge_message = "混濁污泥：[%s]",

	tomb = "水之墳",
	tomb_desc = "通報玩家受到水之墳",
	tomb_message = "水之墳：[%s]",

	icon = "混濁污泥標記",
	icon_desc = "對受到混濁污泥的目標設置標記（需要權限）",

	debuff_warn = "印記施放於 %s%%",

	afflict_trigger = "^(.+)受(到[了]*)(.*)效果的影響。$",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Serpentshrine Cavern"]
mod.enabletrigger = boss
mod.toggleoptions = {"stance", "mark", "enrage", -1, "sludge", "icon", "tomb", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	for k in pairs(inTomb) do inTomb[k] = nil end

	if not tooltip then
		tooltip = CreateFrame("GameTooltip", "HydrossTooltip", nil, "GameTooltipTemplate")
		tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	end

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("PLAYER_AURAS_CHANGED", "DebuffCheck")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HydrossTomb", 0)
	pName = UnitName("player")
	stop = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["start_trigger"] then
		count = 1
		currentPerc = nil
		stop = nil
		if self.db.profile.mark then
			self:Bar(fmt(L["hydross_bar"], debuff[count+1]), 15, "Spell_Frost_FrozenCore")
		end
		if self.db.profile.enrage then
			self:Message(fmt(L2["enrage_start"], boss, 10), "Attention")
			self:DelayedMessage(300, fmt(L2["enrage_min"], 5), "Positive")
			self:DelayedMessage(420, fmt(L2["enrage_min"], 3), "Positive")
			self:DelayedMessage(540, fmt(L2["enrage_min"], 1), "Positive")
			self:DelayedMessage(570, fmt(L2["enrage_sec"], 30), "Positive")
			self:DelayedMessage(590, fmt(L2["enrage_sec"], 10), "Urgent")
			self:DelayedMessage(600, fmt(L2["enrage_end"], boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	elseif msg == L["poison_stance_trigger"] then
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["hydross_bar"], debuff[count+1] and debuff[count+1] or 500))
		count = 1
		currentPerc = nil
		if self.db.profile.stance then
			self:Message(L["poison_stance"], "Important")
		end
		if self.db.profile.mark then
			self:Bar(fmt(L["corruption_bar"], debuff[count+1]), 15, "Spell_Nature_ElementalShields")
		end
		self:TriggerEvent("BigWigs_HideProximity", self)
	elseif msg == L["water_stance_trigger"] then
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["corruption_bar"], debuff[count+1] and debuff[count+1] or 500))
		count = 1
		currentPerc = nil
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
		if self.db.profile.stance then
			self:Message(L["water_stance"], "Important")
		end
		if self.db.profile.mark then
			self:Bar(fmt(L["hydross_bar"], debuff[count+1]), 15, "Spell_Frost_FrozenCore")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
end

-- returns the index of the mark in the debuff table, or the index of the last mark ( should not happen )
local function getMark(match)
	for i,v in ipairs(debuff) do
		if v == tonumber(match) then
			return i
		end
	end
	return #debuff
end

function mod:IncrementHydross(match)
	count = getMark(match)
	self:TriggerEvent("BigWigs_StopBar", self, fmt(L["hydross_bar"], debuff[count] and debuff[count] or 500))
	if self.db.profile.mark then
		self:Message(fmt(L["debuff_warn"], match), "Important", nil, "Alert")
		self:Bar(fmt(L["hydross_bar"], debuff[count+1] and debuff[count+1] or 500), 15, "Spell_Frost_FrozenCore")
	end
end

function mod:IncrementCorruption(match)
	count = getMark(match)
	self:TriggerEvent("BigWigs_StopBar", self, fmt(L["corruption_bar"], debuff[count] and debuff[count] or 500))
	if self.db.profile.mark then
		self:Message(fmt(L["debuff_warn"], match), "Important", nil, "Alert")
		self:Bar(fmt(L["corruption_bar"], debuff[count+1] and debuff[count+1] or 500), 15, "Spell_Nature_ElementalShields")
	end
end

function mod:DebuffCheck()
	local i = 1
	while true do
		buffIndex = GetPlayerBuff(i, "HARMFUL")
		if buffIndex == 0 then break end
		tooltip:SetPlayerBuff(buffIndex)
		local bName = HydrossTooltipTextLeft1:GetText()
		if bName == L["hydross_trigger"] then
			local match = select(3, HydrossTooltipTextLeft2:GetText():find("(%d+)"))
			if match ~= currentPerc then
				currentPerc = match
				self:IncrementHydross(match)
			end
		elseif bName == L["corruption_trigger"] then
			local match = select(3, HydrossTooltipTextLeft2:GetText():find("(%d+)"))
			if match ~= currentPerc then
				currentPerc = match
				self:IncrementCorruption(match)
			end
		end
		i = i + 1
	end
end

function mod:Event(msg)
	local aPlayer, aType, aSpell = select(3, msg:find(L["afflict_trigger"]))
	if aPlayer and aType then
		if aPlayer == L2["you"] and aType == L2["are"] then
			aPlayer = pName
		end
		if aSpell == L["tomb"] then
			self:Sync("HydrossTomb", aPlayer)
		elseif aSpell == L["sludge"] then
			self:Sync("HydrossSludge", aPlayer)
		end
	end
end

local function nilStop()
	stop = nil
	for k in pairs(inTomb) do inTomb[k] = nil end
end

function mod:TombWarn()
	if stop then return end
	if self.db.profile.tomb then
		local msg = nil
		for k in pairs(inTomb) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(fmt(L["tomb_message"], msg), "Attention")
	end
	stop = true
	self:ScheduleEvent("BWHydrossNilStop", nilStop, 3.5)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "HydrossSludge" and rest and self.db.profile.sludge then
		self:Message(fmt(L["sludge_message"], rest), "Attention")
		self:Bar(fmt(L["sludge_message"], rest), 24, "Spell_Nature_AbolishMagic")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "HydrossTomb" and not stop and rest then
		inTomb[rest] = true
		self:ScheduleEvent("BWTombWarn", self.TombWarn, 0.3, self)
	end
end
