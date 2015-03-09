--克音
function c32100009.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c32100009.xyzfilter,4,2)
	c:EnableReviveLimit()
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c32100009.target)
	e1:SetOperation(c32100009.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c32100009.cost)
	e2:SetTarget(c32100009.target1)
	e2:SetOperation(c32100009.operation1)
	c:RegisterEffect(e2)
end
function c32100009.xyzfilter(c)
	return c:GetTextAttack()==-2 and c:GetTextDefence()==-2
end
function c32100009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c32100009.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local dice=Duel.TossDice(tp,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(dice*500)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENCE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(dice*500)
		c:RegisterEffect(e2)
	end
end
function c32100009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c32100009.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c32100009.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local dice=Duel.TossDice(tp,1)
	if dice==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif dice==2 then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then return end
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		Duel.ConfirmCards(tp,g1)
		Duel.ConfirmCards(1-tp,g2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local sg2=g2:Select(1-tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	elseif dice==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif dice==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	elseif dice==5 then
		Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
	else
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		Duel.SetLP(tp,Duel.GetLP(tp)/2)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
	end
end