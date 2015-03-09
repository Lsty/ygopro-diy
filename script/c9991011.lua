--虚无之启明
function c9991011.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9991011+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9991011.target)
	e1:SetOperation(c9991011.operation)
	c:RegisterEffect(e1)
end
function c9991011.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xeff) and c:IsType(TYPE_TUNER) and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c9991011.filter2,tp,LOCATION_EXTRA,0,1,c,e,tp,c:GetLevel())
end
function c9991011.filter2(c,e,tp,lv)
	return c:IsFaceup() and c:IsSetCard(0xeff) and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_TUNER) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c9991011.spfilter,tp,LOCATION_EXTRA,0,1,c,e,tp,c:GetLevel()+lv)
end
function c9991011.spfilter(c,e,tp,lv)
	return c:IsSetCard(0xeff) and c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c9991011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9991011.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,LOCATION_EXTRA) Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9991011.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(c9991011.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9991011,0))
	local g1=Duel.SelectMatchingCard(tp,c9991011.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp) local tlv=g1:GetFirst():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9991011,1))
	local g2=Duel.SelectMatchingCard(tp,c9991011.filter2,tp,LOCATION_EXTRA,0,1,1,g1:GetFirst(),e,tp,tlv) local mlv=g2:GetFirst():GetLevel()
	Duel.ConfirmCards(1-tp,g1) Duel.ConfirmCards(1-tp,g2) g1:Merge(g2) Duel.SendtoDeck(g1,nil,2,REASON_EFFECT) Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9991011,2))
	local g3=Duel.SelectMatchingCard(tp,c9991011.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tlv+mlv):GetFirst()
	Duel.SpecialSummon(g3,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) g3:CompleteProcedure()
end
