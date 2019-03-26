# Show-off-pxg

![Giff](https://github.com/afabianoo/Show-off-pxg/blob/master/dailyCatch.gif) 

## Pré requisito

1 - Criar a seguinte tabela

```sql
CREATE TABLE player_daily_catch (
 player_name VARCHAR(255),
 dificuldade VARCHAR(20),
 opcao_poke1 VARCHAR(30),
 opcao_poke2 VARCHAR(30),
 poke_escolhido VARCHAR(30)
);
```

2 - Alterar o arquivo login.lua

> Em data/creaturescripts abra o arquivo que contenha a função `onLogin` e acrescente `initializeDailyCatch(cid)` logo abaixo de `function onLogin(cid)`

3 - Alterar o arquivo catch.lua
> procurar pela mensagem parecida com `Congratulations, you caught a pokemon` e logo após isso, deve incluir
``` lua
local obj = getListOfObjectsByDifficulty(cid);
if (getPlayerStorageValue(cid, obj.storages.catch) >= 1) and (getPlayerStorageValue(cid, obj.storages.catchSucess) ~= 1) then 
  if (pokemonCapturado == getPokemonForDailyCatch(cid, "poke_escolhido")) then
    sendMsgToPlayer(cid, 27, "Você completou sua quest.");
    doSendMagicEffect(getThingPos(getCreatureSummons(cid)[1]), 173) 
    setPlayerStorageValue(cid, obj.storages.catchSucess, 1)
  end
end
```
> a variável pokemonCapturado é o pokemon em que foi jogado a ball

4 - Acrescentar os npcs e o arquivo na lib

5 - Iniciar o jogo, invocar o npc `/n dailyCatch` e falar com ele
  - Nome dos pokémons são case-sensitive
