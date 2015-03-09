--疵痕「损坏的护符」
function c13130140.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13130140+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c13130140.condition)
	e1:SetOperation(c13130140.activate)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c13130140.aclimit)
	c:RegisterEffect(e2)
	--effect damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,13130141)
	e3:SetCost(c13130140.cost)
	e3:SetCondition(c13130140.condition2)
	e3:SetOperation(c13130140.activate2)
	c:RegisterEffect(e3)
end
function c13130140.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c13130140.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c13130140.pietg)
	Duel.RegisterEffect(e1,tp)
end
function c13130140.pietg(e,c)
	return c:IsSetCard(0xddd)
end
function c13130140.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c13130140.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c13130140.filter(c)
	return c:IsFaceup() and not c:IsSetCard(0xddd)
end
function c13130140.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xddd)
end
function c13130140.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c13130140.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c13130140.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function c13130140.activate2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c13130140.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c13130140.damval(e,re,val,r,rp,rc)
	return val*2
end