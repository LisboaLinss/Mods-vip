local TEMPO_VIP = 30 * 24 * 60 * 60 -- 30 dias em segundos

-------------------------------------------------
-- FUNÇÃO DAR VIP (APENAS ADMIN)
-------------------------------------------------
function darVIP(admin, cmd, targetName, tipoVIP)

    -- só admin
    if not hasObjectPermissionTo(admin, "command.darvip", false) then
        outputChatBox("❌ Você não tem permissão para usar este comando.", admin, 255,0,0,true)
        return
    end

    if not targetName or not tipoVIP then
        outputChatBox("Use: /darvip [jogador] [tipo]", admin, 255,255,255,true)
        return
    end

    local target = getPlayerFromName(targetName)
    if not target then
        outputChatBox("❌ Jogador não encontrado.", admin, 255,0,0)
        return
    end

    local acc = getPlayerAccount(target)
    if not acc or isGuestAccount(acc) then
        outputChatBox("❌ O jogador precisa estar logado.", admin, 255,0,0)
        return
    end

    local tempoExpirar = getRealTime().timestamp + TEMPO_VIP

    -- salvar na conta
    setAccountData(acc,"vip.tipo",tipoVIP)
    setAccountData(acc,"vip.expira",tempoExpirar)

    -- aplicar no jogador
    setElementData(target,"vip",tipoVIP)
    setElementData(target,"vip.expira",tempoExpirar)

    local nome = getPlayerName(target)

    -- anúncio global
    outputChatBox("🔥 [LOJA] O jogador "..nome.." comprou VIP "..tipoVIP.." na loja!", root, 255,200,0,true)
end
addCommandHandler("darvip",darVIP)

-------------------------------------------------
-- REMOVER VIP (APENAS ADMIN)
-------------------------------------------------
function removerVIP(admin, cmd, targetName)

    if not hasObjectPermissionTo(admin, "command.removervip", false) then
        outputChatBox("❌ Você não tem permissão para usar este comando.", admin, 255,0,0,true)
        return
    end

    local target = getPlayerFromName(targetName)
    if not target then
        outputChatBox("❌ Jogador não encontrado.", admin, 255,0,0)
        return
    end

    local acc = getPlayerAccount(target)
    if not acc or isGuestAccount(acc) then
        outputChatBox("❌ O jogador precisa estar logado.", admin, 255,0,0)
        return
    end

    -- remover VIP
    setAccountData(acc,"vip.tipo",false)
    setAccountData(acc,"vip.expira",false)
    setElementData(target,"vip",false)
    setElementData(target,"vip.expira",false)

    outputChatBox("✅ VIP removido de "..getPlayerName(target), admin, 255,200,0,true)
end
addCommandHandler("removervip",removerVIP)

-------------------------------------------------
-- VER TEMPO DE VIP
-------------------------------------------------
function tempoVIP(player)
    local expira = getElementData(player,"vip.expira")
    if not expira then
        outputChatBox("❌ Você não possui VIP.", player, 255,0,0,true)
        return
    end

    local agora = getRealTime().timestamp
    local restante = expira - agora

    if restante <= 0 then
        outputChatBox("❌ Seu VIP expirou.", player, 255,0,0,true)
        setElementData(player,"vip",false)
        setElementData(player,"vip.expira",false)
        return
    end

    local dias = math.floor(restante / 86400)
    outputChatBox("⭐ Seu VIP expira em "..dias.." dias.", player, 255,215,0,true)
end
addCommandHandler("tempovip",tempoVIP)

-------------------------------------------------
-- CARREGAR VIP AO LOGAR
-------------------------------------------------
function carregarVIP(_, acc)
    if not acc or isGuestAccount(acc) then return end

    local tipoVIP = getAccountData(acc,"vip.tipo")
    local expira = getAccountData(acc,"vip.expira")

    if tipoVIP and expira then
        local agora = getRealTime().timestamp

        if agora < tonumber(expira) then
            setElementData(source,"vip",tipoVIP)
            setElementData(source,"vip.expira",expira)
        else
            -- VIP expirou
            setAccountData(acc,"vip.tipo",false)
            setAccountData(acc,"vip.expira",false)
            setElementData(source,"vip",false)
            setElementData(source,"vip.expira",false)
        end
    end
end
addEventHandler("onPlayerLogin", root, carregarVIP)

-------------------------------------------------
-- TAG VIP NO CHAT
-------------------------------------------------
function chatVIP(msg, tipo)
    if tipo ~= 0 then return end -- ignorar comandos /me /do etc

    cancelEvent() -- cancelar chat padrão

    local nome = getPlayerName(source)
    local vip = getElementData(source,"vip")

    if vip then
        outputChatBox("#FFD700[VIP "..vip.."] #FFFFFF"..nome..": "..msg, root, 255,255,255,true)
    else
        outputChatBox(nome..": "..msg, root, 255,255,255,true)
    end
end
addEventHandler("onPlayerChat", root, chatVIP)
