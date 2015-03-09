--神葬「诱捕结界」
function c14700008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c14700008.condition)
	e1:SetTarget(c14700008.target)
	e1:SetOperation(c14700008.activate)
	c:RegisterEffect(e1)
end
function c14700008.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_AQUA)
end
function c14700008.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or rp==tp then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c14700008.cfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c14700008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c14700008.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	Duel.NegateActivation(ev)
	if tg:IsExists(c14700008.cfilter,1,nil) and re:GetHandler():IsRelateToEffect(re)
		and re:GetHandler():IsAbleToChangeControler() and not re:GetHandler():IsType(TYPE_TOKEN)
		and not re:GetHandler():IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=tg:FilterSelect(tp,c14700008.cfilter,1,1,nil)
		local sg1=sg:GetFirst()
		local og=re:GetHandler():GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(sg1,Group.FromCards(re:GetHandler()))
	end
end
