local TEMPO_VIP = 30 * 24 * 60 * 60 -- 30 dias

-------------------------------------------------
-- FUNÇÃO DAR VIP (APENAS STAFF)
-------------------------------------------------

function darVIP(staff, cmd, targetName, tipoVIP)

    if not hasObjectPermissionTo(staff, "command.darvip", false) then
        outputChatBox("❌ Você não tem permissão.", staff, 255,0,0,true)
        return
    end

    if not targetName or not tipoVIP then
        outputChatBox("Use: /darvip [jogador] [tipo]", staff, 255,255,255,true)
        return
    end

    local target = getPlayerFromName(targetName)

    if not target then
        outputChatBox("❌ Jogador não encontrado.", staff, 255,0,0)
        return
    end

    local acc = getPlayerAccount(target)

    if not acc or isGuestAccount(acc) then
        outputChatBox("❌ Jogador precisa estar logado.", staff, 255,0,0)
        return
    end

    local tempoExpirar = getRealTime().timestamp + TEMPO_VIP

    setAccountData(acc,"vip.tipo",tipoVIP)
    setAccountData(acc,"vip.expira",tempoExpirar)

    setElementData(target,"vip",tipoVIP)
    setElementData(target,"vip.expira",tempoExpirar)

    local nome = getPlayerName(target)

    outputChatBox("🔥 [LOJA] O jogador "..nome.." comprou VIP "..tipoVIP.." na loja!", root,255,200,0,true)

end
addCommandHandler("darvip",darVIP)

-------------------------------------------------
-- REMOVER VIP (STAFF)
-------------------------------------------------

function removerVIP(staff,cmd,targetName)

    if not hasObjectPermissionTo(staff,"command.removervip",false) then
        outputChatBox("❌ Sem permissão.",staff,255,0,0,true)
        return
    end

    local target = getPlayerFromName(targetName)

    if not target then
        outputChatBox("Jogador não encontrado.",staff,255,0,0)
        return
    end

    local acc = getPlayerAccount(target)

    setAccountData(acc,"vip.tipo",false)
    setAccountData(acc,"vip.expira",false)

    setElementData(target,"vip",false)

    outputChatBox("VIP removido de "..getPlayerName(target),staff,255,200,0)

end
addCommandHandler("removervip",removerVIP)

-------------------------------------------------
-- VER TEMPO DO VIP
-------------------------------------------------

function tempoVIP(player)

    local expira = getElementData(player,"vip.expira")

    if not expira then
        outputChatBox("❌ Você não possui VIP.",player,255,0,0)
        return
    end

    local agora = getRealTime().timestamp
    local restante = expira - agora

    if restante <= 0 then
        outputChatBox("Seu VIP expirou.",player,255,0,0)
        return
    end

    local dias = math.floor(restante / 86400)

    outputChatBox("⭐ Seu VIP expira em "..dias.." dias.",player,255,215,0,true)

end
addCommandHandler("tempovip",tempoVIP)

-------------------------------------------------
-- CARREGAR VIP AO LOGAR
-------------------------------------------------

function carregarVIP(_,acc)

    if not acc or isGuestAccount(acc) then return end

    local tipoVIP = getAccountData(acc,"vip.tipo")
    local expira = getAccountData(acc,"vip.expira")

    if tipoVIP and expira then

        local agora = getRealTime().timestamp

        if agora < tonumber(expira) then

            setElementData(source,"vip",tipoVIP)
            setElementData(source,"vip.expira",expira)

        else

            setAccountData(acc,"vip.tipo",false)
            setAccountData(acc,"vip.expira",false)

        end

    end

end
addEventHandler("onPlayerLogin",root,carregarVIP)

-------------------------------------------------
-- TAG VIP NO CHAT
-------------------------------------------------

function chatVIP(msg,type)

    if type ~= 0 then return end

    cancelEvent()

    local nome = getPlayerName(source)
    local vip = getElementData(source,"vip")

    if vip then
        outputChatBox("#FFD700[VIP "..vip.."] #FFFFFF"..nome..": "..msg,root,255,255,255,true)
    else
        outputChatBox(nome..": "..msg,root,255,255,255,true)
    end

end
addEventHandler("onPlayerChat",root,chatVIP)
