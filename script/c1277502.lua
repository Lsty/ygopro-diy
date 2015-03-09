--月世界 空想具现化
function c1277502.initial_effect(c)
	aux.AddRitualProcEqual(c,c1277502.ritual_filter)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(1264319,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1277502.thcost)
	e2:SetTarget(c1277502.thtg)
	e2:SetOperation(c1277502.thop)
	c:RegisterEffect(e2)
end
function c1277502.ritual_filter(c)
	return c:IsSetCard(0x9fc) and bit.band(c:GetType(),0x81)==0x81
end
function c1277502.thfilter(c)
	return c:IsSetCard(0x9fc) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_RITUAL)
end
function c1277502.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1277502.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1277502.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1277502.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c1277502.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
