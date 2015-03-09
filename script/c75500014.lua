--梦日记-黄泉
function c75500014.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x755),4,2)
	c:EnableReviveLimit()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c75500014.cost)
	e1:SetTarget(c75500014.target)
	e1:SetOperation(c75500014.operation)
	c:RegisterEffect(e1)
end
function c75500014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c75500014.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c75500014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_EXTRA,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c75500014.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_EXTRA,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	local ct=sg:GetFirst()
	if ct:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WATER) and ct:GetAttack()>0 then
		Duel.Damage(1-tp,ct:GetAttack()/2,REASON_EFFECT)
	elseif ct:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_WIND) and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 then
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
	elseif ct:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and Duel.IsExistingMatchingCard(c75500014.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c75500014.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end