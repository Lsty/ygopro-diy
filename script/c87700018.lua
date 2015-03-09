--破坏之斯卡雷特
function c87700018.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c87700018.descon)
	e1:SetCost(c87700018.thcost)
	e1:SetTarget(c87700018.destg)
	e1:SetOperation(c87700018.desop)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCost(c87700018.thcost)
	e3:SetTarget(c87700018.target)
	e3:SetOperation(c87700018.operation)
	c:RegisterEffect(e3)
end
function c87700018.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x733) or re:GetHandler():IsSetCard(0x877) or re:GetHandler():GetCode()==73300034 or re:GetHandler():GetCode()==73300020
end
function c87700018.desfilter(c)
	return c:IsDestructable()
end
function c87700018.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_FIELD) and c87700018.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c87700018.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c87700018.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c87700018.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c87700018.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,87700018)==0 end
	Duel.RegisterFlagEffect(tp,87700018,RESET_PHASE+PHASE_END,0,1)
end
function c87700018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87700018.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c87700018.filter1(c)
	return c:GetCode()==73300034 and c:IsAbleToHand()
end
function c87700018.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetFirstMatchingCard(c87700018.filter1,tp,LOCATION_DECK,0,nil)
	if g then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end