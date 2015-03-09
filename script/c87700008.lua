--直死之魔眼 芙兰朵露·斯卡雷特
function c87700008.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x877),4,2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(c87700008.etarget)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c87700008.cost)
	e2:SetTarget(c87700008.target)
	e2:SetOperation(c87700008.operation)
	c:RegisterEffect(e2)
end
function c87700008.etarget(e,c)
	return c:IsType(TYPE_TRAP) and (c:IsSetCard(0x878) or c:IsSetCard(0x879))
end
function c87700008.costfilter(c)
	return c:IsType(TYPE_TRAP) and (c:IsSetCard(0x878) or c:IsSetCard(0x879)) and c:IsAbleToRemoveAsCost()
end
function c87700008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and Duel.IsExistingMatchingCard(c87700008.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local rt=Duel.GetTargetCount(c87700008.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if rt>2 then rt=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c87700008.costfilter,tp,LOCATION_GRAVE,0,1,rt,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c87700008.desfilter(c)
	return c:IsDestructable() and c:IsAbleToRemove()
end
function c87700008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c87700008.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c87700008.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local eg=Duel.SelectTarget(tp,c87700008.desfilter,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,ct,0,0)
end
function c87700008.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then 
		Duel.Destroy(rg,REASON_EFFECT,LOCATION_REMOVED)
	end
end