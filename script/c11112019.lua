--灾难的开端
function c11112019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11112019+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c11112019.cost)
	e1:SetTarget(c11112019.target)
	e1:SetOperation(c11112019.activate)
	c:RegisterEffect(e1)
end
function c11112019.costfilter(c)
	return c:IsSetCard(0x15b) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c11112019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.IsExistingMatchingCard(c11112019.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c11112019.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c11112019.ftarget)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11112019.ftarget(e,c)
	return not c:IsSetCard(0x15b)
end
function c11112019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,4) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c11112019.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end