--无情澡堂
function c29500016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c29500016.target)
	e1:SetOperation(c29500016.activate)
	c:RegisterEffect(e1)
end
function c29500016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,30459350) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c29500016.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,p,LOCATION_HAND,0,nil,0x295)
	if g:GetCount()>0 and Duel.SelectOption(p,HINTMSG_DISCARD,HINTMSG_REMOVE) then
		Duel.DiscardHand(p,Card.IsSetCard,1,1,REASON_EFFECT+REASON_DISCARD,nil,0x295)
	else
		local sg=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,p,LOCATION_HAND,0,2,2,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
