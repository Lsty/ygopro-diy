--虚荣的空中庭院
function c999998.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c999998.actcon)
	c:RegisterEffect(e1)
    --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c999998.descon)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c999998.tg)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e4)
	end
function c999998.tg(e,c)
	return c:IsCode(999999)
end
function c999998.actfilter(c)
	return c:IsFaceup() and c:IsCode(999999) 
end
function c999998.descon(e)
	return not Duel.IsExistingMatchingCard(c999998.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c999998.actcon(e)
	return  Duel.IsExistingMatchingCard(c999998.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end