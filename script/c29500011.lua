--笑颜百景
function c29500011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c29500011.condition)
	e1:SetTarget(c29500011.target)
	e1:SetOperation(c29500011.activate)
	c:RegisterEffect(e1)
end
function c29500011.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x295)
end
function c29500011.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29500011.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,3,nil)
end
function c29500011.dfilter(c)
	return not (c:IsFaceup() and c:IsSetCard(0x295)) and c:IsDestructable()
end
function c29500011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c29500011.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local g=Duel.GetMatchingGroup(c29500011.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c29500011.activate(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.GetMatchingGroup(c29500011.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g0,REASON_EFFECT)
end
