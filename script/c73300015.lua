--星姬 蕾米莉亚·斯卡雷特
function c73300015.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c73300015.xyzfilter,4,2)
	c:EnableReviveLimit()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c73300015.cost)
	e1:SetTarget(c73300015.target)
	e1:SetOperation(c73300015.operation)
	c:RegisterEffect(e1)
end
function c73300015.xyzfilter(c)
	return c:IsSetCard(0x733)
end
function c73300015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c73300015.filter1(c)
	return c:IsLocation(LOCATION_GRAVE) and (c:IsSetCard(0x733) or c:IsSetCard(0x734)) and c:IsAbleToDeck()
end
function c73300015.filter2(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c73300015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c73300015.filter1,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c73300015.filter1,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,3,0,0)
end
function c73300015.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local dg=Duel.GetMatchingGroup(c73300015.filter2,tp,0,LOCATION_ONFIELD,nil)
	if dg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=dg:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
	end
end