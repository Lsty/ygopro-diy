--幻想镜现诗·幻想净琉璃
function c19300086.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,19300086+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c19300086.target)
	e1:SetOperation(c19300086.activate)
	c:RegisterEffect(e1)
end
function c19300086.filter(c,e)
	return c:IsSetCard(0x193) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c19300086.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c19300086.filter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return g:GetCount()>3
		and g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_SYNCHRO)
	g:Sub(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=g:Select(tp,3,3,nil)
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c19300086.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=4 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==4 then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
