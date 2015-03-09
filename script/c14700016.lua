--神葬「夜雀结界」
function c14700016.initial_effect(c)
	--discard deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c14700016.distarget)
	e1:SetOperation(c14700016.disop)
	c:RegisterEffect(e1)
	--sset
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c14700016.descon)
	e2:SetCost(c14700016.setcost)
	e2:SetTarget(c14700016.settg)
	e2:SetOperation(c14700016.setop)
	c:RegisterEffect(e2)
end
function c14700016.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c14700016.filter(c)
	return c:IsSetCard(0x147) and c:IsType(TYPE_TRAP)
end
function c14700016.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,val,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup()
	local d=dg:FilterCount(c14700016.filter,nil)
	if d>0 then Duel.Draw(tp,1,REASON_EFFECT) end
end
function c14700016.cfilter1(c)
	return not (c:IsSetCard(0x147) or (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_AQUA)))
end
function c14700016.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount() and not Duel.IsExistingMatchingCard(c14700016.cfilter1,tp,LOCATION_GRAVE,0,1,nil)
end
function c14700016.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c14700016.filter1(c)
	return c:IsSetCard(0x147) and c:IsAbleToGrave()
end
function c14700016.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14700016.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c14700016.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c14700016.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
