--时符·假想时轴
function c98700019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c98700019.condition)
	e1:SetCost(c98700019.cost)
	e1:SetTarget(c98700019.target)
	e1:SetOperation(c98700019.activate)
	c:RegisterEffect(e1)
end
function c98700019.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c98700019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98700019)==0 end
	Duel.RegisterFlagEffect(tp,98700019,RESET_PHASE+PHASE_END,0,1)
end
function c98700019.filter(c,e)
	return c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c98700019.filter1(c,e)
	return c:IsSetCard(0x987) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c98700019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c98700019.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
	if chk==0 then return Duel.GetCurrentChain()<1 or (Duel.IsExistingMatchingCard(c98700019.filter1,tp,LOCATION_GRAVE,0,2,nil,e) and Duel.IsPlayerCanDraw(tp,1)) end
	if Duel.GetCurrentChain()>1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=Duel.SelectMatchingCard(tp,c98700019.filter1,tp,LOCATION_GRAVE,0,2,2,nil,e)
		g:Sub(g1)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98700019,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g2=g:Select(tp,1,2,nil)
			g1:Merge(g2)
		end
		Duel.SetTargetCard(g1)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c98700019.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c98700019.damval)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local c=e:GetHandler()
	local ct=Duel.GetCurrentChain()
	if ct>=2 then
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		local cf=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if cf>0 then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c98700019.damval(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return dam/2
	else return dam end
end