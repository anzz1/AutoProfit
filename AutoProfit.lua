----------------------------------------------------------------
--	AutoProfit v4.00 (January 2018)
--	Written by Jason Allen.
--	Updated by kebabstorm.
----------------------------------------------------------------

autoProfitExceptions = { };
autoSell = 0;
autoSilent = 0;
totalProfit = 0;
rotation = 0;
rotrate = 0;
AUTOPROFIT_VERSION = "v4.00 January 1st, 2018";

local SILVER                        = "|c00C0C0C0";
local COPPER                        = "|c00CC9900";
local GOLD                          = "|c00FFFF66";

function SellJunk()

	local numOfSales = 0;
	
	for bag = 0, 4 do
	
		if GetContainerNumSlots(bag) > 0 then
		
			for slot = 0, GetContainerNumSlots(bag) do
			
				local texture, itemCount, locked, quality = GetContainerItemInfo(bag, slot);
				
				if (quality == 0) then
					local result = AutoSeller_ProcessLink(GetContainerItemLink(bag, slot));
					if (result > 0) then
						if (autoSilent == 0) then DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r: Sold " .. GetContainerItemLink(bag, slot) .. ((itemCount > 1) and ("x" .. itemCount .. ".") or "."), 0.0, .8, 1); end
						PickupContainerItem(bag, slot);
						MerchantItemButton_OnClick("LeftButton");
						numOfSales = numOfSales + itemCount;
					end
				end
				
				if (quality == -1) then
					local linkcolor = AutoSeller_ProcessLink(GetContainerItemLink(bag, slot));
					if (linkcolor == 1) then
						if (autoSilent == 0) then DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r: Sold " .. GetContainerItemLink(bag, slot) .. ((itemCount > 1) and ("x" .. itemCount .. ".") or "."), 0.0, .8, 1); end
						PickupContainerItem(bag, slot);
						MerchantItemButton_OnClick("LeftButton");
						numOfSales = numOfSales + itemCount;
					end
							
				end
				
			end
			
		end
		
	end
	
	if(numOfSales > 0) then
		DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r: Sold " .. numOfSales .. ((numOfSales == 1) and " item" or " items") .. " for " .. setAmountString(totalProfit) .. ".", 0.0, .8, 1);
	end
		
end

function AutoProfit_OnLoad()
	SLASH_AUTOPROFIT1 = "/autoprofit";
	SLASH_AUTOPROFIT2 = "/ap";
	SlashCmdList["AUTOPROFIT"] = AutoProfit_SlashCmd;
end

function AutoProfit_Calculate()

	for bag = 0, 4 do
	
		if GetContainerNumSlots(bag) > 0 then
		
			for slot = 0, GetContainerNumSlots(bag) do
			
				local texture, itemCount, locked, quality = GetContainerItemInfo(bag, slot);
				
				if (quality == 0) then
					local result = AutoSeller_ProcessLink(GetContainerItemLink(bag, slot));
					if (result > 0) then
					AutoProfit_Tooltip:SetBagItem(bag, slot);
					end
				end
				
				if (quality == -1) then
					local linkcolor = AutoSeller_ProcessLink(GetContainerItemLink(bag, slot));
					if (linkcolor == 1) then
						AutoProfit_Tooltip:SetBagItem(bag, slot);
					end
							
				end
								
			end
			
		end
	end
	
	
end

function AutoProfit_AddCoin()

	if (arg1) then
		totalProfit = totalProfit + arg1;
	end
end

function AutoProfit_RotateModel(elapsed)

if (rotrate > 0) then rotation = rotation + (elapsed * rotrate); end

TreasureModel:SetRotation(rotation);

end;


function AutoProfit_SlashCmd(msg)

	--No switch statement in Lua? Lots of ugly if's to follow.
		
	if (msg == "") then
		DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r " .. AUTOPROFIT_VERSION .. " by Jason Allen & kebabstorm.", 0.0, .80, 1);
		DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/autoprofit [item link]|r: Add or remove an item to the exception list.", 0.0, .80, 1);
		DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/autoprofit list|r: List all items on your exception list.", 0.0, .80, 1);
		DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/autoprofit [number]|r: Remove item at that location in your exception list.", 0.0, .80, 1);
		DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/autoprofit purge|r: Remove all items from your exception list.", 0.0, .80, 1);
		DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/autoprofit silent|r: Toggles sale reporting on and off.", 0.0, .80, 1);
		DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/autoprofit auto|r: Toggles automatic selling on and off.", 0.0, .80, 1);
		return;
	end
	
	if (msg == "purge") then
		autoProfitExceptions = { };
		DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r: Deleted all exceptions.", 0.0, .80, 1);
		return;
	end
	
	if (msg == "auto") then
		if (autoSell == 0) then
			DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r: Automatic selling on.", 0.0, .80, 1);
			autoSell = 1;
		else
			DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r: Automatic selling off.", 0.0, .80, 1);
			autoSell = 0;
			AutosellButton:Show();
			TreasureModel:Show();
		end
		return;
	end
	
	if (msg == "silent") then
		if (autoSilent == 0) then
			DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r: Sale reporting off.", 0.0, .80, 1);
			autoSilent = 1;
		else
			DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r: Sale reporting on.", 0.0, .80, 1);
			autoSilent = 0;
		end
		return;
	end
	
	if (msg == "list") then
		if (table.getn(autoProfitExceptions) > 0) then
			DEFAULT_CHAT_FRAME:AddMessage("AutoProfit Exceptions: ", 0.0, .80, 1);
			for i=1,table.getn(autoProfitExceptions) do
				DEFAULT_CHAT_FRAME:AddMessage("[|c00bfffff" .. i .. "|r] " .. autoProfitExceptions[i], 0.0, .80, 1);
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r: Your exceptions list is empty.", 0.0, .80, 1);
		end
		return;
	end
	
	if (string.len(msg) < 6) then
	
		if (tonumber(msg) == nil) then return; end
	
		if (tonumber(msg) > table.getn(autoProfitExceptions)) then 
			return;
		else
			DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r: Removed " .. autoProfitExceptions[tonumber(msg)] .. " from exceptions list.", 0.0, .8, 1);
			table.remove(autoProfitExceptions, tonumber(msg));
			return;
		end
	end
		
		if (string.find(msg, "Hitem:") == nil) then return; end
		
		local removed = 0;
		
		if (table.getn(autoProfitExceptions) > 0) then
				
			for i=1,table.getn(autoProfitExceptions) do
				
				if (msg == autoProfitExceptions[i]) then
					DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r: Removed " .. autoProfitExceptions[i] .. " from exceptions list.", 0.0, .8, 1);
					table.remove(autoProfitExceptions, i);
					removed = 1;
				end
			end
		end
		
		if (removed == 0) then
			table.insert(autoProfitExceptions, msg);
			DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffAutoProfit|r: Added " .. msg .. " to exceptions list.", 0.0, .8, 1);
		end
	
	

end


function AutoSeller_ProcessLink(link)

	local color;
	local item;
	local name;
	
	for color, item, name in string.gfind(link, "|c(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r") do
		
		--This prevents Dark Moon Faire items from being sold to the vendor.
		if ((name == "Small Furry Paw") or (name == "Torn Bear Pelt") or (name == "Soft Bushy Tail") or (name == "Vibrant Plume") or (name == "Evil Bat Eye") 
			or (name == "Glowing Scorpid Blood")) then
			return 0;
		end		
		
		if (color == "ff9d9d9d") then
			for i=1,table.getn(autoProfitExceptions) do
				
				if (link == autoProfitExceptions[i]) then
					return 0;
				end
			end
			
	
			return 1;
		end
		
		if (color == "ffffffff") then
			for i=1,table.getn(autoProfitExceptions) do
				
				if (link == autoProfitExceptions[i]) then

					return 1;
				end
			end
			
			return 0;
		end
		
		return 0;
	end
	
end

function setAmountString(amt, sep)
    local str = "";
    local gold, silver, copper;

    if (amt == 0) then
		str = "none";	
		return str;
    end
    if ( not sep ) then sep = " " end;
    
    copper = mod(floor(amt + .5),      100);
    silver = mod(floor(amt/100),       100);
    gold   = mod(floor(amt/(100*100)), 100);
    
    if ( gold   > 0 ) then str = GOLD .. gold .. " gold" end;
    if ( silver > 0 ) then
        if ( str ~= "" ) then str = str .. sep end;
        str = str .. SILVER .. silver .. " silver";
    end;
    if ( copper > 0 ) then
        if ( str ~= "" ) then str = str .. sep end;
        str = str .. COPPER .. copper .. " copper";
    end;
    
    str = str .. "|r";

    return str;
end
