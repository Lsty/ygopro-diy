--苍天之极光-拉帕拉迪斯
function c9990403.initial_effect(c)
	--Xyz
	aux.AddXyzProcedure(c,nil,9,2)
	c:EnableReviveLimit()
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9990403.condition)
	e1:SetCost(c9990403.cost)
	e1:SetTarget(c9990403.target)
	e1:SetOperation(c9990403.operation)
	c:RegisterEffect(e1)
	--Immunity
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c9990403.efilter)
	c:RegisterEffect(e2)
end
function c9990403.condition(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return Duel.IsChainDisablable(ev) and tg and tg:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD)~=0
end
function c9990403.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9990403.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if loc~=LOCATION_DECK and re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0) end
end
function c9990403.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev) local tc=re:GetHandler()
	if not tc:IsRelateToEffect(re) or tc:IsLocation(LOCATION_DECK) then return end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if sg:GetCount()==0 or tc:GetOwner()~=tp or not Duel.SelectYesNo(tp,aux.Stringid(9990403,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) local rg=sg:Select(tp,1,1,nil)
	Duel.HintSelection(rg) Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
function c9990403.efilter(e,re,rp)
	if not (re:IsActiveType(TYPE_MONSTER) and re:IsHasType(0x7e0)) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
