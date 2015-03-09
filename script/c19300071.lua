--幻想镜现诗·灵知的太阳信仰
function c19300071.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c19300071.target)
	e1:SetOperation(c19300071.operation)
	c:RegisterEffect(e1)
end
function c19300071.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x193) and c:IsDestructable()
end
function c19300071.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c19300071.filter2(chkc) end 
	if chk==0 then return Duel.IsExistingTarget(c19300071.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c19300071.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c19300071.filter(c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x193) and c:IsAbleToHand()
end
function c19300071.filter1(c)
	return c:IsDestructable() and c:IsAbleToRemove()
end
function c19300071.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c19300071.filter,tp,LOCATION_DECK,0,nil)
		local op=0
		local b1=Duel.IsExistingMatchingCard(c19300071.filter1,tp,0,LOCATION_ONFIELD,1,nil)
		local b2=g:GetCount()>0
		Duel.Hint(HINT_SELECTMSG,tp,0)
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(19300071,0),aux.Stringid(19300071,1))
		elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(19300071,0))
		elseif b2 then Duel.SelectOption(tp,aux.Stringid(19300071,1)) op=1
		else return end
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,c19300071.filter1,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT,LOCATION_REMOVED)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c19300071.filter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
