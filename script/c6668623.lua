--徘徊于狭间 女神天子
function c6668623.initial_effect(c)
	c:SetUniqueOnField(1,0,6668623)
	c:EnableReviveLimit()
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c6668623.mtcon)
	e1:SetOperation(c6668623.mtop)
	c:RegisterEffect(e1)
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c6668623.atktg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetValue(c6668623.chainfilter)
	c:RegisterEffect(e4)
end
function c6668623.mat_filter(c)
	return not c:IsCode(6668623)
end
function c6668623.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c6668623.mtop(e,tp,eg,ep,ev,re,r,rp)
	local sel=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(6668623,0))
	sel=Duel.SelectOption(tp,aux.Stringid(6668623,1),aux.Stringid(6668623,2))+1
	if sel==1 then
	local lp=Duel.GetLP(tp)
	if lp<=4000 then
		Duel.SetLP(tp,0)
	else
		Duel.SetLP(tp,lp-4000) end 
	else Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT) end
end
function c6668623.atktg(e,c)
	return c:GetBaseAttack()>2500
end
function c6668623.chainfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:GetType()==TYPE_MONSTER and c:GetBaseDefence()<=2000
end