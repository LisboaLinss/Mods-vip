function darVIP(staff, cmd, targetName, tipoVIP)
    if not targetName or not tipoVIP then
        outputChatBox("Use: /darvip [jogador] [tipo]", staff, 255,255,255,true)
        return
    end

    local target = getPlayerFromName(targetName)

    if not target then
        outputChatBox("Jogador não encontrado.", staff, 255,0,0)
        return
    end

    setElementData(target, "vip", tipoVIP)

    local nome = getPlayerName(target)

    outputChatBox("🔥 [LOJA] O jogador "..nome.." comprou VIP "..tipoVIP.." na loja!", root, 255,200,0,true)
end

addCommandHandler("darvip", darVIP)
