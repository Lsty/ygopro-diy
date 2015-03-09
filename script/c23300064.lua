--Baka愤怒的化身
function c23300064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(1)
	e1:SetCost(c23300064.cost)
	e1:SetTarget(c23300064.target)
	e1:SetOperation(c23300064.activate)
	c:RegisterEffect(e1)
end
function c23300064.cfilter(c,def)
	return c:IsSetCard(0x256) and c:IsAttackAbove(def)
end
function c23300064.filter(c,atk)
	return c:IsFaceup() and c:IsDestructable() and (not atk or c:IsDefenceBelow(atk))
end
function c23300064.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c23300064.filter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()==0 then return false end
		local mg,mdef=g:GetMinGroup(Card.GetDefence)
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c23300064.cfilter,1,nil,mdef)
	end
	local g=Duel.GetMatchingGroup(c23300064.filter,tp,0,LOCATION_MZONE,nil)
	local mg,mdef=g:GetMinGroup(Card.GetDefence)
	local rg=Duel.SelectReleaseGroup(tp,c23300064.cfilter,1,1,nil,mdef)
	e:SetLabel(rg:GetFirst():GetAttack())
	Duel.Release(rg,REASON_COST)
end
function c23300064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==0 end
	local dg=Duel.GetMatchingGroup(c23300064.filter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c23300064.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c23300064.filter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.Destroy(dg,REASON_EFFECT)
end
