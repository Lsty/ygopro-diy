--你是我的甜❤点～
function c2222277.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c2222277.target)
	e1:SetOperation(c2222277.activate)
	c:RegisterEffect(e1)
end
function c2222277.tfilter(c,lv,e,tp)
	return c:IsSetCard(0x888) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c2222277.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xa74)
		and Duel.IsExistingMatchingCard(c2222277.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetLevel(),e,tp)
end
function c2222277.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c2222277.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c2222277.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c2222277.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c2222277.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetLevel()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c2222277.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end