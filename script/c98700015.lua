--时符·银之锐角360度
function c98700015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c98700015.condition)
	e1:SetCost(c98700015.cost)
	e1:SetTarget(c98700015.target)
	e1:SetOperation(c98700015.activate)
	c:RegisterEffect(e1)
end
function c98700015.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c98700015.filter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x987) and c:IsAbleToGraveAsCost()
end
function c98700015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98700015)==0 and Duel.IsExistingMatchingCard(c98700015.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98700015.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.RegisterFlagEffect(tp,98700015,RESET_PHASE+PHASE_END,0,1)
end
function c98700015.filter1(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsType(TYPE_EFFECT)
end
function c98700015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and (Duel.GetCurrentChain()<1 or Duel.IsExistingMatchingCard(c98700015.filter1,tp,0,LOCATION_MZONE,1,nil)) end
	if Duel.GetCurrentChain()>1 then
		local g=Duel.GetMatchingGroup(c98700015.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c98700015.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,2,REASON_EFFECT)
	local ct=Duel.GetCurrentChain()
	if ct>1 then
		local g=Duel.GetMatchingGroup(c98700015.filter1,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENCE)
		end
	end
end