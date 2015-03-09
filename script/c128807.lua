--蚀神的月见天使 暗刻
function c128807.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	aux.AddPendulumProcedure(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(128807,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c128807.descost)
	e1:SetCountLimit(1)
	e1:SetTarget(c128807.target)
	e1:SetOperation(c128807.operation)
	c:RegisterEffect(e1)
end
function c128807.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c128807.ftarget)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c128807.ftarget(e,c)
	return not c:IsSetCard(0x9fe)
end
function c128807.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(128807,1))
end
function c128807.operation(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local i=1
	for i=1,8 do t[i]=i end
	local lv=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(128807,1))
	local c=e:GetHandler()
	local op=0
	op=Duel.SelectOption(tp,aux.Stringid(128807,2),aux.Stringid(128807,3))
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
	local mg=Duel.GetMatchingGroup(c128807.matfilter,tp,0,LOCATION_MZONE,nil):GetSum(c128807.getsum)
	if tg==mg then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		mat=Duel.GetMatchingGroup(c128807.matfilter,tp,0,LOCATION_MZONE,nil)
		Duel.BreakEffect()
		Duel.SendtoGrave(mat,REASON_EFFECT)
	end
end
function c128807.matfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c128807.getsum(c)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	else
		return c:GetLevel()
	end
end
