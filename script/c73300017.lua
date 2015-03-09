--绯红恶魔 蕾米莉亚·斯卡雷特
function c73300017.initial_effect(c)
	c:SetUniqueOnField(1,0,73300017)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x733),4,2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c73300017.aclimit)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c73300017.cost)
	e2:SetTarget(c73300017.target)
	e2:SetOperation(c73300017.operation)
	c:RegisterEffect(e2)
	--cannot trigger
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c73300017.efilter)
	c:RegisterEffect(e3)
end
function c73300017.aclimit(e,re,tp)
	return not (re:GetHandler():IsSetCard(0x733) or re:GetHandler():IsSetCard(0x734) or re:GetHandler():GetCode()==73300034 or re:GetHandler():GetCode()==73300020 or re:GetHandler():GetCode()==87700018)
end
function c73300017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c73300017.filter(c)
	return c:IsSetCard(0x734) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c73300017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c73300017.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c73300017.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c73300017.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function c73300017.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end