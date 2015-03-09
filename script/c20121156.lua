--Black★Exchange
function c20121156.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20121156.cost)
	e1:SetTarget(c20121156.target)
	e1:SetOperation(c20121156.activate)
	c:RegisterEffect(e1)
end
function c20121156.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20121156)==0 end
	Duel.RegisterFlagEffect(tp,20121156,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c20121156.filter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToRemove()
end
function c20121156.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20121156.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c20121156.tfilter(c,lv)
	return c:IsSetCard(0x777) and c:GetLevel()>=lv+1 and c:IsAbleToHand()
end
function c20121156.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c20121156.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local lv=tc:GetLevel()
		if Duel.IsExistingMatchingCard(c20121156.tfilter,tp,LOCATION_DECK,0,1,nil,lv) and Duel.SelectYesNo(tp,aux.Stringid(20121156,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c20121156.tfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_TO_HAND)
			e1:SetTargetRange(LOCATION_DECK,0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_DRAW)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetTargetRange(1,0)
			Duel.RegisterEffect(e2,tp)
		end
	end
end