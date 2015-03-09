--魔王少女
function c30303007.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),4,4)
	c:EnableReviveLimit()
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69000994,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(c30303007.condition)
	e2:SetCost(c30303007.cost)
	e2:SetTarget(c30303007.target)
	e2:SetOperation(c30303007.operation)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,30303007)
	e1:SetCost(c30303007.ccost)
	e1:SetCondition(c30303007.con)
	e1:SetTarget(c30303007.tg)
	e1:SetOperation(c30303007.op)
	c:RegisterEffect(e1)
end
function c30303007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c30303007.condition(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(c30303007.cfilter,1,nil,1-tp)
end
function c30303007.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c30303007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
end
function c30303007.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		local tg=g:Filter(Card.IsType,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg=tg:Select(p,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-p)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(54719828,1))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
	if e:GetLabel()==0 then
	local tg1=Duel.GetFirstMatchingCard(c30303007.filter1,1-tp,LOCATION_DECK,0,nil)
	if tg1 then
		Duel.SendtoHand(tg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,tg1)
	end
    elseif e:GetLabel()==1 then
	local tg2=Duel.GetFirstMatchingCard(c30303007.filter2,1-tp,LOCATION_DECK,0,nil)
	if tg2 then
		Duel.SendtoHand(tg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,tg2)
	end
	else
	local tg3=Duel.GetFirstMatchingCard(c30303007.filter3,1-tp,LOCATION_DECK,0,nil)
	if tg3 then
		Duel.SendtoHand(tg3,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,tg3)
	end
	end	
end

function c30303007.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c30303007.filter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c30303007.filter3(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c30303007.con(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c30303007.ccfilter(c)
	return c:IsSetCard(0xabb) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c30303007.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30303007.ccfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c30303007.ccfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.ConfirmCards(1-tp,g)
end
function c30303007.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c30303007.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
	end
end