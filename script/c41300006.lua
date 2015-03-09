--无虑的猫·胖太
function c41300006.initial_effect(c)
	aux.EnableDualAttribute(c)
	--battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCondition(aux.IsDualState)
	e2:SetCountLimit(1)
	e2:SetValue(c41300006.valcon)
	c:RegisterEffect(e2)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(aux.IsDualState)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
	e4:SetValue(c41300006.tgvalue)
	c:RegisterEffect(e4)
end
function c41300006.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c41300006.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end