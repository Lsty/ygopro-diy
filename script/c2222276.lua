--姐妹的再会=见异思迁？！
function c2222276.initial_effect(c)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c2222276.cost)
	e1:SetTarget(c2222276.target)
	e1:SetOperation(c2222276.operation)
	c:RegisterEffect(e1)
end
function c2222276.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,2,nil,0xa74) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,2,2,nil,0xa74)
	Duel.Release(g,REASON_COST)
end
function c2222276.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,2)
end
function c2222276.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0,nil)
	local sg=g:RandomSelect(1-tp,2)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end