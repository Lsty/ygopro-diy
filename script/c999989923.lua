--传说之剑士 齐格飞
function c999989923.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,7))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c999989923.con)
	e1:SetTarget(c999989923.setg)
	e1:SetOperation(c999989923.seop)
	c:RegisterEffect(e1)
	--[[--immune
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c999989923.immcon)
    e2:SetValue(c999989923.eop)
	c:RegisterEffect(e2)--]]
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c999989923.immcon)
	e3:SetValue(c999989923.indes)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_SZONE)
	e4:SetCondition(c999989923.immcon)
	e4:SetTarget(c999989923.distg)
	c:RegisterEffect(e4)
	--disable effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c999989923.immcon)
	e5:SetOperation(c999989923.disop)
	c:RegisterEffect(e5)
end
function c999989923.con(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c999989923.filter(c)
	local code=c:GetCode()
	return (code==999989922) 
end
function c999989923.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999989923.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999989923.seop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999989923.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(999997,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Equip(tp,tc,c)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
		Duel.BreakEffect()
	    Duel.Draw(tp,1,REASON_EFFECT)
end
end
function c999989923.immcon(e)
 return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
--[[function c999989923.eop(e,te)
    if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
	if te:IsActiveType(TYPE_MONSTER) then
	local lv=e:GetHandler():GetLevel()
		local ec=te:GetHandler()
		if ec:IsType(TYPE_XYZ) then
	return  ec:GetRank()<lv   and e:GetHandlerPlayer()~=te:GetHandlerPlayer()
	else
	return ec:GetLevel()<lv   and  e:GetHandlerPlayer()~=te:GetHandlerPlayer()
end
end
end--]]
function c999989923.indes(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsType(TYPE_XYZ) then 
	return c:GetRank()<=lv
	else 
	return c:GetLevel()<=lv
end
end
function c999989923.distg(e,c)
	local ec=e:GetHandler()
	if c==ec or not c:IsType(TYPE_SPELL) or c:GetCardTargetCount()==0 then return false end
	return  c:GetControler()~=ec:GetControler() and c:GetCardTarget():IsContains(ec)
end
function c999989923.disop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_SPELL) or rp==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then 
		Duel.NegateEffect(ev)
	end
end