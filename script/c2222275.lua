--观览车与黄昏与密语
function c2222275.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c2222275.condition)
	e1:SetTarget(c2222275.destg)
	e1:SetOperation(c2222275.desop)
	c:RegisterEffect(e1)
end
function c2222275.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x2a74)
end
function c2222275.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2222275.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c2222275.desfilter(c)
	return c:IsSetCard(0xa74) and c:IsAbleToDeck()
end
function c2222275.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c2222275.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2222275.desfilter,tp,LOCATION_EXTRA,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c2222275.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,c2222275.desfilter,tp,LOCATION_EXTRA,0,3,3,nil)
	if tg:GetCount()==3 then
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end