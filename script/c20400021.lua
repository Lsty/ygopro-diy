--FG204 2nd EDITION ver2.31
function c20400021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,20400021+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c20400021.target)
	e1:SetOperation(c20400021.activate)
	c:RegisterEffect(e1)
end
function c20400021.rfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToRemove()
end
function c20400021.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToGrave()
end
function c20400021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20400021.rfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c20400021.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c20400021.rfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0
		and Duel.IsExistingMatchingCard(c20400021.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(20400021,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c20400021.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
end
