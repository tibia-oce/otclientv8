local CODE = 91
local MAX_MATERIALS = 5
local window = nil
local categories = nil
local craftPanel = nil
local itemsList = nil

local selectedCategory = nil
local selectedCraftId = nil
local Crafts = {all = {}, alchemy = {}, armour = {}, weapons = {}, tools = {}}
local money = 0

function init()
    ProtocolGame.registerExtendedOpcode(CODE, onExtendedOpcode)
    connect(g_game, {onGameStart = create, onGameEnd = destroy})
    craftingButton = modules.client_topmenu.addRightGameToggleButton(
                         'craftingButton', tr('Crafting'),
                         '/game_crafting/images/crafting_button', toggle)
    if g_game.isOnline() then create() end
end

function terminate()
    disconnect(g_game, {onGameStart = create, onGameEnd = destroy})
    ProtocolGame.unregisterExtendedOpcode(CODE, onExtendedOpcode)
    destroy()
end

function create()
    if window then return end

    window = g_ui.displayUI("crafting")
    window:hide()

    categories = window:getChildById("categories")
    craftPanel = window:getChildById("craftPanel")
    itemsList = window:getChildById("itemsList")

    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        protocolGame:sendExtendedOpcode(CODE, json.encode({action = "fetch"}))
    end
end

function destroy()
    if window then
        categories = nil
        craftPanel = nil
        itemsList = nil

        selectedCategory = nil
        selectedCraftId = nil
        Crafts = {all = {}, alchemy = {}, armour = {}, weapons = {}, tools = {}}
        window:destroy()
        window = nil
    end
end

function toggle()
    if not window then return end
    if window:isVisible() then return hide() end
    show()
end

function onExtendedOpcode(protocol, code, buffer)
    local status, json_data = pcall(function() return json.decode(buffer) end)

    if not status then
        g_logger.error("[Crafting] JSON error: " .. data)
        return false
    end

    local action = json_data.action
    local data = json_data.data
    if action == "fetch" then
        for i = 1, #data.crafts do
            table.insert(Crafts[data.category], data.crafts[i])
        end
        if data.category == "all" then
            selectCategory("all")
            selectItem(1)
        end
    elseif action == "materials" then
        for i = 1, #data.materials do
            local material = data.materials[i]
            for x = 1, #material do
                local mats =
                    Crafts[data.category][data.from + i - 1].materials[x]
                if mats then mats.player = material[x] end
            end
        end
        if data.from == 1 and window:isVisible() and selectedCategory ==
            data.category then selectItem(selectedCraftId) end
    elseif action == "money" then
        money = data
        craftPanel:recursiveGetChildById("playerMoney"):setText(comma_value(
                                                                    money))
    elseif action == "show" then
        selectItem(selectedCraftId)
        show()
    elseif action == "crafted" then
        onItemCrafted()

    end
end

function onItemCrafted()
    if selectedCategory and selectedCraftId then
        local craft = Crafts[selectedCategory][selectedCraftId]
        if craft then
            for i = 1, #craft.materials do
                local materialWidget = craftPanel:getChildById("craftLine" .. i)
                materialWidget:setImageSource(
                    "/game_crafting/images/craft_line" .. i .. "on")
                scheduleEvent(function()
                    materialWidget:setImageSource(
                        "/game_crafting/images/craft_line" ..
                            (i == 2 and 5 or i))
                end, 850)
            end
            local button = craftPanel:getChildById("craftButton")
            button:disable()
            scheduleEvent(function() button:enable() end, 860)
        end
    end
end

function onSearch()
    scheduleEvent(function()
        local searchInput = window:recursiveGetChildById("searchInput")
        local text = searchInput:getText():lower()
        if text:len() >= 1 then
            local children = itemsList:getChildCount()
            for i = children, 1, -1 do
                local child = itemsList:getChildByIndex(i)
                local name = child:getChildById("name"):getText():lower()
                if name:find(text) then
                    child:show()
                    child:focus()
                    selectItem(i)
                else
                    child:hide()
                end
            end
        else
            local children = itemsList:getChildCount()
            for i = children, 1, -1 do
                local child = itemsList:getChildByIndex(i)
                child:show()
                child:focus()
                selectItem(i)
            end
        end
    end, 25)
end

function selectCategory(category)
    if selectedCategory then
        local oldCatBtn = categories:getChildById(selectedCategory .. "Cat")
        if oldCatBtn then oldCatBtn:setOn(false) end
    end

    local newCatBtn = categories:getChildById(category .. "Cat")
    if newCatBtn then
        newCatBtn:setOn(true)
        selectedCategory = category

        itemsList:destroyChildren()

        selectedCraftId = nil

        for i = 1, MAX_MATERIALS do
            local materialWidget = craftPanel:getChildById("material" .. i)
            if materialWidget then
                materialWidget:setItem(nil)
                local countWidget = craftPanel:getChildById("count" .. i)
                if countWidget then countWidget:setText("") end
            end
        end

        craftPanel:getChildById("craftOutcome"):setItem(nil)
        craftPanel:recursiveGetChildById("totalCost"):setText("")

        for i = 1, #Crafts[selectedCategory] do
            local craft = Crafts[selectedCategory][i]
            local w = g_ui.createWidget("ItemListItem")
            w:setId(i)
            w:getChildById("item"):setItemId(craft.clientId)
            w:getChildById("name"):setText(craft.name)
            w:getChildById("level"):setText("Required Level " .. craft.level)
            itemsList:addChild(w)

            if i == 1 then
                w:focus()
                selectItem(1)
            end
        end
    end
end

function selectItem(id)
    local craftId = tonumber(id)
    selectedCraftId = craftId
    local craft = Crafts[selectedCategory][craftId]

    -- Clear all material slots first
    for i = 1, MAX_MATERIALS do
        local materialWidget = craftPanel:getChildById("material" .. i)
        if materialWidget then
            materialWidget:setItem(nil)
            local countWidget = craftPanel:getChildById("count" .. i)
            if countWidget then countWidget:setText("") end
        end
    end

    -- Fill in actual materials
    if craft and craft.materials then
        for i = 1, #craft.materials do
            local material = craft.materials[i]
            local materialWidget = craftPanel:getChildById("material" .. i)
            if materialWidget then
                materialWidget:setItemId(material.id)
                local count = craftPanel:getChildById("count" .. i)
                if count then
                    count:setText(material.player .. "\n" .. material.count)
                    count:setColor(material.player >= material.count and
                                       "#FFFFFF" or "#FF0000")
                end
            end
        end
    end

    local outcome = craftPanel:getChildById("craftOutcome")
    outcome:setItemId(craft.clientId)
    outcome:setItemCount(craft.count)
    craftPanel:recursiveGetChildById("totalCost"):setText(
        comma_value(craft.cost))
end

function craftItem()
    if selectedCategory and selectedCraftId then
        local protocolGame = g_game.getProtocolGame()
        if protocolGame then
            protocolGame:sendExtendedOpcode(CODE, json.encode({
                action = "craft",
                data = {category = selectedCategory, craftId = selectedCraftId}
            }))
        end
    end
end

function show()
    if not window then return end
    window:show()
    window:raise()
    window:focus()
end

function hide()
    if not window then return end
    window:hide()
end

function comma_value(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1.%2")
        if (k == 0) then break end
    end
    return formatted
end
