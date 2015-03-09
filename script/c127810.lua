--「刻刻帝」 二之弹（Bet）
function c127810.initial_effect(c)
	c:SetUniqueOnField(1,0,127810)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c127810.activate)
	c:RegisterEffect(e1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)    
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c127810.cost)
	e1:SetTarget(c127810.target2)
	e1:SetOperation(c127810.operation)
	c:RegisterEffect(e1)
end
function c127810.filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp)
end
function c127810.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(127810,0)) then
		local tc=Duel.SelectMatchingCard(tp,c127810.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48934760,0))
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function c127810.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fd=Duel.GetFieldCard(c:GetControler(),LOCATION_SZONE,5)
	if chk==0 then return fd and fd:IsCode(127808) and fd:IsCanRemoveCounter(c:GetControler(),0x16,2,REASON_COST) end
	local fd=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	fd:RemoveCounter(tp,0x16,2,REASON_RULE)
end
function c127810.tfilter(c)
	return c:IsSetCard(0x9fb)  and c:IsAbleToHand()
end
function c127810.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c127810.tfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c127810.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c127810.tfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
