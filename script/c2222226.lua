--具王之怒
function c2222226.initial_effect(c)
      --remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2222226,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c2222226.cost)
	e1:SetCondition(c2222226.descon)
	e1:SetTarget(c2222226.destg)
	e1:SetOperation(c2222226.desop)
	c:RegisterEffect(e1)
end
function c2222226.hfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x203)
end
function c2222226.descon(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0) 
and Duel.GetLP(tp)<=4000
and Duel.IsExistingMatchingCard(c2222226.hfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c2222226.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		g:RemoveCard(e:GetHandler())
		return g:GetCount()>0 and g:FilterCount(Card.IsDiscardable,nil)==g:GetCount()
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c2222226.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c2222226.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
	local ct=Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
         if ct>0 then
	      Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
end
