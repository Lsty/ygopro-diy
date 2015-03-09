--原第一人偶 黑蔷薇爱丽丝
function c1278.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,2)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c1278.cost)
	e1:SetCondition(c1278.condition)
	e1:SetTarget(c1278.sptg)
	e1:SetOperation(c1278.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_GRAVE)
	e2:SetCondition(c1278.contp)
	c:RegisterEffect(e2)
end
function c1278.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c1278.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
end
function c1278.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c1278.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetFirst():IsRelateToEffect(re) and c:IsRelateToEffect(e) and not eg:GetFirst():IsImmuneToEffect(e) and not c:IsImmuneToEffect(e) then
		Duel.NegateActivation(ev)
		Duel.BreakEffect()
		local og=eg:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		local rc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		rc:AddCard(eg:GetFirst())
		Duel.Overlay(c,rc)
	end
end
function c1278.contp(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x21a)
	and not Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),EFFECT_NECRO_VALLEY_IM)
end
