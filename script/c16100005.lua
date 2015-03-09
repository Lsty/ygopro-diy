--姐姐大人 御坂美琴
function c16100005.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c16100005.cost)
	e2:SetTarget(c16100005.sptg)
	e2:SetOperation(c16100005.spop)
	c:RegisterEffect(e2)
	local e1=e2:Clone()
	e1:SetCondition(c16100005.thcon)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
end
function c16100005.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsAttribute(ATTRIBUTE_LIGHT) and re:GetHandler():IsRace(RACE_THUNDER) and re:GetHandler():IsType(TYPE_MONSTER)
end
function c16100005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,16100005)==0 end
	Duel.RegisterFlagEffect(tp,16100005,RESET_PHASE+PHASE_END,0,1)
end
function c16100005.filter(c,e,tp)
	return c:IsSetCard(0x161) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16100005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c16100005.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c16100005.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c16100005.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c16100005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end