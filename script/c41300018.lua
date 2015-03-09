--猫神像
function c41300018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--duel status
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c41300018.target)
	e1:SetCode(EFFECT_DUAL_STATUS)
	c:RegisterEffect(e1)
end
function c41300018.target(e,c)
	return c:IsType(TYPE_DUAL) and c:IsSetCard(0x413)
end