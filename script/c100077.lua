--失落的圣诞
function c100077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100077)
	e1:SetCondition(c100077.condition)
	e1:SetCost(c100077.cost)
	e1:SetTarget(c100077.target)
	e1:SetOperation(c100077.activate)
	c:RegisterEffect(e1)
end
c100077.check=false
function c100077.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c100077.spfilter(c,tpe)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c100077.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	c100077.check=true
	if chk==0 then return Duel.IsExistingMatchingCard(c100077.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c100077.spfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c100077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c100077.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD+TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function c100077.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetAttacker()
	if not tg:IsRelateToEffect(e) or tg:IsStatus(STATUS_ATTACK_CANCELED)
		or not Duel.NegateAttack() then return end
	local g=Duel.GetMatchingGroup(c100077.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100077,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end