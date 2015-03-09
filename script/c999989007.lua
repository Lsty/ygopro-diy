--武装女仆 双刀
function c999989007.initial_effect(c)
    --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetCondition(c999989007.spcon)
	e1:SetCountLimit(1,999989007+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c999989007.sptg)
	e1:SetOperation(c999989007.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_NAGA+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,999989007+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c999989007.descon)
	e2:SetTarget(c999989007.destg)
	e2:SetOperation(c999989007.desop)
	c:RegisterEffect(e2)
end
function c999989007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c999989007.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:GetLevel()==4 and c:IsAttackBelow(1600)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999989007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c999989007.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c999989007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999989007.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
	if tc  then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,0,POS_FACEUP_ATTACK,0)
end
end
function c999989007.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c999989007.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c999989007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c999989007.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999989007.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c999989007.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c999989007.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Destroy(tc,REASON_EFFECT)
end
end