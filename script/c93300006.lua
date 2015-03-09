--潜意识的基因 古明地恋
function c93300006.initial_effect(c)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c93300006.cost)
	e1:SetTarget(c93300006.target)
	e1:SetOperation(c93300006.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c93300006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,93300006)==0 and Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
	local g=Duel.GetOperatedGroup()
	e:SetLabelObject(g:GetFirst())
	Duel.RegisterFlagEffect(tp,93300006,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c93300006.thfilter(c)
	return c:IsSetCard(0x933) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c93300006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c93300006.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=e:GetLabelObject()
	if g:IsRace(RACE_PSYCHO) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c93300006.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:IsRace(RACE_PSYCHO) then
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c93300006.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end