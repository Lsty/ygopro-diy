--黑圆桌第六位 Isaak
function c98800002.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c98800002.spcost)
	e1:SetTarget(c98800002.sctg)
	e1:SetOperation(c98800002.scop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_NAGA+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCondition(c98800002.spcon)
	e3:SetTarget(c98800002.sptg)
	e3:SetOperation(c98800002.spop)
	c:RegisterEffect(e3)
end
function c98800002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c98800002.filter(c,e,tp)
	return c:IsSetCard(0x988) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98800002.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98800002.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c98800002.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98800002.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c98800002.scop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98800002.filter2(c)
	return not c:IsSetCard(0x988)
end
function c98800002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ((e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and (e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) or e:GetHandler():IsPreviousLocation(LOCATION_REMOVED))) or e:GetHandler():IsPreviousLocation(LOCATION_GRAVE))
		and e:GetHandler():IsReason(REASON_EFFECT)
		and not Duel.IsExistingMatchingCard(c98800002.filter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c98800002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98800002)==0 and Duel.IsExistingMatchingCard(c98800002.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,98800002,RESET_PHASE+PHASE_END,0,1)
end
function c98800002.scfilter(c)
	return c:IsSetCard(0x988) and c:IsAbleToHand()
end
function c98800002.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98800002.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end