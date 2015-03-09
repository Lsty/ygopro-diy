--01
function c18718701.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),4,2)
	c:EnableReviveLimit()
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,18718701)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c18718701.descost)
	e2:SetTarget(c18718701.destg)
	e2:SetOperation(c18718701.desop)
	c:RegisterEffect(e2)
end
function c18718701.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c18718701.desfilter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c18718701.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c18718701.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18718701.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c18718701.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c18718701.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,187187025) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end