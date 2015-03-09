--月见的仪仗天使 圣剑
function c128801.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(128801,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c128801.remcon)
	e1:SetTarget(c128801.target)
	e1:SetOperation(c128801.operation)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c128801.target2)
	e2:SetValue(-1)
	c:RegisterEffect(e2)
end
function c128801.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c128801.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c128801.operation(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local i=1
	for i=1,3 do t[i]=i end
	local lv=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(128801,1))
	local c=e:GetHandler()
	local op=0
	op=Duel.SelectOption(tp,aux.Stringid(128801,2),aux.Stringid(128801,3))
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if op==0 then
			e1:SetValue(lv)
		else e1:SetValue(-lv) end
		c:RegisterEffect(e1)
	end
end
function c128801.target2(e,c)
	local tc=e:GetHandler()
	local lv=tc:GetLevel()
	return c:GetLevel()>lv
end
