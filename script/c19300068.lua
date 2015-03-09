--镜现诗·神隐的主犯
function c19300068.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCondition(c19300068.spcon)
	e1:SetCost(c19300068.thcost)
	e1:SetTarget(c19300068.hsptg)
	e1:SetOperation(c19300068.hspop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c19300068.spcost)
	e2:SetTarget(c19300068.sptg)
	e2:SetOperation(c19300068.spop)
	c:RegisterEffect(e2)
end
function c19300068.cfilter(c,tp)
	return c:IsSetCard(0x193)
end
function c19300068.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19300068.cfilter,1,nil,tp)
end
function c19300068.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,19300068)==0 end
	Duel.RegisterFlagEffect(tp,19300068,RESET_PHASE+PHASE_END,0,1)
end
function c19300068.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c19300068.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19300068.cffilter(c)
	return c:GetCode()~=19300068 and c:IsSetCard(0x193) and not c:IsPublic()
end
function c19300068.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,19300068)==0 and Duel.IsExistingMatchingCard(c19300068.cffilter,tp,LOCATION_HAND,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c19300068.cffilter,tp,LOCATION_HAND,0,3,3,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.RegisterFlagEffect(tp,19300068,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c19300068.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c19300068.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end