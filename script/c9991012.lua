--虚无的引导
function c9991012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Draw or Gather Pendulum Card
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,9991012111)
	e2:SetCondition(c9991012.dpcon)
	e2:SetTarget(c9991012.dptg)
	e2:SetOperation(c9991012.dpop)
	c:RegisterEffect(e2)
	--Special Summon Level 3 Tuner
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9991012222)
	e3:SetCondition(c9991012.spcon)
	e3:SetTarget(c9991012.sptg)
	e3:SetOperation(c9991012.spop)
	c:RegisterEffect(e3)
end
function c9991012.dpcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9991012.dpfilter,1,nil,tp)
end
function c9991012.dpfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsSetCard(0xeff)
end
function c9991012.gfilter(c)
	return c:IsSetCard(0xeff) and c:IsAbleToHand() and (c:IsLocation(LOCATION_DECK) or c:IsType(TYPE_PENDULUM))
end
function c9991012.dptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9991012.gfilter,tp,0x41,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c9991012.dpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not Duel.IsExistingMatchingCard(c9991012.gfilter,tp,0x41,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9991012.gfilter,tp,0x41,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,g)
end
function c9991012.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xeff) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c9991012.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c9991012.exfilter,tp,LOCATION_SZONE,0,nil)>0
end
function c9991012.spfilter(c,e,tp)
	return c:GetLevel()==3 and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9991012.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9991012.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c9991012.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9991012.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9991012.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget() local c=e:GetHandler()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+0x47e0000)
		e3:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e3,true)
	end
end