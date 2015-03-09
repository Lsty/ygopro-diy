--魔王少女的召集令
function c187187008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,187187008)
	e1:SetTarget(c187187008.target)
	e1:SetOperation(c187187008.activate)
	c:RegisterEffect(e1)
end
function c187187008.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3abb)
end
function c187187008.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xabb)
end
function c187187008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local b1=Duel.IsExistingTarget(c187187008.filter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingTarget(c187187008.filter2,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(10187,11),aux.Stringid(10187,12))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(10187,11))
	else op=Duel.SelectOption(tp,aux.Stringid(10187,12))+1 end
	e:SetLabel(op)
	if op==0 then
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
end
function c187187008.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c187187008.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	else
	Duel.DiscardHand(tp,c187187008.filter2,1,1,REASON_EFFECT+REASON_DISCARD)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
end