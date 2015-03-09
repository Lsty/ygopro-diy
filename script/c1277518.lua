--蚀神的月见天使 暗刻
function c1277518.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1277518,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1277518.target)
	e1:SetOperation(c1277518.operation)
	c:RegisterEffect(e1)
end
function c1277518.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c1277518.operation(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local i=1
	for i=1,8 do t[i]=i end
	local lv=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1277518,3))
	local c=e:GetHandler()
	local op=0
	if c:GetLevel()<8 then op=Duel.SelectOption(tp,aux.Stringid(1277518,4))
	else op=Duel.SelectOption(tp,aux.Stringid(1277518,4),aux.Stringid(1277518,5)) end
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
	local mg=Duel.GetMatchingGroup(c1277518.matfilter,tp,0,LOCATION_MZONE,nil):GetSum(c1277518.getsum)
	if tg==mg then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		mat=Duel.GetMatchingGroup(c1277518.matfilter,tp,0,LOCATION_MZONE,nil)
		Duel.SendtoGrave(mat,REASON_EFFECT)
	end
end
function c1277518.matfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c1277518.getsum(c)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	else
		return c:GetLevel()
	end
end
