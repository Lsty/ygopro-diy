--Baka吉井明久的姐姐·吉井玲
function c23300054.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c23300054.atkup)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c23300054.atkup2)
	c:RegisterEffect(e2)
end
function c23300054.atkfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c23300054.atkup(e,c)
	return Duel.GetMatchingGroupCount(c23300054.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil,e,tp)*300
end
function c23300054.atkfilter2(c,e,tp)
	return c:IsCode(23300002)
end
function c23300054.atkup2(e,c)
	return Duel.GetMatchingGroupCount(c23300054.atkfilter2,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,e,tp)*600
end
