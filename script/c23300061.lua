--Baka逼真的演技
function c23300061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c23300061.cost)
	e1:SetTarget(c23300061.target)
	e1:SetOperation(c23300061.activate)
	c:RegisterEffect(e1)
end
function c23300061.cfilter(c)
	return c:IsSetCard(0x233) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c23300061.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23300061.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c23300061.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c23300061.filter(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c23300061.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==1-tp and chkc:IsLocation(LOCATION_SZONE) and c23300061.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23300061.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,250)
end
function c23300061.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,250,REASON_EFFECT) then
		local tc=Duel.SelectTarget(tp,c23300061.filter,tp,0,LOCATION_SZONE,1,1,nil)
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
