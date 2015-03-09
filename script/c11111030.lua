--姐妹之谊
function c11111030.initial_effect(c)
	c:SetUniqueOnField(1,0,11111030)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c1)
	e1:SetTarget(c11111030.target)
	c:RegisterEffect(e1)
	--attibute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(c11111030.value)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c11111030.sdesop)
	c:RegisterEffect(e3)
end
function c11111030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():SetTurnCounter(0)
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_EARTH+ATTRIBUTE_WIND)
	e:SetLabel(rc)
	e:GetHandler():SetHint(CHINT_ATTRIBUTE,rc)
end
function c11111030.value(e,c)
	return e:GetLabelObject():GetLabel()
end
function c11111030.sdesop(e,tp,eg,ep,ev,re,r,rp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		Duel.Destroy(c,REASON_RULE)
	end
end