--镜现诗·愉快的遗忘之伞
function c19300045.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c19300045.target)
	e1:SetOperation(c19300045.operation)
	c:RegisterEffect(e1)
end
function c19300045.filter(c)
	return c:IsSetCard(0x193) and c:IsLevelBelow(4) and c:IsAbleToGrave()
end
function c19300045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,19300045)==0
		and Duel.IsExistingMatchingCard(c19300045.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,19300045,RESET_PHASE+PHASE_END,0,1)
end
function c19300045.filter1(c)
	return c:IsCode(19300045) and c:IsAbleToHand()
end
function c19300045.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c19300045.filter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c19300045.filter1,tp,LOCATION_DECK,0,1,nil) then
		Duel.BreakEffect()
		local tg=Duel.GetFirstMatchingCard(c19300045.filter1,tp,LOCATION_DECK,0,nil)
		if tg then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
