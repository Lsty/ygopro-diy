--战场女武神 研究员
function c11113005.initial_effect(c)
    --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11113005,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11113005)
	e1:SetCost(c11113005.cost)
	e1:SetTarget(c11113005.target)
	e1:SetOperation(c11113005.operation)
	c:RegisterEffect(e1)
	--salvage 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1113005,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11113005)
	e2:SetTarget(c11113005.thtg)
	e2:SetOperation(c11113005.thop)
	c:RegisterEffect(e2)
end	
function c11113005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c11113005.filter(c)
	return c:IsSetCard(0x15c) and bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function c11113005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113005.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11113005.rmfilter(c)
	return c:IsSetCard(0x15c) and c:IsLevelBelow(4) and not c:IsCode(11113005) and c:IsAbleToRemove()
end
function c11113005.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11113005.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(c11113005.rmfilter,tp,LOCATION_GRAVE,0,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11113005,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg=sg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end	
	end
end
function c11113005.thfilter(c)
	return c:IsSetCard(0x15c) and bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToRemove()
end
function c11113005.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c11113005.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11113005.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c11113005.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c11113005.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetOperation(c11113005.rtop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		tc:RegisterEffect(e1)
	end
end
function c11113005.rtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end