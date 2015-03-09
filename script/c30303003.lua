--GAIA
function c30303003.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),4,2)
	c:EnableReviveLimit()
	--POS
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,30303003)
	e1:SetCost(c30303003.cost)
	e1:SetTarget(c30303003.target)
	e1:SetOperation(c30303003.operation)
	c:RegisterEffect(e1)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13959634,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1,30303003)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c30303003.tg)
	e1:SetOperation(c30303003.op)
	c:RegisterEffect(e1)
end
function c30303003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c30303003.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsAbleToGrave() 
end
function c30303003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c30303003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c30303003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SelectOption(tp,aux.Stringid(30303003,1))
	Duel.SelectOption(1-tp,aux.Stringid(30303003,1))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function c30303003.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c30303003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c30303003.filter1(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and c:IsPreviousLocation(LOCATION_EXTRA) and not c:IsType(TYPE_PENDULUM)
end
function c30303003.filter2(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and c:IsPreviousLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM)
end
function c30303003.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c30303003.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
	                        or Duel.IsExistingMatchingCard(c30303003.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c30303003.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SelectOption(tp,aux.Stringid(30303003,0))
	Duel.SelectOption(1-tp,aux.Stringid(30303003,0))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c30303003.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c30303003.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
    if sg and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) then
	local ag=Duel.GetMatchingGroup(c30303003.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoGrave(ag,REASON_EFFECT)
	end
end