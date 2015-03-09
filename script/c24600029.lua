--戏言·愚神礼赞·零崎轧识
function c24600029.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c24600029.cost)
	e1:SetTarget(c24600029.target)
	e1:SetOperation(c24600029.operation)
	c:RegisterEffect(e1)
end
function c24600029.costfilter(c)
	return c:IsSetCard(0x246) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c24600029.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c24600029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24600029.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.GetFlagEffect(tp,24600029)==0 and e:GetHandler():IsDiscardable() end
	local rt=Duel.GetTargetCount(c24600029.filter,tp,0,LOCATION_ONFIELD,nil)
	if rt>2 then rt=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=Duel.SelectMatchingCard(tp,c24600029.costfilter,tp,LOCATION_HAND,0,1,rt,e:GetHandler())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	Duel.SendtoGrave(cg,REASON_COST+REASON_DISCARD)
	e:SetLabel(cg:GetCount())
	Duel.RegisterFlagEffect(tp,24600029,RESET_PHASE+PHASE_END,0,1)
end
function c24600029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c24600029.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24600029.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local eg=Duel.SelectTarget(tp,c24600029.filter,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,ct,0,0)
end
function c24600029.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then 
		Duel.Destroy(rg,REASON_EFFECT)
	end
end
