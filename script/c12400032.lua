--强制结束
function c12400032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c12400032.condition)
	e1:SetTarget(c12400032.target)
	e1:SetOperation(c12400032.activate)
	c:RegisterEffect(e1)
end
function c12400032.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=2
end
function c12400032.dfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsDestructable()
end
function c12400032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12400032.dfilter,tp,LOCATION_HAND,0,1,nil) end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		ng:AddCard(tc)
		if not tc:IsDisabled() and tc:IsRelateToEffect(te) then
			dg:AddCard(tc)
		end
	end
	Debug.ShowHint(ng:GetCount())
	Debug.ShowHint(ng:FilterCount(Card.IsCode,nil,12400022))
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c12400032.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c12400016.dfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.Destroy(g,REASON_EFFECT)
	for i=1,ev do
		Duel.NegateEffect(i)
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then
			dg:AddCard(tc)
		end
	end
end
