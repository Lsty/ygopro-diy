--WHITEBIRD
function c187023009.initial_effect(c)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26400609,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetCondition(c187023009.con)
	e4:SetCost(c187023009.cost)
	e4:SetTarget(c187023009.tg)
	e4:SetOperation(c187023009.op)
	c:RegisterEffect(e4)
	--direct
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31437713,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCost(c187023009.costs)
	e4:SetTarget(c187023009.target)
	e4:SetOperation(c187023009.operation)
	c:RegisterEffect(e4)
end
function c187023009.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and  bit.band(r,REASON_EFFECT)~=0
	 and re:GetHandler():IsSetCard(0x257)
end
function c187023009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,187023009)==0 end
	Duel.RegisterFlagEffect(tp,187023009,RESET_PHASE+PHASE_END,0,1)
end
function c187023009.filter(c)
	return c:IsSetCard(0x257) and c:IsAbleToGrave()
end
function c187023009.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c187023009.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c187023009.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c187023009.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
    Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c187023009.costs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,187023009)==0 and e:GetHandler():IsAbleToDeck() end
	Duel.RegisterFlagEffect(tp,187023009,RESET_PHASE+PHASE_END,0,1)
	if chk==0 then return end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c187023009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c187023009.filter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c187023009.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c187023009.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
    Duel.SendtoGrave(g,REASON_RETURN)
	end
end