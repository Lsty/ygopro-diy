--call
function c187023016.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73176465,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c187023016.con)
	e1:SetCost(c187023016.cost)
	e1:SetTarget(c187023016.destg)
	e1:SetOperation(c187023016.desop)
	c:RegisterEffect(e1)
	--direct
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31437713,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c187023016.negcost)
	e4:SetTarget(c187023016.thtg)
	e4:SetOperation(c187023016.thop)
	c:RegisterEffect(e4)
end
function c187023016.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
		and re:GetHandler():IsSetCard(0x257) and not e:GetHandler():IsReason(REASON_RETURN)
end
function c187023016.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c187023016.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c187023016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,187023016)==0 end
	Duel.RegisterFlagEffect(tp,187023016,RESET_PHASE+PHASE_END,0,1)
end
function c187023016.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,187023016)==0 and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,187023016,RESET_PHASE+PHASE_END,0,1)
end
function c187023016.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x257) and c:IsAbleToHand()
end
function c187023016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c187023016.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c187023016.thfilter,tp,LOCATION_GRAVE,0,2,nil) and Duel.GetFlagEffect(tp,187023016)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c187023016.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.RegisterFlagEffect(tp,187023016,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c187023016.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end