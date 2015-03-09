--散符「真实之月」
function c73700014.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c73700014.target)
	e1:SetOperation(c73700014.operation)
	c:RegisterEffect(e1)
end
function c73700014.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsSetCard(0x737) and c:IsType(TYPE_FUSION) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c73700014.spfilter,tp,LOCATION_GRAVE,0,1,c,lv,e,tp)
end
function c73700014.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x737) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c73700014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c73700014.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c73700014.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c73700014.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c73700014.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local slv=tc:GetLevel()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local sg=Duel.GetMatchingGroup(c73700014.spfilter,tp,LOCATION_GRAVE,0,nil,slv,e,tp)
	if sg:GetCount()==0 then return end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		sg:RemoveCard(tc)
		slv=slv-tc:GetLevel()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		sg:Remove(Card.IsLevelAbove,nil,slv+1)
		ft=ft-1
	until ft<=0 or sg:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(73700014,0))
	Duel.SpecialSummonComplete()
end