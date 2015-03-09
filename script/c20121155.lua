--Black★Pass
function c20121155.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20121155.target)
	e1:SetOperation(c20121155.activate)
	c:RegisterEffect(e1)
end
function c20121155.spfilter(c,e,tp,rg)
	if not c:IsRace(RACE_WARRIOR) or not c:IsAttribute(ATTRIBUTE_DARK) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	if rg:IsContains(c) then
		rg:RemoveCard(c)
		result=rg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99)
		rg:AddCard(c)
	else
		result=rg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99)
	end
	return result
end
function c20121155.rmfilter(c)
	return c:GetLevel()>0 and c:IsAbleToDeck() and c:IsSetCard(0x777)
end
function c20121155.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local rg=Duel.GetMatchingGroup(c20121155.rmfilter,tp,LOCATION_REMOVED,0,nil)
		return Duel.IsExistingTarget(c20121155.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,rg)
	end
	local rg=Duel.GetMatchingGroup(c20121155.rmfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c20121155.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,rg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c20121155.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	local rg=Duel.GetMatchingGroup(c20121155.rmfilter,tp,LOCATION_REMOVED,0,nil)
	if rg:CheckWithSumEqual(Card.GetLevel,tc:GetLevel(),1,99) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rm=rg:SelectWithSumEqual(tp,Card.GetLevel,tc:GetLevel(),1,99)
		Duel.SendtoDeck(rm,nil,2,REASON_EFFECT)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
