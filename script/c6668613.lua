--要石『天地开辟之挤压』
function c6668613.initial_effect(c)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,6668613+EFFECT_COUNT_CODE_OATH)
	e4:SetTarget(c6668613.target1)
	e4:SetOperation(c6668613.operation1)
	c:RegisterEffect(e4)
end
function c6668613.filter1(c)
	return c:IsFaceup() and (c:IsSetCard(0x740) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0x741)
end
function c6668613.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c6668613.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6668613.filter1,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c6668613.filter1,tp,LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c6668613.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)>0 then
	local ct=sg:GetCount()
	local ct=ct-1
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.Destroy(dg,REASON_EFFECT)
	end
end