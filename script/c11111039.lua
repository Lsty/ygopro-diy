--消逝的情感
function c11111039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c11111039.condition)
	e1:SetCost(c11111039.cost)
	e1:SetTarget(c11111039.target)
	e1:SetOperation(c11111039.activate)
	c:RegisterEffect(e1)
end
function c11111039.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c11111039.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15d)
end
function c11111039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c11111039.cfilter,1,nil,e,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c11111039.cfilter,1,1,nil,e,tp)
	e:SetLabel(sg:GetFirst():GetAttribute())
	Duel.Release(sg,REASON_COST)
end
function c11111039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11111039.thfilter(c,att)
	return c:IsAttribute(att) and c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11111039.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(c11111039.thfilter,tp,LOCATION_GRAVE,0,nil,e:GetLabel())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11111039,1)) then
	    Duel.BreakEffect()
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	    local cg=g:Select(tp,1,1,nil)
	    Duel.SendtoHand(cg,nil,REASON_EFFECT)
	    Duel.ConfirmCards(1-tp,cg)
	end	
end