--幻想镜现诗·少女密室
function c19300055.initial_effect(c)
	c:SetUniqueOnField(1,0,19300055)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c19300055.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(c19300055.rfilter)
	e2:SetValue(0x1)
	c:RegisterEffect(e2)
end
function c19300055.filter(c)
	return c:GetLevel()==5 and c:IsSetCard(0x193) and c:IsAbleToHand()
end
function c19300055.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c19300055.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(19300055,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c19300055.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c19300055.rfilter(e,c)
	return c:IsSetCard(0x193)
end