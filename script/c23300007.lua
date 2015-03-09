--Baka嫉妒成狂的FFF团
function c23300007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c23300007.target)
	e1:SetOperation(c23300007.operation)
	c:RegisterEffect(e1)
end
function c23300007.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x233) and c:IsAbleToHand()
end
function c23300007.cfilter(c)
	return c:IsType(TYPE_MONSTER) and not (c:IsSetCard(0x233) and c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsAbleToHand()
end
function c23300007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c23300007.filter,tp,LOCATION_MZONE,0,3,nil) end
	local sg=Duel.GetMatchingGroup(c23300007.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c23300007.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c23300007.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
