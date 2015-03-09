--最后的封印
function c11111047.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c11111047.condition)
	e1:SetCost(c11111047.cost)
	e1:SetTarget(c11111047.target)
	e1:SetOperation(c11111047.activate)
	c:RegisterEffect(e1)
end
function c11111047.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c11111047.cfilter(c)
	return c:IsFaceup() and c:IsRankAbove(8) and c:IsRace(RACE_FAIRY+RACE_SPELLCASTER) and c:IsAbleToRemoveAsCost()
end
function c11111047.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111047.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11111047.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	e:SetLabelObject(g:GetFirst())
end
function c11111047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11111047.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
	   Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end   
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
    local tc=e:GetLabelObject()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	if Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,3)
	else
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	end
	e1:SetLabelObject(tc)
	e1:SetCountLimit(1)
	e1:SetOperation(c11111047.retop)
	tc:SetTurnCounter(0)
	Duel.RegisterEffect(e1,tp)
end
function c11111047.mfilter(c)
    return c:IsCode(11111047) and c:IsType(TYPE_TRAP) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end	
function c11111047.retop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetTurnPlayer()~=tp then return end
	local c=e:GetLabelObject()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
	    if Duel.ReturnToField(c) then
		   local g=Duel.GetMatchingGroup(c11111047.mfilter,tp,LOCATION_GRAVE,0,nil)
		   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11111047,0))then
		      Duel.BreakEffect()
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			  local mg=g:Select(tp,1,1,nil)
			  Duel.Overlay(c,mg)
		    end  
		end	
	end
end