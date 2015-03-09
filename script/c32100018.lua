--＼(・ω・＼)SAN值!(/・ω・)/危机!
function c32100018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c32100018.condition)
	e1:SetTarget(c32100018.target)
	e1:SetOperation(c32100018.activate)
	c:RegisterEffect(e1)
end
function c32100018.cfilter(c)
	return c:IsFaceup() and c:GetTextAttack()==-2 and c:GetTextDefence()==-2
end
function c32100018.condition(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not Duel.IsExistingMatchingCard(c32100018.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c32100018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c32100018.activate(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==2 or dc==3 then
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	elseif dc==4 or dc==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	else
		Duel.SetLP(tp,Duel.GetLP(tp)/2)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
	end
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end