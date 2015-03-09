--操鸟师 信鸽
function c18702312.initial_effect(c)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26400609,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetCountLimit(1,18702312)
	e4:SetCondition(c18702312.con)
	e4:SetTarget(c18702312.tg)
	e4:SetOperation(c18702312.op)
	c:RegisterEffect(e4)
	--direct
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31437713,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,18702312)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c18702312.costs)
	e4:SetTarget(c18702312.target)
	e4:SetOperation(c18702312.operation)
	c:RegisterEffect(e4)
end
function c18702312.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0x257)
end
function c18702312.filter(c)
	return c:IsSetCard(0x257) and c:IsAbleToGrave()
end
function c18702312.filter2(c)
	return c:IsSetCard(0x257) and c:IsAbleToDeck()
end
function c18702312.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18702312.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18702312.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18702312.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
    Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c18702312.costs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c18702312.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18702312.filter2,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c18702312.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c18702312.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end