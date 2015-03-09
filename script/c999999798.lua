--虹纹骑士-青风
function c999999798.initial_effect(c)
	--①
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(698785,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,999999789)
	e1:SetTarget(c999999798.rmtg)
	e1:SetOperation(c999999798.rmop)
	c:RegisterEffect(e1)
	--②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2273734,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,999999789)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c999999798.sptg)
	e2:SetOperation(c999999798.spop)
	c:RegisterEffect(e2)
end
function c999999798.filter(c)
	return c:IsSetCard(0xf70) and c:IsAbleToRemove()
end
function c999999798.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFlagEffect(tp,999999798)==0 
	and Duel.IsExistingMatchingCard(c999999798.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.RegisterFlagEffect(tp,999999798,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c999999798.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c999999798.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
function c999999798.spfilter(c,e,tp)
	return c:IsSetCard(0xf70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999999798.afilter(c)
	return c:IsSetCard(0xf70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999999798.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c999999798.afilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFlagEffect(tp,999999798)==0
		and Duel.IsExistingTarget(c999999798.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c999999798.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.RegisterFlagEffect(tp,999999798,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c999999798.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENCE) then
	--unsynchroable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c999999798.splimit)
	tc:RegisterEffect(e1)
	--xyzlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c999999798.splimit)
	tc:RegisterEffect(e2)
    Duel.SpecialSummonComplete()
    end
		Duel.BreakEffect()
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
end
function c999999798.splimit(e,c)
    if not c then return false end
	return not c:IsSetCard(0xf70)
end

