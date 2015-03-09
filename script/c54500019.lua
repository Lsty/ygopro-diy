--Face to face -二人-
function c54500019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c54500019.cost)
	e1:SetTarget(c54500019.target)
	e1:SetOperation(c54500019.activate)
	c:RegisterEffect(e1)
end
function c54500019.filter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x545) and c:IsAbleToGraveAsCost()
end
function c54500019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,54500019)==0
		and Duel.IsExistingMatchingCard(c54500019.filter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c54500019.filter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.RegisterFlagEffect(tp,54500019,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c54500019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c54500019.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
