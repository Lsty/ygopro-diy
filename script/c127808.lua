--食时之城
function c127808.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1)
	e3:SetCondition(c127808.regcon)
	e3:SetOperation(c127808.thop)
	c:RegisterEffect(e3)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c127808.ctcon)
	e2:SetOperation(c127808.ctop)
	c:RegisterEffect(e2)
end
function c127808.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
	and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()==1-tp
end
function c127808.thfilter(c)
	return c:IsSetCard(0x9fa) and c:IsAbleToHand()
end
function c127808.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c127808.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(127808,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		g1:Merge(g2)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(127808,1)) then
			g2=g:Select(tp,1,1,nil)
			g1:Merge(g2)
		end
	end
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end
function c127808.cfilter(c)
	return c:IsSetCard(0x9fa) and c:IsType(TYPE_MONSTER)
end
function c127808.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:IsExists(c127808.cfilter,1,nil)
end
function c127808.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:Filter(c127808.cfilter,nil):GetCount()
	e:GetHandler():AddCounter(0x16,ct)
end
function c127808.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
