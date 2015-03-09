--星夜下 誓语
function c2222289.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c2222289.target)
	e1:SetOperation(c2222289.activate)
	c:RegisterEffect(e1)
end
function c2222289.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsSetCard(0x2a74) and c:IsType(TYPE_FUSION)
		and Duel.IsExistingMatchingCard(c2222289.filter2,tp,LOCATION_EXTRA,0,1,nil,lv+1,e,tp)
end
function c2222289.filter2(c,lv,e,tp)
	return lv>0 and c:GetLevel()==lv and c:IsSetCard(0x890)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c2222289.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c2222289.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c2222289.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c2222289.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c2222289.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetLevel()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c2222289.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetLevel()+1,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end