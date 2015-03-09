--界外科学
function c19900042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c19900042.target)
	e1:SetOperation(c19900042.activate)
	c:RegisterEffect(e1)
end
function c19900042.cfilter(c)
	return c:IsSetCard(0x199) and c:IsDestructable()
end
function c19900042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19900042.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19900042.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c19900042.cfilter,tp,LOCATION_MZONE,0,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c19900042.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e,0,tp,false,false)
	Duel.Destroy(sg,REASON_EFFECT)
	local ct=sg:GetCount()
	Duel.Draw(tp,ct,REASON_EFFECT)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
