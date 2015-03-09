--月见天使 圣枪辉白灵
function c128817.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(128817,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,128817)
	e2:SetCost(c128817.tdcost)
	e2:SetTarget(c128817.tdtg)
	e2:SetOperation(c128817.tdop)
	c:RegisterEffect(e2)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(35952884,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c128817.sumcon)
	e4:SetTarget(c128817.thtg)
	e4:SetOperation(c128817.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
end
function c128817.filter1(c)
	return c:IsSetCard(0x9fe) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c128817.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c128817.filter1,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c128817.filter1,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c128817.tdfilter(c)
	return c:IsAbleToDeck()
end
function c128817.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c128817.tdfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c128817.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c128817.tdfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c128817.sumcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c128817.thfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function c128817.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c128817.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c128817.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c128817.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c128817.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end