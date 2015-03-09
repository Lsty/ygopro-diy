--高达⑨
function c116810912.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3e6),aux.NonTuner(Card.IsSetCard,0x3e6),2)
	c:EnableReviveLimit()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(116810912,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,116810912)
	e1:SetCost(c116810912.cost)
	e1:SetOperation(c116810912.operation)
	c:RegisterEffect(e1)
	--xyz limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(116810912,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,116810912)
	e2:SetCost(c116810912.cost)
	e2:SetOperation(c116810912.op)
	c:RegisterEffect(e2)
end
function c116810912.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and not c:IsPublic()
end
function c116810912.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c116810912.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c116810912.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.ShuffleHand(tp)
end
function c116810912.operation(e,tp,eg,ep,ev,re,r,rp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(1,1)
	e4:SetLabel(e:GetLabel()+1)
	e4:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_OPPO_TURN)
	e4:SetValue(c116810912.val)
	Duel.RegisterEffect(e4,tp)
end
function c116810912.val(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLevelAbove(e:GetLabel())
end
function c116810912.op(e,tp,eg,ep,ev,re,r,rp)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c116810912.target)
	e5:SetLabel(e:GetLabel())
	e5:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e5:SetValue(1)
	Duel.RegisterEffect(e5,tp)
end
function c116810912.target(e,c)
	return c:GetLevel()~=e:GetLabel()
end
