--孤独的世界 女神天子
function c6668622.initial_effect(c)
	c:SetUniqueOnField(1,0,6668622)
	c:EnableReviveLimit()
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c6668622.mtcon)
	e1:SetOperation(c6668622.mtop)
	c:RegisterEffect(e1)
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetTarget(c6668622.tg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetTarget(c6668622.tg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(c6668622.atkval)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e8)
end
function c6668622.mat_filter(c)
	return not c:IsCode(6668622)
end
function c6668622.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c6668622.mtop(e,tp,eg,ep,ev,re,r,rp)
	local sel=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(6668622,0))
	sel=Duel.SelectOption(tp,aux.Stringid(6668622,1),aux.Stringid(6668622,2))+1
	if sel==1 then
	local lp=Duel.GetLP(tp)
	if lp<=3000 then
		Duel.SetLP(tp,0)
	else
		Duel.SetLP(tp,lp-3000) end 
	else Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT) end
end
function c6668622.tg(e,c)
	return c:GetBaseDefence()<=1000
end
function c6668622.atkval(e,c)
	local cont=c:GetControler()
	if Duel.GetLP(cont)>Duel.GetLP(1-cont) then
	return Duel.GetLP(cont)-Duel.GetLP(1-cont) 
	else return Duel.GetLP(1-cont)-Duel.GetLP(cont) end
end