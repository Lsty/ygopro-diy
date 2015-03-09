--老板娘 米斯蒂娅
function c31141515.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),4,2)
	c:EnableReviveLimit()
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31141515,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,31141515)
	e3:SetCondition(c31141515.tgcon)
	e3:SetCost(c31141515.cost)
	e3:SetTarget(c31141515.target)
	e3:SetOperation(c31141515.operation)
	c:RegisterEffect(e3)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(31141515,3))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c31141515.thcost)
	e5:SetTarget(c31141515.drtg)
	e5:SetOperation(c31141515.drop)
	c:RegisterEffect(e5)
end
function c31141515.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c31141515.filter(c)
	return c:IsSetCard(0x3d3) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c31141515.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c31141515.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c31141515.filter,tp,LOCATION_GRAVE,0,3,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c31141515.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c31141515.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:FilterCount(Card.IsRelateToEffect,nil,e)==3 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c31141515.spfilter(c)
	return c:IsSetCard(0x3d3) and c:IsType(TYPE_MONSTER)
end
function c31141515.tgcon(e)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil,0x3d3)>=3
end
function c31141515.cfilter(c)
	return c:IsSetCard(0x3d3) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c31141515.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31141515.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c31141515.cfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c31141515.filter1(c,e,tp)
	return c:IsSetCard(0x3d3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c31141515.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c31141515.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c31141515.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c31141515.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c31141515.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end