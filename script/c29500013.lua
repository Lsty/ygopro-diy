--女子落
function c29500013.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c29500013.target)
	e1:SetOperation(c29500013.operation)
	c:RegisterEffect(e1)
end
function c29500013.filter(c,e,tp)
	return c:IsSetCard(0x295) and c:IsMSetable(true,nil)
end
function c29500013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c29500013.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c29500013.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c29500013.filter,tp,LOCATION_HAND,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.MSet(tp,tc,true,nil)
			tc=g:GetNext()
		end
	end
end