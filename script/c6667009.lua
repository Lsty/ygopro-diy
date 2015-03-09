--魔物猎人 狩猎完成
function c6667009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c6667009.target)
	e1:SetOperation(c6667009.activate)
	c:RegisterEffect(e1)
end
function c6667009.cfilter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x790)
end
function c6667009.cfilter2(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x791)
end
function c6667009.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c6667009.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and 
	Duel.IsExistingTarget(c6667009.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c6667009.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c6667009.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c6667009.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)>0 then
    Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
    Duel.Draw(tp,2,REASON_EFFECT)
	end
end