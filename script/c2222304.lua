--灾星·乖离
function c2222304.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2222304,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c2222304.discon)
	--e1:SetCost(c2222304.cost1)
	e1:SetTarget(c2222304.distg1)
	e1:SetOperation(c2222304.disop1)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2222304,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	--e2:SetCost(c2222304.cost1)
	e2:SetCondition(c2222304.discon)
	e2:SetTarget(c2222304.distg2)
	e2:SetOperation(c2222304.disop2)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2222304,2))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	--e3:SetCost(c2222304.cost1)
	e3:SetCondition(c2222304.discon)
	e3:SetTarget(c2222304.distg3)
	e3:SetOperation(c2222304.disop3)
	c:RegisterEffect(e3)  
end
function c2222304.hfilter(c)
	return c:IsFaceup() and (c:IsCode(2222221) or c:IsCode(2222223))
end
function c2222304.filter(c,p)
	return c:GetControler()==p and c:IsOnField()
end
function c2222304.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not Duel.IsExistingMatchingCard(c2222304.hfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c2222304.filter,nil,tp)-tg:GetCount()>2 and not ep~=tp
end
function c2222304.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,5000)
	else Duel.PayLPCost(tp,5000) end
end
function c2222304.distg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c2222304.disop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		Duel.NegateEffect(ev)
		if tc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
end
end
function c2222304.dfilter(c)
	return c:IsCode(2222222) and c:IsDiscardable()
end
function c2222304.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222304.dfilter,tp,LOCATION_HAND,0,1,nil) and 
	Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
end
function c2222304.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.DiscardHand(tp,c2222304.dfilter,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		Duel.NegateEffect(ev)
		if tc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end
end
end
function c2222304.dfilter2(c)
	return c:IsCode(2222222) and c:IsDiscardable()
end
function c2222304.dfilter3(c)
	return c:IsCode(2222226) and c:IsDiscardable()
end
function c2222304.distg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222304.dfilter2,tp,LOCATION_HAND,0,1,nil) and 
	Duel.IsExistingMatchingCard(c2222304.dfilter3,tp,LOCATION_HAND,0,1,nil) and 
	Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and
	Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE+LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
end
function c2222304.dfilter4(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c2222304.disop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.DiscardHand(tp,c2222304.dfilter2,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	local cg=Duel.DiscardHand(tp,c2222304.dfilter3,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		Duel.NegateEffect(ev)
		if tc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_MZONE)
	Duel.ConfirmCards(tp,g)
	local sg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	if sg:GetCount()>0 then
		local atk=0
		Duel.Destroy(sg,REASON_EFFECT)
		local tc=sg:GetFirst()
		while tc do
			local tatk=tc:GetAttack()
			if tatk<0 then tatk=0 end
			atk=atk+tatk
			tc=sg:GetNext()
		end
		Duel.BreakEffect()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end
end
end