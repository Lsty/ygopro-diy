--封魔月见术式
function c128809.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c128809.condition)
	e1:SetTarget(c128809.target)
	e1:SetOperation(c128809.activate)
	c:RegisterEffect(e1)
end
function c128809.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c128809.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c128809.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x9fe)
end
function c128809.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c128809.cfilter,tp,LOCATION_MZONE,0,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local opt=0
	if g1:GetCount()>0 and g3:GetCount()>1 then
		local ec=re:GetHandler()
		local g4=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,1-tp,LOCATION_GRAVE,0,2,2,nil)
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			ec:CancelToGrave()
			Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
			Duel.Remove(g4,POS_FACEUP,REASON_EFFECT)
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
	if g1:GetCount()>0 and g3:GetCount()<2 then
			local ec=re:GetHandler()
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			ec:CancelToGrave()
			Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
		end
	end
	if g3:GetCount()>1 and Duel.IsChainNegatable(ev) and g1:GetCount()==0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(128809,1),aux.Stringid(128809,2))
	elseif Duel.IsChainNegatable(ev) and g1:GetCount()==0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(128809,1))
	elseif g3:GetCount()>1 and g1:GetCount()==0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(128809,2))+1
	else return end
	if opt==0 then
		local ec=re:GetHandler()
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			ec:CancelToGrave()
			Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
		end
	else
		local g5=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,1-tp,LOCATION_GRAVE,0,2,2,nil)
		Duel.Remove(g5,POS_FACEUP,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
