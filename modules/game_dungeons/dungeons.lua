local CODE = 109

local window = nil
local windowButton = nil
local dungeonInfo = nil
local killCounter = nil
local challengeNotifi = nil

local Dungeons = {}
local selectedDungeonId = 1
local selectedDifficulty = 1
local queueTime = 0
local timerEvent = nil
local timeLeft = 0
local timeLeftEvent = nil

function init()
  ProtocolGame.registerExtendedOpcode(CODE, onExtendedOpcode)
  connect(
    g_game,
    {
      onGameStart = create,
      onGameEnd = destroy
    }
  )
  if g_game.isOnline() then
    create()
  end
end

function terminate()
  disconnect(
    g_game,
    {
      onGameStart = create,
      onGameEnd = destroy
    }
  )

  ProtocolGame.unregisterExtendedOpcode(CODE, onExtendedOpcode)

  destroy()
end

function create()
  if window then
    return
  end
  window = g_ui.displayUI("dungeons")
  window:hide()
  windowButton = modules.client_topmenu.addRightGameToggleButton("dungeonsButton", tr("Dungeons Finder"), "/game_dungeons/images/dungeon", toggle)
  windowButton:setOn(false)

  killCounter = g_ui.loadUI("killcounter", modules.game_interface.getMapPanel())
  killCounter:hide()

  challengeNotifi = g_ui.loadUI("challenge", modules.game_interface.getMapPanel())
  g_effects.fadeOut(challengeNotifi, 1)

  dungeonInfo = window:getChildById("dungeonInfo")

  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    protocolGame:sendExtendedOpcode(CODE, json.encode({action = "fetch"}))
  end
end

function destroy()
  if windowButton then
    windowButton:destroy()
    windowButton = nil
  end

  if window then
    if timerEvent then
      removeEvent(timerEvent)
    end
    timerEvent = nil
    dungeonInfo = nil
    selectedDungeonId = 1
    selectedDifficulty = 1
    queueTime = 0
    Dungeons = {}

    if timeLeftEvent then
      removeEvent(timeLeftEvent)
    end
    timeLeftEvent = nil
    timeLeft = 0

    window:destroy()
    window = nil
  end

  if killCounter then
    killCounter:destroy()
    killCounter = nil
  end

  if challengeNotifi then
    challengeNotifi:destroy()
    challengeNotifi = nil
  end
end

function onExtendedOpcode(protocol, code, buffer)
  if not g_game.isOnline() then
    return
  end
  local json_status, json_data =
    pcall(
    function()
      return json.decode(buffer)
    end
  )

  if not json_status then
    g_logger.error("[Dungeons] JSON error: " .. json_data)
    return false
  end

  local action = json_data.action
  local data = json_data.data

  if action == "list" then
    onDungeonsList(data)
  elseif action == "dungeon" then
    onDungeonData(data)
  elseif action == "solo" then
    onSoloRunners(data)
  elseif action == "group" then
    onGroupRunners(data)
  elseif action == "queue" then
    onDungeonQueue(data)
  elseif action == "prepare" then
    onDungeonPrepare()
  elseif action == "start" then
    onDungeonStart(data)
  elseif action == "finish" then
    onDungeonFinish(data)
  elseif action == "objective" then
    onDungeonObjective(data)
  elseif action == "killed" then
    onDungeonKilled(data)
  elseif action == "queueUpdate" then
    onDungeonQueueUpdate(data)
  elseif action == "difficulty" then
    onDungeonDifficulty(data)
  elseif action == "challenge" then
    onChallengeCompleted(data)
  elseif action == "stopQueue" then
    onStopQueue()
  end
end

function onDungeonsList(data)
  local dungeonsMenus = window:getChildById("dungeonsMenu")
  dungeonsMenus.onChildFocusChange = onDungeonSelected

  dungeonsMenus:destroyChildren()
  table.sort(
    data,
    function(a, b)
      return a.level < b.level
    end
  )
  local dungeonMenu = nil
  for i = 1, #data do
    local dungeon = data[i]
    dungeonMenu = g_ui.createWidget("DungeonMenuItem", dungeonsMenus)
    dungeonMenu:setId("dungeon" .. dungeon.id)
    local boss = dungeonMenu:getChildById("boss")
    local title = dungeonMenu:getChildById("title")
    local level = dungeonMenu:getChildById("level")
    local queue = dungeonMenu:getChildById("queue")
    boss:setOutfit(dungeon.boss)
    title:setText(dungeon.title)
    level:setText(dungeon.level .. "+ Level")
    queue:setText("Queue: " .. (dungeon.queue == 0 and "Open" or dungeon.queue .. " Players"))
    if dungeon.queue >= 6 then
      queue:setColor("red")
    elseif dungeon.queue >= 3 then
      queue:setColor("orange")
    else
      queue:setColor("green")
    end
    dungeonMenu = nil
  end
end

function onDungeonData(data)
  table.insert(Dungeons, data)
end

function onSoloRunners(data)
  local runners = data.top
  local dungeonId = data.id
  local difficulty = data.diff

  local dungeon = Dungeons[dungeonId]
  if not dungeon.solo then
    dungeon.solo = {}
  end
  dungeon.solo[difficulty] = runners
end

function onGroupRunners(data)
  local runners = data.top
  local dungeonId = data.id
  local difficulty = data.diff

  local dungeon = Dungeons[dungeonId]
  if not dungeon.group then
    dungeon.group = {}
  end
  dungeon.group[difficulty] = runners
end

function onDungeonSelected(parent, child, reason)
  local dungeonId = tonumber(child:getId():sub(8, child:getId():len()))
  selectDungeon(dungeonId)
end

function selectDungeon(dungeonId)
  local dungeon = Dungeons[dungeonId]
  if dungeon then
    selectedDungeonId = dungeonId

    -- Banner (dungeon.title has to match the image name in game_dungeons/images/)
    dungeonInfo:getChildById("banner"):setImageSource("/game_dungeons/images/banners/" .. dungeon.title:lower())

    -- Difficulties
    local difficultiesPanel = dungeonInfo:getChildById("difficulties")
    difficultiesPanel:focusChild(difficultiesPanel:getChildByIndex(1))
    for i = 2, 6 do
      local diffWidget = difficultiesPanel:getChildByIndex(i)
      if dungeon.difficulty < i then
        diffWidget:disable()
        diffWidget:getChildById("lockBg"):show()
        diffWidget:getChildById("lockImg"):show()
      else
        diffWidget:enable()
        diffWidget:getChildById("lockBg"):hide()
        diffWidget:getChildById("lockImg"):hide()
      end
    end

    -- Requirements
    local reqTable = {
      "level",
      "party",
      "iLvl",
      "gold",
      "quests",
      "items"
    }
    local requirementsPanel = dungeonInfo:getChildById("requirements")

    for i = 1, #reqTable do
      if reqTable[i] == "items" then
        if dungeon.req.items then
          local found = false
          for x = 1, 6 do
            if dungeon.req.items[x] then
              found = true
              break
            end
          end
          local widgetParent = requirementsPanel:getChildByIndex(i)
          if not found then
            widgetParent:disable()
          else
            widgetParent:enable()
          end
        else
          local widgetParent = requirementsPanel:getChildByIndex(i)
          widgetParent:disable()
        end
      else
        local widgetParent = requirementsPanel:getChildByIndex(i)
        if not dungeon.req[reqTable[i]] then
          widgetParent:disable()
        else
          widgetParent:enable()
        end
      end
    end

    for key, value in pairs(dungeon.req) do
      local widget = requirementsPanel:recursiveGetChildById(key)
      if widget then
        if key == "gold" then
          widget:setText(comma_value(value))
        elseif key == "items" then
          for i = 1, #value do
            local slot = widget:getChildByIndex(i)
            local reqItem = value[i]
            slot:setItemId(reqItem.clientId)
            slot:setItemCount(reqItem.count)
          end
        elseif key == "quests" then
          local txt = ""
          for i = 1, #value do
            txt = txt .. value[i]
            if i > 1 and i == #value then
              txt = txt .. "."
            elseif #value > 1 then
              txt = txt .. ", "
            end
          end
          widget:setText(txt)
        else
          widget:setText(value)
        end
      end
    end

    -- Boss Loot
    local bossLootPanel = dungeonInfo:getChildById("bossLoot")
    for i = 1, 28 do
      local slot = bossLootPanel:getChildByIndex(i)
      if dungeon.loot[i] then
        local loot = dungeon.loot[i]
        slot:setItemId(loot.clientId)
        slot:setItemCount(loot.count)
      else
        slot:setItem(nil)
      end
    end

    -- Queue
    local queueStatus = dungeonInfo:recursiveGetChildById("queueStatus")
    local queuePlayers = dungeon.queue.players
    queueStatus:setText(queuePlayers == 0 and "Open" or queuePlayers .. " Players")
    if queuePlayers >= 6 then
      queueStatus:setColor("red")
    elseif queuePlayers >= 3 then
      queueStatus:setColor("orange")
    else
      queueStatus:setColor("green")
    end
    dungeonInfo:recursiveGetChildById("queueTime"):setText(SecondsToShortTime(dungeon.queue.estimated / 1000))
    dungeonInfo:recursiveGetChildById("queueWaiting"):setText("00:00:00")

    -- Challenges
    local challengesPanel = dungeonInfo:getChildById("challenges")
    challengesPanel:destroyChildren()
    -- todo(dungeons): implemented on serverside but needs to be extended.
    -- for i = 1, #dungeon.challenges do
    --   local challenge = dungeon.challenges[i]
    --   local widget = g_ui.createWidget("ChallengePanel", challengesPanel)
    --   widget:setText(challenge.title .. " (" .. challenge.points .. " Points)")
    --   widget:getChildById("checkbox"):setChecked(challenge.completed)
    --   widget:getChildById("description"):setText(challenge.desc)
    -- end

    onDifficultyFocus(1, true)
  end
end

function onDifficultyFocus(difficultyId, focused)
  if focused then
    local dungeon = Dungeons[selectedDungeonId]
    if dungeon then
      selectedDifficulty = difficultyId
      -- Solo
      local soloTable = window:recursiveGetChildById("soloTable")
      soloTable:clearData()
      if dungeon.solo and dungeon.solo[difficultyId] then
        for i = 1, #dungeon.solo[difficultyId] do
          local runner = dungeon.solo[difficultyId][i]

          if runner.self then
            soloTable:addRow(
              {
                {text = runner.self},
                {text = runner.name},
                {text = MsToShortTime(runner.time)}
              },
              nil,
              "#2daadb"
            )
          else
            soloTable:addRow(
              {
                {text = i},
                {text = runner.name},
                {text = MsToShortTime(runner.time)}
              }
            )
          end
        end
      end

      local groupTable = window:recursiveGetChildById("groupTable")
      groupTable:clearData()
      -- Group
      if dungeon.group and dungeon.group[difficultyId] then
        for i = 1, #dungeon.group[difficultyId] do
          local group = dungeon.group[difficultyId][i]
          local names = select(2, string.gsub(group.name, "\n", ""))
          local height = names * 21
          if names == 1 then
            height = height + 8
          end

          if group.self then
            groupTable:addRow(
              {
                {text = group.self},
                {text = group.name},
                {text = MsToShortTime(group.time)}
              },
              height,
              "#2daadb"
            )
          else
            groupTable:addRow(
              {
                {text = i},
                {text = group.name},
                {text = MsToShortTime(group.time)}
              },
              height
            )
          end
        end
      end
    end
  end
end

function joinQueue()
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    protocolGame:sendExtendedOpcode(CODE, json.encode({action = "queue", data = {id = selectedDungeonId, difficulty = selectedDifficulty}}))
  end
end

function onDungeonQueue(data)
  local queueWaiting = dungeonInfo:recursiveGetChildById("queueWaiting")
  queueWaiting:setText("00:00:00")
  queueTime = 0

  local queueDungeon = dungeonInfo:recursiveGetChildById("queueDungeon")
  local queueButton = dungeonInfo:recursiveGetChildById("queueButton")
  if data.joined then
    queueButton:setText("Leave")
    queueDungeon:setText(Dungeons[data.id].title)
    timerEvent = scheduleEvent(queueTimer, 1000)
  else
    queueButton:setText("Join")
    queueDungeon:setText("------")
    if timerEvent then
      removeEvent(timerEvent)
      timerEvent = nil
    end
  end
end

function onStopQueue()
  local queueWaiting = dungeonInfo:recursiveGetChildById("queueWaiting")
  queueWaiting:setText("00:00:00")
  queueTime = 0

  local queueDungeon = dungeonInfo:recursiveGetChildById("queueDungeon")
  local queueButton = dungeonInfo:recursiveGetChildById("queueButton")
  queueButton:setText("Join")
  queueDungeon:setText("------")
  if timerEvent then
    removeEvent(timerEvent)
    timerEvent = nil
  end
end

function queueTimer()
  local queueWaiting = dungeonInfo:recursiveGetChildById("queueWaiting")
  queueTime = queueTime + 1
  queueWaiting:setText(SecondsToShortTime(queueTime))
  timerEvent = scheduleEvent(queueTimer, 1000)
end

function onDungeonPrepare()
  onStopQueue()
  if window:isVisible() then
    toggle()
  end
end

function onDungeonStart(data)
  local queueWaiting = dungeonInfo:recursiveGetChildById("queueWaiting")
  queueWaiting:setText("00:00:00")
  queueTime = 0

  local queueDungeon = dungeonInfo:recursiveGetChildById("queueDungeon")
  local queueButton = dungeonInfo:recursiveGetChildById("queueButton")
  queueButton:setText("Join")
  queueDungeon:setText("------")
  if timerEvent then
    removeEvent(timerEvent)
    timerEvent = nil
  end
  killCounter:show()

  local bonusObjectives = killCounter:getChildById("bonusObjectives")
  for i = bonusObjectives:getChildCount(), 2, -1 do
    bonusObjectives:getChildByIndex(i):destroy()
  end
  if data.objectives then
    local h = 16
    for _, obj in ipairs(data.objectives) do
      local w = g_ui.createWidget("ObjectiveCheckBox", bonusObjectives)
      w:addAnchor(AnchorTop, "prev", AnchorBottom)
      w:setMarginTop(5)
      w:setText(obj)
      h = h + 25
    end
    bonusObjectives:setHeight(h)
    bonusObjectives:setMarginTop(5)
    killCounter:setHeight(170 + h)
  else
    bonusObjectives:setHeight(0)
    bonusObjectives:setMarginTop(0)
    killCounter:setHeight(170)
  end

  local bar = killCounter:getChildById("bar")

  killCounter:getChildById("label"):setText("0%")
  local mainObjective = killCounter:getChildById("mainObjective")
  mainObjective:setText("Kill monsters to spawn " .. data.boss)
  mainObjective:setChecked(false)
  local bossObjective = killCounter:getChildById("bossObjective")
  bossObjective:setText("Kill " .. data.boss)
  bossObjective:setEnabled(false)
  bossObjective:setChecked(false)
  killCounter:getChildById("monstersLeft"):setText("Monsters Remaining:  " .. data.left)
  killCounter:getChildById("timeLeft"):setText("Time Left:  " .. MsToShortTime(data.duration))

  timeLeft = data.duration
  timeLeftEvent = scheduleEvent(doTimeLeft, 100)
end

function doTimeLeft()
  timeLeft = timeLeft - 100
  killCounter:getChildById("timeLeft"):setText("Time Left: " .. MsToShortTime(timeLeft))
  if timeLeft > 0 then
    timeLeftEvent = scheduleEvent(doTimeLeft, 100)
  end
end

function onDungeonFinish(data)
  killCounter:hide()
  if timeLeftEvent then
    removeEvent(timeLeftEvent)
  end
end

function onDungeonObjective(data)
  local bonusObjectives = killCounter:getChildById("bonusObjectives")
  local objWidget = bonusObjectives:getChildByIndex(data.id + 1)
  objWidget:setChecked(data.finished)
end

function onDungeonKilled(data)
  local bar = killCounter:getChildById("bar")
  local bossObjective = killCounter:getChildById("bossObjective")
  if data.percent then
   local percent = math.min(100, data.percent)
        local maxWidth = 270  
        local maxHeight = 50  
        local newWidth = maxWidth * (percent / 100)
        local newHeight = maxHeight
        bar:setWidth(newWidth)
        bar:setHeight(newHeight)
    killCounter:getChildById("label"):setText(math.min(100, data.percent) .. "%")
    if data.percent >= 100 then
      killCounter:getChildById("mainObjective"):setChecked(true)
      bossObjective:setEnabled(true)
	  local textWidget = challengeNotifi:getChildById("text")
  textWidget:setText("You can kill the boss now!")
  challengeNotifi:setWidth(math.max(263, 96 + textWidget:getTextSize().width))
  g_effects.fadeIn(challengeNotifi, 250)
  scheduleEvent(
    function()
      if challengeNotifi then
        g_effects.fadeOut(challengeNotifi, 250)
      end
    end,
    3000
  )
    end
  elseif data.boss then
    bossObjective:setChecked(true)
	local textWidget = challengeNotifi:getChildById("text")
  textWidget:setText("You completed the dungeon!")
  challengeNotifi:setWidth(math.max(263, 96 + textWidget:getTextSize().width))
  g_effects.fadeIn(challengeNotifi, 250)
  scheduleEvent(
    function()
      if challengeNotifi then
        g_effects.fadeOut(challengeNotifi, 250)
      end
    end,
    3000
  )
  end
  if data.left then
    killCounter:getChildById("monstersLeft"):setText("Monsters Alive: " .. data.left)
  end
end

function onDungeonDifficulty(data)
  local dungeon = Dungeons[data.id]
  if dungeon then
    dungeon.difficulty = data.difficulty
    if selectedDungeonId and selectedDungeonId == data.id then
      local difficultiesPanel = dungeonInfo:getChildById("difficulties")
      for i = 2, 6 do
        local diffWidget = difficultiesPanel:getChildByIndex(i)
        if dungeon.difficulty < i then
          diffWidget:disable()
          diffWidget:getChildById("lockBg"):show()
          diffWidget:getChildById("lockImg"):show()
        else
          diffWidget:enable()
          diffWidget:getChildById("lockBg"):hide()
          diffWidget:getChildById("lockImg"):hide()
        end
      end
    end
  end
end

function onDungeonQueueUpdate(data)
  local dungeon = Dungeons[data.id]
  if dungeon then
    dungeon.queue.players = data.queue
    dungeon.queue.estimated = data.estimated
  end

  local dungeonsMenus = window:getChildById("dungeonsMenu")
  local menuDungeon = dungeonsMenus:getChildById("dungeon" .. data.id)
  local queue = menuDungeon:getChildById("queue")
  local queuePlayers = data.queue
  queue:setText("Queue: " .. (queuePlayers == 0 and "Open" or queuePlayers .. " Players"))
  if queuePlayers >= 6 then
    queue:setColor("red")
  elseif queuePlayers >= 3 then
    queue:setColor("orange")
  else
    queue:setColor("green")
  end
  if selectedDungeonId == data.id then
    local queueStatus = dungeonInfo:recursiveGetChildById("queueStatus")
    queueStatus:setText(queuePlayers == 0 and "Open" or queuePlayers .. " Players")
    if queuePlayers >= 6 then
      queueStatus:setColor("red")
    elseif queuePlayers >= 3 then
      queueStatus:setColor("orange")
    else
      queueStatus:setColor("green")
    end
    dungeonInfo:recursiveGetChildById("queueTime"):setText(SecondsToShortTime(dungeon.queue.estimated / 1000))
  end
end

function onChallengeCompleted(data)
  local textWidget = challengeNotifi:getChildById("text")
  textWidget:setText(data .. " challenge completed!")
  challengeNotifi:setWidth(math.max(263, 96 + textWidget:getTextSize().width))
  g_effects.fadeIn(challengeNotifi, 250)
  scheduleEvent(
    function()
      if challengeNotifi then
        g_effects.fadeOut(challengeNotifi, 250)
      end
    end,
    3000
  )
end

function getKillCounter()
  return killCounter
end

function toggle()
  if not window then
      return
  end
  if window:isVisible() then
      return hide()
  end
  show()
end

function show()
  if not window or not windowButton then
    return
  end
  local dungeonsMenus = window:getChildById("dungeonsMenu")
  dungeonsMenus:focusChild(dungeonsMenus:getChildByIndex(1))
  window:show()
  window:raise()
  window:focus()
end

function hide()
  if not window then
    return
  end
  window:hide()
end

function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1.%2")
    if (k == 0) then
      break
    end
  end
  return formatted
end

function SecondsToShortTime(seconds)
  if seconds <= 0 then
    return "00:00:00"
  else
    local hours = string.format("%02.f", math.floor(seconds / 3600))
    local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
    local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))
    return hours .. ":" .. mins .. ":" .. secs
  end
end

function MsToShortTime(ms)
  if ms <= 0 then
    return "00:00.000"
  else
    local mins = string.format("%02.f", math.floor(ms / 1000 / 60))
    local secs = string.format("%02.f", math.floor(ms / 1000 % 60))
    local millis = string.format("%d", (ms % 1000) / 100)
    return mins .. ":" .. secs .. "." .. millis
  end
end
