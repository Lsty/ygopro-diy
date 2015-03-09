--第三精灵 「时崎狂三」
function c127806.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c127806.cost)
	e1:SetTarget(c127806.destg)
	e1:SetOperation(c127806.desop)
	c:RegisterEffect(e1)
end
function c127806.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_MONSTER)
end
function c127806.costfilter(c)
	return c:IsSetCard(0x9fb) and c:IsAbleToGrave()
end
function c127806.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c127806.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c127806.filter,tp,0,LOCATION_MZONE,1,nil) and 
		Duel.IsExistingMatchingCard(c127806.costfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(c127806.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c127806.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectMatchingCard(tp,c127806.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g=Duel.SelectMatchingCard(tp,c127806.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 and tg:GetCount()>0 then
		Duel.SendtoGrave(tg,REASON_COST)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
