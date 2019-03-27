pokemonsDailyCatch = {
	["facil"] = {
		pokes = {"Electrode", "Beedrill", "Kadrabra", "Hypno", "Haunter", "Tauros", "Marowak", "Victribell", "Vileplume", "Onix", "Venomoth", "Persian", "Tangela", "Pikachu", "Fearow", "Weezing", "Parasect", "Premiape", "Golbat", "Dugtrio", "Muk", "Arbok"}, 
		experiencia = 100000,
		recompensa = {{2160, 1}},
		storages = {
			catch = 201610181230,
			catchSucess = 201610181231,
			beginQuest = 201610181233,
			endQuest = 201610181234
		}
	},
	["medio"]  = {
		pokes = {"Nidoqueen", "Nidoking", "Ninetales", "Golem", "Tentacruel", "Pidgeot", "Sandslash", "Golduck", "Clefable", "Wigglytuff", "Victribell", "Vileplume", "Poliwrath", "Dewgong", "Cloyster", "Starmie", "Muk"},
		experiencia = 200000,
		recompensa = {{2160, 1}, {15645, 2}},
		storages = {
			catch = 201610181235,
			catchSucess = 201610181236,
			beginQuest = 201610181237,
			endQuest = 201610181238
		}
	},
	["dificil"]   = {
		pokes = {"Alakazam", "Gengar", "Charizard", "Rhydon", "Venusaur", "Blastoise", "Raichu", "Machamp", "Nidoqueen", "Nidoking", "Ninetales", "Golem", "Tentacruel", "Poliwrath", "Dewgong", "Starmie"},
		experiencia = 300000,	
		recompensa = {{2160, 1}, {15645, 3}},
		storages = {
			catch = 201610181239,
			catchSucess = 201610181240,
			beginQuest = 201610181241,
			endQuest = 201610181242
		}
	},
	["muitoDificil"]   = {
		pokes = {"Magmar", "Electabuzz", "Lapras", "Jynx", "Dragonite", "Scyther", "Lickitung", "Dragonair", "Kangaskhan", "Kabutops", "Omastar", "Mr. Mime", "Gyarados", "Hitmonchan", "Hitmonlee", "Snorlax","Alakazam", "Gengar", "Charizard", "Rhydon", "Venusaur", "Blastoise", "Raichu", "Machamp"},
		experiencia = 400000,
		recompensa = {{2160, 1}, {15645, 4}, {15646, 1}},
		storages = {
			catch = 201610181243,
			catchSucess = 201610181244,
			beginQuest = 201610181245,
			endQuest = 201610181246
		}
	}
};

function resetStoragesDailyCatch(cid)
	local storages = {
		201610181230,
		201610181231,
		201610181233,
		201610181234,
		201610181235,
		201610181236,
		201610181237,
		201610181238,
		201610181239,
		201610181240,
		201610181241,
		201610181242,
		201610181243,
		201610181244,
		201610181245,
		201610181246
	};
	for x = 1, #storages do
		setPlayerStorageValue(cid, storages[x], 0)
	end
end


function initializeDailyCatch(cid)
	local storage = 293831142
	local dia = 60*60*24 --  1 dia
	if (getPlayerStorageValue(cid, storage) <= os.time()) then 
		resetStoragesDailyCatch(cid)
		deleteRegisterByNickPlayer(cid);
		insertDificuldadeInicialDailyCatch(cid, "facil");
		setPlayerStorageValue(cid, storage, os.time()+dia)
	end
end

function getListOfObjectsByDifficulty(cid)
	return pokemonsDailyCatch[getDificultyForDailyCatch(cid)];
end

function setPokemonAleatorio(pokemons)
	return pokemons[math.random(#pokemons)];
end

function insertDificuldadeInicialDailyCatch(cid, dif)
	db.executeQuery("INSERT INTO `player_daily_catch` (player_name, dificuldade) VALUES ('" .. getCreatureName(cid) .. "', '"..dif.."')");
end

function getDificultyForDailyCatch(cid)
	return db.getResult("SELECT `dificuldade` FROM `player_daily_catch` WHERE `player_name` = '" .. getCreatureName(cid) .. "'"):getDataString("dificuldade");
end

function addOpcaoForChoosePokemonDailyCatch(cid, pokeArray)
	local pokeOpcao1 = setPokemonAleatorio(pokeArray);
	local pokeOpcao2 = setPokemonAleatorio(pokeArray);
	while(pokeOpcao1 == pokeOpcao2) do
		pokeOpcao2 = setPokemonAleatorio(pokeArray);
	end
	db.executeQuery("UPDATE `player_daily_catch` SET `opcao_poke1` = '"..pokeOpcao1.."', `opcao_poke2` = '"..pokeOpcao2.."' WHERE `player_name` = '".. getCreatureName(cid) .."';")
end

function setDificuldadeInicialDailyCatch(cid, dif)
	db.executeQuery("UPDATE `player_daily_catch` SET `dificuldade` = '"..dif.."' WHERE `player_name` = '".. getCreatureName(cid) .."';")
end

function setPokemonEscolhido(cid, poke)
	db.executeQuery("UPDATE `player_daily_catch` SET `poke_escolhido` = '"..poke.."' WHERE `player_name` = '".. getCreatureName(cid) .."';")
end


function getPokemonForDailyCatch(cid, coluna)
	return db.getResult("SELECT `"..coluna.."` FROM `player_daily_catch` WHERE `player_name` = '" .. getCreatureName(cid) .. "'"):getDataString(coluna);
end

function updateMissionDailyCatch(cid, colunmName, value)
	db.executeQuery("UPDATE `player_daily_catch` SET `"..colunmName.."` = '"..values.."' WHERE `player_name` = '".. getCreatureName(cid) .."';")
end

function deleteRegisterByNickPlayer(cid)
	db.executeQuery("DELETE FROM `player_daily_catch` WHERE `player_name` = '".. getCreatureName(cid) .."';")
end

function setTaskDailyCatch(cid, objetos) 
	if (getPlayerStorageValue(cid, objetos.storages.beginQuest) < 1) then 
		addOpcaoForChoosePokemonDailyCatch(cid, objetos.pokes);
		setPlayerStorageValue(cid, objetos.storages.beginQuest, 1);
	end
end

function dificilPokesParaDailyCatch(cid, dificuldade)
	deleteRegisterByNickPlayer(cid)
	local dif = "";
	if (dificuldade == "facil") then
		dif = "medio";
	elseif (dificuldade == "medio") then
		dif = "dificil";
	elseif (dificuldade == "dificil") then
		dif = "muitoDificil";
	elseif (dificuldade == "muitoDificil") then
		dif = "muitoDificil";
	end
	insertDificuldadeInicialDailyCatch(cid, dif);
end
