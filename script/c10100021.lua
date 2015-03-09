--操控黑夜的恶魔 露米娅
function c10100021.initial_effect(c)
	c:SetUniqueOnField(1,0,10100021)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa10),3,2)
	c:EnableReviveLimit()
	--untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(c10100021.uttg)
	e1:SetValue(c10100021.efilter)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10100021.descost)
	e2:SetTarget(c10100021.sptg)
	e2:SetOperation(c10100021.spop)
	c:RegisterEffect(e2)
end
function c10100021.uttg(e,c)
	return c:IsType(TYPE_EQUIP)
end
function c10100021.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
function c10100021.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10100021.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsSetCard(0xa10) and c:IsAbleToHand()
end
function c10100021.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c10100021.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10100021.filter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g1=Duel.SelectTarget(tp,c10100021.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,HINTMSG_TOHAND,g1,g1:GetCount(),0,0)
end
function c10100021.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end