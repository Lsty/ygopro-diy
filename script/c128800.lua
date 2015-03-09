--月见的仪仗天使 圣弓
function c128800.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(128800,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c128800.target)
	e1:SetOperation(c128800.operation)
	c:RegisterEffect(e1)
end
function c128800.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(128800,1))
end
function c128800.operation(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local i=1
	for i=1,2 do t[i]=i end
	local lv=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(128800,1))
	local c=e:GetHandler()
	local op=0
	op=Duel.SelectOption(tp,aux.Stringid(128800,2),aux.Stringid(128800,3))
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		if op==0 then
			e1:SetValue(lv)
		else e1:SetValue(-lv) end
		c:RegisterEffect(e1)
	end
	local tg=c:GetLevel()
	local mg=Duel.GetMatchingGroup(c128800.matfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if mg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99,c) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetLevel,c:GetLevel(),1,99,c)
		c:SetMaterial(mat)
		rg=Duel.SendtoGrave(mat,REASON_EFFECT)
		Duel.BreakEffect()
			if rg>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetValue(rg*200)
				e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
				c:RegisterEffect(e2)
		end
	end
end
function c128800.matfilter(c,m)
	return c:IsFaceup() and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) 
end
function c128800.getsum(c)
	return c:GetLevel()
end
