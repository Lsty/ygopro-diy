--花蝶之魔姬
function c66600016.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c66600016.xyzfilter,4,2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c66600016.spcost)
	e1:SetCondition(c66600016.spcon)
	e1:SetTarget(c66600016.sptg)
	e1:SetOperation(c66600016.spop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_LEAVE_GRAVE)
	e2:SetCost(c66600016.ccost)
	e2:SetTarget(c66600016.destg)
	e2:SetOperation(c66600016.desop)
	c:RegisterEffect(e2)
end
function c66600016.xyzfilter(c)
	return c:IsSetCard(0x666) or c:IsRace(RACE_INSECT)
end
function c66600016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,66600016)==0 end
	Duel.RegisterFlagEffect(tp,66600016,RESET_PHASE+PHASE_END,0,1)
end
function c66600016.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
function c66600016.tfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsAbleToHand() and c:IsType(TYPE_TRAP)
end
function c66600016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66600016.tfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66600016.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66600016.tfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66600016.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
		and Duel.GetFlagEffect(tp,166600016)==0 end
	Duel.RegisterFlagEffect(tp,166600016,RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c66600016.filter(c)
	return c:IsSetCard(0x666) and c:IsAbleToHand() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c66600016.desfilter(c)
	return c:IsSetCard(0x666) and c:IsFaceup() and c:IsAbleToGrave()
end
function c66600016.spfilter(c,e,tp)
	return c:GetType()==TYPE_TRAP and c:IsSSetable()
end
function c66600016.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c66600016.desfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c66600016.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c66600016.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g2=Duel.SelectTarget(tp,c66600016.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
	e:SetLabelObject(g1:GetFirst())
end
function c66600016.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc1:IsControler(tp) and tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)>0 and tc2:IsRelateToEffect(e) then
		Duel.SSet(tp,tc2)
	end
end