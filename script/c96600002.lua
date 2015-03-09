--寄居处的独身熟女✟相乐莓
function c96600002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(c96600002.spcon)
	e1:SetTarget(c96600002.sptg)
	e1:SetOperation(c96600002.spop)
	c:RegisterEffect(e1)
end
function c96600002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard(0x966) and re:GetHandler():GetCode()~=96600002
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c96600002.filter(c,e,tp)
	return c:IsSetCard(0x966) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c96600002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c96600002.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,96600002)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,96600002,RESET_PHASE+PHASE_END,0,1)
end
function c96600002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c96600002.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end
end