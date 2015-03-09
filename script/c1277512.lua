--侵蚀固有异界 水晶溪谷
function c1277512.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTarget(c1277512.tg)
	e3:SetValue(c1277512.efilter)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c1277512.discon)
	e1:SetTarget(c1277512.target)
	e1:SetOperation(c1277512.zop)
	c:RegisterEffect(e1)
end
function c1277512.cfilter(c)
	return c:IsFaceup() and c:IsCode(1277511)
end
function c1277512.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1277512.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c1277512.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	e:SetLabel(dis)
end
function c1277512.zop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c1277512.disop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetLabel(e:GetLabel())
	e:GetHandler():RegisterEffect(e1)
end
function c1277512.disop(e,tp)
	return e:GetLabel()
end
function c1277512.tg(e,c)
	return c:IsFaceup() and c:GetCode()==1277511
end
function c1277512.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
