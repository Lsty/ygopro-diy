--时幻之扉
function c9990702.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9990702+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9990702.cost)
	e1:SetTarget(c9990702.target)
	e1:SetOperation(c9990702.activate)
	c:RegisterEffect(e1)
end
function c9990702.cfilter(c)
	return c:IsType(TYPE_TUNER)
end
function c9990702.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9990702.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c9990702.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c9990702.filter(c,e,tp)
	return c:IsAttribute(0x30) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9990702.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c9990702.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9990702.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9990702.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9990702.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
