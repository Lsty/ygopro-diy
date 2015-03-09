--乌洛波洛斯
function c73300007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c73300007.cost)
	e1:SetTarget(c73300007.target)
	e1:SetOperation(c73300007.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCondition(c73300007.thcon)
	e2:SetCost(c73300007.thcost)
	e2:SetTarget(c73300007.thtg)
	e2:SetOperation(c73300007.thop)
	c:RegisterEffect(e2)
end
function c73300007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,73300007)==0 and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,73300007,RESET_PHASE+PHASE_END,0,1)
end
function c73300007.filter1(c)
	return c:IsFaceup() and c:GetRank()==4 and c:IsType(TYPE_XYZ) and c:IsRace(RACE_SPELLCASTER+RACE_FIEND)
end
function c73300007.filter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c73300007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c73300007.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c73300007.filter2,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(73300007,0))
	local g1=Duel.SelectTarget(tp,c73300007.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(73300007,1))
	local g2=Duel.SelectTarget(tp,c73300007.filter2,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,2,0,0)
end
function c73300007.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,tc,e)
	local oc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.Overlay(tc,g)
	end
end
function c73300007.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c73300007.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,73300007)==0 end
	Duel.RegisterFlagEffect(tp,73300007,RESET_PHASE+PHASE_END,0,1)
end
function c73300007.tdfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c73300007.tdfilter1(c)
	return c:GetLevel()==4 and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand() and not c:IsCode(73300007)
end
function c73300007.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c73300007.tdfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c73300007.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c73300007.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(c73300007.tdfilter1,tp,LOCATION_GRAVE,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
			local g=Duel.SelectMatchingCard(tp,c73300007.tdfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end