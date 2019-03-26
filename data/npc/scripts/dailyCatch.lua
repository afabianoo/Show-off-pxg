function onCreatureTurn(creature)
end

function msgcontains(txt, str)
	return (string.find(txt, str) and not string.find(txt, '(%w+)' .. str) and not string.find(txt, str .. '(%w+)'))
end

local focus = 0
local talk_start = 0
local talkState = {}
local opcao1 = "";
local opcao2 = "";
local opcaoEscolhida = "";
local tchau = false
local stor = 6723421

local msgsExit = {
"Até logo.",
"Até mais..",
"Adeus..",
"Volte mais tarde...",
}

function onCreatureSay(cid, type, msg)
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	local objetos = getListOfObjectsByDifficulty(cid)
	
	if not (getDistanceToCreature(cid) <= 3) then
		return true
	end
	
	if getPlayerStorageValue(cid, objetos.storages.endQuest) >= 1 then
		selfSay("Você já completou minha task por hoje.", cid)
		tchau = true
		focus = 0
		talkState[talkUser] = 0
		return true	
	end   
	
	if msgcontains(msg, "hi") then
		if focus ~= 0 then
			selfSay(getCreatureName(cid) .. ' aguarde sua vez...')
			tchau = true
			return true
		elseif getPlayerStorageValue(cid, objetos.storages.catch) < 1 then
			selfSay("Você deseja capturar pokémons?", cid)
			focus = cid
			talk_start = os.clock()
			talkState[talkUser] = 1 
		end
	end
	if msgcontains(msg, "yes") and talkState[talkUser] == 1 and getPlayerStorageValue(cid, stor) < 1 then
		setTaskDailyCatch(cid, objetos) 
		opcao1 = getPokemonForDailyCatch(cid, "opcao_poke1");
		opcao2 = getPokemonForDailyCatch(cid, "opcao_poke2");
		selfSay("Catch de nível "..getDificultyForDailyCatch(cid)..", deseja capturar "..opcao1.." ou "..opcao2.."?", cid)
		talkState[talkUser] = 2;
	elseif (msgcontains(msg, opcao1) or msgcontains(msg, opcao2)) and talkState[talkUser] == 2 then
		opcaoEscolhida = msg;
		setPokemonEscolhido(cid, opcaoEscolhida)
		selfSay("Okay, volte quando conseguir capturar "..getPokemonForDailyCatch(cid, "poke_escolhido").."!", cid)
		setPlayerStorageValue(cid, objetos.storages.catch, 1)
		tchau = true
		focus = 0
		talkState[talkUser] = 0
		setPlayerStorageValue(cid, stor, 1)
	 
	elseif  (msgcontains(msg, "hi") or (msgcontains(msg, "yes") and talkState[talkUser] == 1)) and getPlayerStorageValue(cid, objetos.storages.catch) >= 1 then
	   selfSay("Você conseguiu capturar "..getPokemonForDailyCatch(cid, "poke_escolhido").."?", cid)
	   talkState[talkUser] = 4;  
	   
	elseif msgcontains(msg, "yes") and talkState[talkUser] == 4 then
		if (getPlayerStorageValue(cid, objetos.storages.catchSucess) >= 1) then
			for a, i in pairs(objetos.recompensa) do
				doPlayerAddItem(cid, i[1], i[2])
			end
			doPlayerAddExp(cid, objetos.experiencia);
			doSendAnimatedText(getThingPos(cid), objetos.experiencia, 173)
			doSendMagicEffect(getThingPos(cid), 173) 
			setPlayerStorageValue(cid, objetos.storages.endQuest, 1)
			dificilPokesParaDailyCatch(cid, getDificultyForDailyCatch(cid))
			addOpcaoForChoosePokemonDailyCatch(cid, objetos.pokes)
			setPlayerStorageValue(cid, stor, 0)
			selfSay("Parabéns, pegue sua recompensa", cid)
		else
			selfSay("Você ainda não capturou ".. getPokemonForDailyCatch(cid, "poke_escolhido") ..".", cid)
		end
		tchau = true
		focus = 0
		talkState[talkUser] = 0
		return true	
	end
	
	if msgcontains(msg, "no") or msgcontains(msg, "bye") then
		talkState[talkUser] = 0
		tchau = true
		focus = 0
		return true	
	end
	
	return true
end

function onThink()
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0
	if focus ~= 0 then
		if getDistanceToCreature(focus) > 3 then
			tchau = true
			focus = 0
		end
		if (os.clock() - talk_start) > 15 then
			if focus > 0 then
				tchau = true
				focus = 0
			end
		end
		doNpcSetCreatureFocus(focus)
	end
		
		if tchau then
			tchau = false
			selfSay(msgsExit[math.random(#msgsExit)])
			talkState[talkUser] = 0
		end
end