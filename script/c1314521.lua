--夜夜 吹鸣
function c1314521.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1314521,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,1314521)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c1314521.totg)
	e1:SetOperation(c1314521.toop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1314521,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c1314521.cost)
	e2:SetCondition(c1314521.condition)
	e2:SetOperation(c1314521.operation)
	c:RegisterEffect(e2)
end
function c1314521.tfilter(c)
	return c:IsType(0x1) and c:IsSetCard(0x9fd) and not c:IsCode(1314521) and c:IsAbleToRemove()
end
function c1314521.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1314521.tfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectTarget(tp,c1314521.tfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end 
function c1314521.toop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end 
end
function c1314521.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),0x5,0x80) 
end
function c1314521.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp 
end
function c1314521.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1000)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
