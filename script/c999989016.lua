--女仆 瞬间换装！
function c999989016.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,999989016+EFFECT_COUNT_CODE_OATH)
	--e1:SetCost(c999989016.cost)
	e1:SetTarget(c999989016.target)
	e1:SetOperation(c999989016.operation)
	c:RegisterEffect(e1)
end
function c999989016.tgfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsControler(tp) and (c:IsSetCard(0x990) or c:IsCode(26016357)) 
end
--[[function c999989016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end--]]
function c999989016.filter(c,e,tp)
	return c:IsFaceup() and (c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb))  and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c999989016.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetRace())
end
function c999989016.spfilter(c,e,tp,race)
	return  c:IsType(TYPE_MONSTER) and not c:IsRace(race) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb))
end
function c999989016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c999989016.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c999989016.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c999989016.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c999989016.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999989016.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetRace())
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.ChangePosition(g,POS_FACEUP_DEFENCE,0,POS_FACEUP_ATTACK,0)
		end
end