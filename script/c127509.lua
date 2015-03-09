--时幻跃迁
function c127509.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c127509.cost)
	e1:SetOperation(c127509.activate)
	c:RegisterEffect(e1)
end
function c127509.spfilter(c)
	return c:IsSetCard(0x7fa) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c127509.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c127509.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c127509.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0  then
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c127509.filter(c)
	return c:IsSetCard(0x7fa) and c:IsType(TYPE_NORMAL)  and c:IsAbleToHand()
end
function c127509.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(c127509.filter,tp,LOCATION_DECK,0,nil)
	local opt=0
	if g1:GetCount()>0 and g2:GetCount()>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(127509,0),aux.Stringid(127509,1))
	elseif g1:GetCount()>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(127509,0))
	elseif g2:GetCount()>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(127509,1))+1
	else return end
	if opt==0 then
		local dg=g1:Select(tp,1,1,nil)
		Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	else
		local dg=g2:Select(tp,1,1,nil)
		Duel.SendtoHand(dg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,dg)
	end
end
