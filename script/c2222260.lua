--相遇时的回忆
function c2222260.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c2222260.target)
	e1:SetOperation(c2222260.activate)
	c:RegisterEffect(e1)
end
function c2222260.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2a74) and c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
end
function c2222260.spfilter(c,e,tp)
	return c:IsSetCard(0xa74) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2222260.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==tp and c2222260.tgfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c2222260.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c2222260.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SelectTarget(tp,c2222260.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,LOCATION_DECK)
end
function c2222260.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetFirstTarget()
	if not rc or not rc:IsFaceup() or not rc:IsRelateToEffect(e) then return end
	local rt=Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
	if rt==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c2222260.spfilter,tp,LOCATION_DECK,0,2,2,nil,e,tp)
	if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
