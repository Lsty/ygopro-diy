--女武神的赠礼
function c11113014.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11113014+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c11113014.cost)
	e1:SetTarget(c11113014.target)
	e1:SetOperation(c11113014.activate)
	c:RegisterEffect(e1)
end
function c11113014.costfilter(c)
	return c:IsSetCard(0x15c) and bit.band(c:GetType(),0x81)==0x81 and c:IsDiscardable()
end
function c11113014.cffilter(c)
	return c:IsSetCard(0x15c) and bit.band(c:GetType(),0x82)==0x82 and not c:IsPublic()
end
function c11113014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113014.costfilter,tp,LOCATION_HAND,0,1,nil) 
	    and Duel.IsExistingMatchingCard(c11113014.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c11113014.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11113014.cffilter,tp,0x2,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+RESET_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11113014.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c11113014.splimit(e,c)
	return not c:IsSetCard(0x15c)
end
function c11113014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c11113014.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end