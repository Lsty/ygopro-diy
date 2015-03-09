--初恋与悸动
function c2222263.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c2222263.condition)
	e1:SetTarget(c2222263.target)
	e1:SetOperation(c2222263.activate)
	c:RegisterEffect(e1)
end
function c2222263.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa74)
end
function c2222263.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2222263.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c2222263.filter(c)
	return c:IsSetCard(0xa74) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c2222263.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222263.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2222263.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c2222263.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end